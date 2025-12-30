---
创建时间: 2025-12-27 23:19
tags:
  - High-Performance-Computing(HPC)
status: 📝 编写中
---
这是一个非常经典的 HPC 基础项目！如果说 MPI 是**分布式内存**并行计算的基石，那么 BLAS (Basic Linear Algebra Subprograms) 就是**单节点数学计算**的引擎。

**OpenBLAS** 是目前最快、最流行的开源 BLAS 实现之一。你日常用的 NumPy, PyTorch, MATLAB 底层如果不调用 Intel MKL，通常就是在跑 OpenBLAS。

我们将延续之前的“源码构建”风格，把 OpenBLAS 安装到你的 `~/soft` 目录，并写一个 C 程序来对比**“手写矩阵乘法” vs “调用 OpenBLAS”** 的性能差异。

---

### 📅 项目规划

1. **构建环境**: 确保 Fortran 编译器存在（OpenBLAS 核心有大量汇编和 Fortran）。
    
2. **编译安装**: 从 GitHub 拉取源码编译。
    
3. **代码实战**: 编写 `blas_mm.c`，对比 naive 循环和 `cblas_dgemm` 的速度。
    
4. **链接运行**: 解决头文件和动态库链接问题。
    

---

### 🏗️ Phase 1: 编译安装 OpenBLAS

#### 1. 准备依赖

OpenBLAS 需要 Fortran 编译器。


```Bash
sudo apt update
sudo apt install git build-essential gfortran -y
```

#### 2. 下载源码


```Bash
cd ~/src
# 克隆仓库（或者下载 zip）
git clone https://github.com/OpenMathLib/OpenBLAS.git
cd OpenBLAS
# 切换到一个稳定版本 tag (可选，但推荐)
git checkout v0.3.26
```

#### 3. 编译 (Make)

OpenBLAS 的 Makefile 非常智能，会自动探测你的 CPU 架构（比如 AVX2, AVX-512 或 ARM NEON）并开启对应优化。



```Bash
# -j 指定核心数，DYNAMIC_ARCH=1 让它生成能兼容多种 CPU 的库（方便移植）
# 但如果你只在本机用，直接 make 即可，它会自动探测 Target
make -j$(nproc) DYNAMIC_ARCH=1
```

_注：在 Termux (Android ARM) 上，它会自动识别为 `TARGET=ARMV8`。_

#### 4. 安装


```Bash
# 安装到用户目录，保持系统整洁
make install PREFIX=$HOME/soft/openblas
```

安装完成后，你可以去 `$HOME/soft/openblas` 看看：

- `include/`: 只有 `cblas.h` 和 `openblas_config.h` 等。
    
- `lib/`: 有 `libopenblas.so`。
    

---

### 💻 Phase 2: 编写测试程序 (`blas_mm.c`)

我们要计算矩阵乘法 $C = A \times B$。

- **A**: $N \times N$
    
- **B**: $N \times N$
    
- **C**: $N \times N$
    

我们将比较两种方法的耗时：

1. **Naive**: 三重 `for` 循环 ($O(N^3)$)。
    
2. **BLAS**: 调用 `cblas_dgemm` (Double-precision GEneral Matrix Multiply)。
    

在 `~/HPC_Labs` (或者你存放代码的地方) 创建 `blas_mm.c`:



```C
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cblas.h> // 引入 OpenBLAS 头文件

// 辅助函数：生成随机矩阵
void random_init(double *data, int size) {
    for (int i = 0; i < size; i++) {
        data[i] = (double)rand() / RAND_MAX;
    }
}

// 朴素的三重循环矩阵乘法 (C = A * B)
void naive_matmul(int n, double *A, double *B, double *C) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            double sum = 0.0;
            for (int k = 0; k < n; k++) {
                // Row-major: A[i][k] * B[k][j]
                sum += A[i * n + k] * B[k * n + j];
            }
            C[i * n + j] = sum;
        }
    }
}

int main(int argc, char *argv[]) {
    int n = 1000; // 矩阵大小 1000x1000 (数据量 8MB x 3，刚好能塞进 L3 缓存或稍微溢出)
    if (argc > 1) n = atoi(argv[1]);

    printf("Matrix Size: %d x %d\n", n, n);
    size_t bytes = n * n * sizeof(double);

    // 分配内存
    double *A = (double *)malloc(bytes);
    double *B = (double *)malloc(bytes);
    double *C_naive = (double *)malloc(bytes);
    double *C_blas = (double *)malloc(bytes);

    srand(time(NULL));
    random_init(A, n * n);
    random_init(B, n * n);

    clock_t start, end;

    // 1. 测试 Naive 实现
    printf("Running Naive Loop implementation...\n");
    start = clock();
    naive_matmul(n, A, B, C_naive);
    end = clock();
    double time_naive = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Naive Time: %.4f seconds\n", time_naive);

    // 2. 测试 OpenBLAS 实现 (cblas_dgemm)
    // 公式: C = alpha * A * B + beta * C
    printf("Running OpenBLAS implementation...\n");
    start = clock();
    
    // 参数详解：
    // CblasRowMajor: C语言默认行主序
    // CblasNoTrans: A 不转置, B 不转置
    // n, n, n: M, N, K 维度
    // 1.0, A, n: alpha, A矩阵, A的leading dimension (列数)
    // B, n: B矩阵, B的leading dimension
    // 0.0, C_blas, n: beta, C矩阵, C的leading dimension
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, 
                n, n, n, 1.0, A, n, B, n, 0.0, C_blas, n);
                
    end = clock();
    double time_blas = (double)(end - start) / CLOCKS_PER_SEC;
    printf("OpenBLAS Time: %.4f seconds\n", time_blas);

    // 3. 计算加速比
    printf("--------------------------------\n");
    printf("Speedup: %.2fx\n", time_naive / time_blas);

    free(A); free(B); free(C_naive); free(C_blas);
    return 0;
}
```

---

### 🔗 Phase 3: 编译与链接 (Linking)

这是最容易报错的一步。因为 OpenBLAS 不在系统默认路径 (`/usr/lib`) 下，我们需要告诉 `gcc` 去哪里找头文件 (`-I`) 和库文件 (`-L`).



```Bash
# 设置 OpenBLAS 路径变量
OPENBLAS_HOME=$HOME/soft/openblas

# 编译
# -I: 指定头文件路径
# -L: 指定库文件路径
# -lopenblas: 链接 libopenblas.so
# -lpthread -lm: OpenBLAS 依赖线程库和数学库
gcc -O3 blas_mm.c -o blas_test \
    -I$OPENBLAS_HOME/include \
    -L$OPENBLAS_HOME/lib \
    -lopenblas -lpthread -lm
```

---

### 🚀 Phase 4: 运行与性能震撼

在运行之前，你必须告诉系统动态链接器 (`ld.so`) 去哪里找 `libopenblas.so`，否则会报 `error while loading shared libraries`。



```Bash
# 临时设置环境变量 (或者写入 ~/.bashrc)
export LD_LIBRARY_PATH=$HOME/soft/openblas/lib:$LD_LIBRARY_PATH

# 运行 (默认 1000x1000)
./blas_test
```

#### 预期结果 (示例)

你很可能会看到如下震撼的对比：



```Plaintext
Matrix Size: 1000 x 1000
Running Naive Loop implementation...
Naive Time: 4.5200 seconds  <-- 很慢
Running OpenBLAS implementation...
OpenBLAS Time: 0.0450 seconds <-- 极快！
--------------------------------
Speedup: 100.44x
```

### 🧠 深度解析：为什么快了 100 倍？

你可以把这些结论写入你的 **Obsidian 笔记** (`Lab-OpenBLAS.md`)：

1. **SIMD 指令集**: 你的 CPU 有 AVX2/AVX-512 单元，能一次处理 4 个或 8 个 double。Naive 循环每次只处理 1 个，且编译器很难自动向量化复杂循环。OpenBLAS 手写了汇编来榨干 SIMD。
    
2. **缓存分块 (Cache Blocking)**: 矩阵乘法是内存密集型操作。Naive 循环会频繁发生 **Cache Miss**（缓存未命中）。OpenBLAS 使用了极其精妙的 **Tiling (分块)** 技术，把小块数据锁在 L1/L2 缓存里反复使用，减少内存读写。
    
3. **多线程**: OpenBLAS 默认会开启多线程（通常等于你的物理核心数）。你可以通过环境变量控制：
    
    Bash
    
    ```
    export OPENBLAS_NUM_THREADS=1
    ./blas_test
    ```
    
    即使单线程，它通常也比 Naive 快 10-20 倍。
    

---

### 🔧 进阶任务 (Lab Challenge)

1. **改变矩阵大小**: 尝试运行 `./blas_test 2000`。注意 Naive 算法的时间是 $O(N^3)$，N 翻倍，时间会变成 8 倍！
    
2. **Python 验证**: 用 Python 的 NumPy 跑一下同样的矩阵乘法：
    
    Python
    
    ```
    import numpy as np
    import time
    N = 1000
    A = np.random.rand(N,N)
    B = np.random.rand(N,N)
    t0 = time.time()
    C = np.dot(A,B)
    print(f"NumPy time: {time.time()-t0:.4f}s")
    ```
    
    你会发现 NumPy 的速度和你的 C + OpenBLAS 程序几乎一样——**因为 NumPy 底层就在用 OpenBLAS！**
    

准备好动手了吗？先从 `git clone` 开始吧！
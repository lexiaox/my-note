---
创建时间: 2025-12-27 23:35
status: 📝 编写中
created: 2025-12-30 14:52
tags:
  - GEMM
  - HPC
  - BLAS
  - Algorithm
  - Optimization
  - C++
相关链接:
  - "[[03-Hardware-Details(底层原理)]]"
  - "[[08-Lab-Build-MPI-Source]]"
---

# 🧮 GEMM: 通用矩阵乘法原理与优化

## 1. 定义与数学形式

**GEMM (General Matrix Multiply)** 是 BLAS (Basic Linear Algebra Subprograms) 标准中 Level 3 的核心函数，也是深度学习和科学计算中最重要的“算子”。

其标准数学定义为：

$$C \leftarrow \alpha AB + \beta C$$

其中：
- $A$: $M \times K$ 矩阵
- $B$: $K \times N$ 矩阵
- $C$: $M \times N$ 矩阵
- $\alpha, \beta$: 标量系数 (Scalars)

> [!INFO] 为什么是 Level 3？
> - **Level 1**: 向量-向量运算 (比如点积)。$O(N)$ 运算，$O(N)$ 数据。
> - **Level 2**: 矩阵-向量运算 (GEMV)。$O(N^2)$ 运算，$O(N^2)$ 数据。
> - **Level 3**: 矩阵-矩阵运算 (GEMM)。$O(N^3)$ 运算，$O(N^2)$ 数据。
> **关键点**: 只有 Level 3 的计算强度足以掩盖内存读写的延迟，充分发挥 CPU/GPU 的峰值性能。

---

## 2. 核心挑战：内存墙 (Memory Wall)

对于朴素的矩阵乘法，计算逻辑非常简单，但性能通常极差。

### 朴素实现 (Naive Implementation)
$$C_{ij} = \sum_{k=0}^{K-1} A_{ik} \times B_{kj}$$

```c
// 伪代码: i-j-k 循环
for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
        for (int k = 0; k < K; k++) {
            C[i][j] += A[i][k] * B[k][j];
        }
    }
}
````

> [!FAILURE] 性能瓶颈分析
> 
> 当访问 B[k][j] 时，由于内层循环 k 在变化，我们在内存中是跳跃访问 (Strided Access) 的（假设行主序存储）。
> 
> - 这会导致大量的 **Cache Miss**。
>     
> - 每次从内存取一行数据到 Cache Line (64 Bytes)，只用了一个 float 就扔掉了，极其浪费带宽。
>     

---

## 3. 优化阶梯 (Optimization Roadmap)

要写一个高性能的 GEMM，本质上是在做 **Data Reuse (数据复用)**，让数据在 CPU 寄存器和 L1/L2 缓存中停留得越久越好。

### Level 1: 循环重排 (Loop Reordering)

策略: 将 i-j-k 改为 i-k-j。

原理: 利用 空间局部性 (Spatial Locality)。



```C
for (int i = 0; i < M; i++) {
    for (int k = 0; k < K; k++) { // k 提到中间
        float a = A[i][k];        // A 的这个值在内层循环不变，甚至可以放寄存器
        for (int j = 0; j < N; j++) {
            C[i][j] += a * B[k][j]; // B[k][j] 和 C[i][j] 都是连续访问！
        }
    }
}
```

✅ **效果**: 仅仅这一步改变，通常能带来 5-10 倍的性能提升，因为连续内存访问对 CPU 预取器 (Prefetcher) 极其友好。

### Level 2: 分块 (Tiling / Blocking)

策略: 将大矩阵切成小块（Tile），比如 $64 \times 64$。

原理: 利用 时间局部性 (Temporal Locality)。

> [!NOTE] 核心思想
> 
> L1 Cache 大小有限（例如 32KB）。如果 $N$ 很大，遍历完一行 $B$，$A$ 的数据早就被挤出 Cache 了。
> 
> 分块 保证了这三个小块 ($A_{sub}, B_{sub}, C_{sub}$) 能同时塞进 L1/L2 Cache，反复计算直到算完。

### Level 3: SIMD 向量化

策略: 使用 AVX2 / AVX-512 指令集。

原理: 单指令多数据 (Single Instruction Multiple Data)。

不使用 SIMD，CPU 一次算一个乘法。使用 AVX2 (`__m256`)，CPU 一次算 8 个 float 乘法。



```C++
// AVX2 伪代码示意
__m256 vec_a = _mm256_set1_ps(A[i][k]); // 广播 A 的一个值
__m256 vec_b = _mm256_loadu_ps(&B[k][j]); // 加载 B 的 8 个值
__m256 vec_c = _mm256_loadu_ps(&C[i][j]); // 加载 C 的 8 个值
vec_c = _mm256_fmadd_ps(vec_a, vec_b, vec_c); // FMA: a*b+c
_mm256_storeu_ps(&C[i][j], vec_c);
```

### Level 4: 内存打包 (Packing) - 高级优化

策略: 在计算前，把非连续的内存块拷贝到一块连续的临时缓冲区（Buffer）。

原理:

1. 避免 TLB (Translation Lookaside Buffer) Miss。
    
2. 避免 Cache 抖动 (Cache Conflict Misses)。
    
3. 虽然有拷贝开销，但在庞大的计算量 $O(N^3)$ 面前，这点 $O(N^2)$ 的拷贝开销可以忽略。
    

---

## 4. 性能评估模型：Roofline Model

衡量 GEMM 性能好坏，不能只看绝对时间，要看 **GFLOPS** (每秒十亿次浮点运算数)。

$$ \text{GFLOPS} = \frac{2 \times M \times N \times K}{\text{耗时(秒)} \times 10^9} $$

- **CPU 理论峰值**: 核心数 $\times$ 频率 $\times$ SIMD宽度 $\times$ FMA因子(2)。
    
- **Compute Bound (计算受限)**: 算力跑满了，内存不是瓶颈（这是 GEMM 优化的终极目标）。
    
- **Memory Bound (内存受限)**: CPU在等内存数据（Level 1/2 优化就是为了解决这个问题）。
    

---

## 5. 项目实战结构建议

在 `MyGEMM` 项目中，建议按照以下 C++ 结构进行封装：

代码段

```
classDiagram
    class Matrix {
        - float* data
        - size_t rows, cols
        + at(r, c)
        + raw_data()
    }
    class GEMM_Optimizer {
        + naive()
        + reordered()
        + tiled(block_size)
        + avx2_kernel()
    }
    Matrix ..> GEMM_Optimizer : Uses
```

## 6. 参考文献

- [GotoBLAS 论文](https://www.cs.utexas.edu/~flame/pubs/GotoTOMS_revision.pdf) (GEMM 优化的圣经)
    
- [[CSAPP]] 第六章：存储器层次结构
    

```

---

### 💡 笔记小贴士
1.  **画图**: 既然你装了 Excalidraw，强烈建议在 `Level 2: 分块` 那里画一个大正方形被切成小正方形的图，标出 $i, j, k$ 的移动方向。
2.  **链接**: 注意上面的笔记里我使用了 `[[03-Hardware-Details]]` 这样的链接，确保你的文件名是匹配的，这样点击就能跳转复习。
```
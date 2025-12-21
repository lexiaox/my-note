### 1. 提供函数原型 (Prototypes)
在调用以下动态内存函数前，编译器必须通过 `stdlib.h` 获知其签名：
- `void* malloc(size_t size);`
- `void free(void* ptr);`

> [!WARNING] 危险：地址截断
> 在 64 位 Linux (如 Termux) 中，若不包含此头文件，编译器可能将 `malloc` 返回的 64 位指针默认为 32 位 `int`，导致程序崩溃。

### 2. 核心宏定义
该头文件定义了 C 语言逻辑判断的基石：
- `#define NULL ((void *)0)`

### 3. 程序生命周期管理
- `exit()`: 立即终止程序并返回状态码。
- `EXIT_SUCCESS` / `EXIT_FAILURE`: 跨平台的标准退出状态量。

### 4. 常用功能索引
- **内存**: `malloc`, `calloc`, `realloc`, `free`
- **转换**: `atoi`, `strtol`
- **排序**: `qsort` (底层算法常用)
- **随机**: `rand`, `srand`
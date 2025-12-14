这是一份关于 **GDB (GNU Debugger)** 和 **Makefile** 的详细指南。结合你作为 CS/网络安全学生的背景，我将重点放在**Linux CLI 环境下的高效开发与调试**，涵盖了从自动化构建到底层调试的核心工作流。

---

### 核心概念速览

- **Makefile**: **构建工具**。通过定义依赖关系和规则，自动化编译过程。在大型项目中，它能避免重复编译未修改的文件，极大提高效率。
    
- **GDB**: **调试工具**。它是 Linux 下 C/C++ 开发的神器，允许你在程序运行时检查内存、寄存器、变量状态，甚至控制执行流程。
    

---

### 第一部分：Makefile —— 自动化构建

Makefile 的核心逻辑是：**目标 (Target) 依赖于某些文件 (Dependencies)，通过特定的命令 (Command) 来生成。**

#### 1. 基本语法


```Makefile
target: dependencies
[TAB] command
```

> **注意**：Makefile 中的缩进**必须使用 Tab 键**，不能用空格。

#### 2. 一个标准通用的 Makefile 模板

对于一般的 C 语言项目（例如你的 CTF 练习或课程作业），推荐使用变量来管理配置。



```Makefile
# 1. 定义编译器和编译选项
CC = gcc
# -g: 生成调试信息 (GDB 必须)
# -Wall: 开启大部分警告 (好习惯)
CFLAGS = -g -Wall

# 2. 定义目标文件和依赖
TARGET = my_program
SRCS = main.c utils.c
OBJS = $(SRCS:.c=.o)  # 自动将 .c 替换为 .o

# 3. 默认目标
all: $(TARGET)

# 4. 链接规则
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

# 5. 编译规则 (模式匹配)
# %.o: %.c 表示任意 .c 编译成对应的 .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# 6. 清理规则
clean:
	rm -f $(OBJS) $(TARGET)
```

- **`$@`**: 代表目标文件（Target）。
    
- **`$<`**: 代表第一个依赖文件。
    
- **`^`**: 代表所有依赖文件。
    

#### 3. 使用方法

在终端中运行：

- `make`: 编译项目。
    
- `make clean`: 清除生成的文件，保持目录整洁。
    

---

### 第二部分：GDB —— 深入调试

要使用 GDB 调试，编译时必须加上 `-g` 选项（如上文 Makefile 所示）。

#### 1. 启动 GDB

Bash

```
gdb ./my_program
```

#### 2. 核心命令速查表 (High Frequency)

|**类别**|**命令 (简写)**|**说明**|
|---|---|---|
|**断点**|`break main` (`b`)|在 main 函数开始处打断点|
||`b 15`|在第 15 行打断点|
||`info b`|查看所有断点|
||`delete 1` (`d`)|删除编号为 1 的断点|
|**运行**|`run` (`r`)|开始运行程序（直到遇到断点或崩溃）|
||`continue` (`c`)|继续运行直到下一个断点|
|**单步**|`next` (`n`)|单步执行（**不进入**函数内部）|
||`step` (`s`)|单步执行（**进入**函数内部）|
||`finish`|执行直到当前函数返回|
|**查看**|`print var` (`p`)|打印变量 `var` 的值|
||`p/x var`|以十六进制打印变量值 (CTF 常用)|
||`display var`|每次停顿时自动打印 `var` 的值|
||`list` (`l`)|查看当前代码上下文|
|**堆栈**|`backtrace` (`bt`)|查看函数调用栈（程序崩溃时最有用）|
||`frame 1`|切换到栈帧 1 查看当时的局部变量|

#### 3. 进阶技巧 (针对你的 CTF/RE 背景)

- 查看内存 (x 命令):
    
    格式：x/<n/f/u> <addr>
    
    - `x/10xw &variable`: 以 16 进制 (x) Word (w) 格式显示变量地址后的 10 个单元。
        
    - `x/i $pc`: 查看当前程序计数器 (PC) 指向的汇编指令。
        
- **查看寄存器**:
    
    - `info registers`: 查看所有通用寄存器。
        
    - `p $rax`: 打印 RAX 寄存器的值。
        
- TUI 模式 (Text User Interface):
    
    在 CLI 下获得类似 IDE 的体验。
    
    - 启动时：`gdb -tui ./my_program`
        
    - 运行时：按 `Ctrl + X` 然后按 `A` 切换。
        
    - 命令：`layout src` (看源码), `layout asm` (看汇编), `layout split` (双视图)。
        

---

### 第三部分：综合工作流示例

假设你在写一个 C 程序 `exploit.c`，遇到段错误 (Segmentation Fault)。

1. **编写 Makefile**: 确保包含 `-g`。
    
2. **编译**:
    
    Bash
    
    ```
    $ make
    gcc -g -Wall -c exploit.c -o exploit.o
    gcc -g -Wall -o exploit exploit.o
    ```
    
3. **启动调试**:
    
    Bash
    
    ```
    $ gdb ./exploit
    ```
    
4. **定位崩溃点**:
    
    代码段
    
    ```
    (gdb) run
    ...
    Program received signal SIGSEGV, Segmentation fault.
    0x0000000000401135 in vuln_function (input=0x0) at exploit.c:10
    10      strcpy(buffer, input);
    ```
    
5. **分析原因**:
    
    代码段
    
    ```
    (gdb) bt          # 查看谁调用了 vuln_function
    (gdb) p input     # 发现 input 是 NULL
    ```
    
6. **修复代码** -> `make` -> 验证。
    

---

### Obsidian 原始笔记数据

以下内容包含原始 Markdown 语法，请直接复制到你的 Obsidian 中。

Markdown

````
# Linux 开发基础：Makefile 与 GDB 指南

**标签**: #Linux #C语言 #GDB #Makefile #CTF #DevOps

## 1. Makefile：自动化构建

Makefile 用于管理项目的编译依赖，避免重复输入冗长的 `gcc` 命令。

### 1.1 核心语法
Makefile 规则的核心结构：
```makefile
target: dependencies
	command  <-- 必须使用 TAB 缩进
````

### 1.2 通用 C 语言 Makefile 模板

保存为 `Makefile` (注意首字母大写)。

Makefile

```
# --- 配置区域 ---
CC = gcc
# -g: 生成调试符号 (GDB 需要)
# -Wall: 开启警告
CFLAGS = -g -Wall
TARGET = app_name
SRCS = main.c utils.c
OBJS = $(SRCS:.c=.o)

# --- 规则区域 ---
# 默认目标
all: $(TARGET)

# 链接
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

# 编译 (模式规则)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# 清理
clean:
	rm -f $(OBJS) $(TARGET)
```

### 1.3 常用命令

- `make`: 构建默认目标 (all)。
    
- `make clean`: 清理编译生成的文件。
    

---

## 2. GDB：GNU Debugger

**前置条件**: 编译时必须添加 `-g` 参数 (例如 `gcc -g main.c -o main`)。

### 2.1 基础调试流程

1. **启动**: `gdb ./executable`
    
2. **设置断点**: `b main` (在 main 函数处停下) 或 `b 20` (在第 20 行停下)。
    
3. **运行**: `r` (run)。
    
4. **单步调试**:
    
    - `n` (next): 执行下一行（不进入函数）。
        
    - `s` (step): 执行下一行（进入函数）。
        
    - `c` (continue): 继续运行直到下一个断点。
        
5. **查看状态**:
    
    - `p var_name`: 打印变量值。
        
    - `bt` (backtrace): 查看函数调用栈 (崩溃时必用)。
        
    - `info locals`: 查看当前栈帧的所有局部变量。
        
6. **退出**: `q` (quit)。
    

### 2.2 针对 CTF/逆向的高级用法

- **查看内存 (`x` examine)**:
    
    - 语法: `x/nfu <address>`
        
    - `n`: 数量
        
    - `f`: 格式 (x=hex, d=decimal, s=string, i=instruction)
        
    - `u`: 单位 (b=byte, h=halfword, w=word, g=giant)
        
    - **示例**: `x/10xw &buffer` (查看 buffer 地址处的 10 个 4 字节数据，以 16 进制显示)。
        
    - **示例**: `x/5i $pc` (查看当前 PC 指针后的 5 条汇编指令)。
        
- **TUI 模式 (Text User Interface)**:
    
    - 在 GDB 内部按 `Ctrl + X` 然后按 `A`，开启源码/汇编分屏视图。
        
    - `layout split`: 同时显示源码和汇编。
        

### 2.3 调试段错误 (SegFault) 快速步骤

1. `gdb ./app`
    
2. `run` (等待程序崩溃)
    
3. `bt` (查看死在哪一行，以及调用堆栈)
    
4. `frame X` (切换到具体的栈帧)
    
5. `p variable` (检查此时的变量是否为空指针或非法值)
    

```

---

**下一步建议：**
针对你的 CTF (Pwn/Reverse) 兴趣，普通的 GDB 可能界面不够友好。要不要我介绍一下如何安装和配置 **GDB 的增强插件（如 Pwndbg 或 GEF）**？这些工具在做堆栈溢出分析时能直观地显示寄存器、堆栈和内存布局。
```


## 1. 核心概念：.h vs .c

理解模块化的关键在于区分**声明 (Declaration)** 与 **定义 (Definition)**。我们可以使用“餐厅比喻”来理解：

| 文件类型    | 后缀   | 角色     | 作用                     | 关键特征                      |
| :------ | :--- | :----- | :--------------------- | :------------------------ |
| **头文件** | `.h` | **菜单** | **声明接口**。告诉编译器有哪些函数可用。 | 结尾是分号 `;`<br>无具体代码逻辑。     |
| **源文件** | `.c` | **厨师** | **实现功能**。真正的代码逻辑所在地。   | 有花括号 `{ ... }`<br>包含具体算法。 |
| **主程序** | `.c` | **顾客** | **调用功能**。通过引用头文件来使用模块。 | 包含 `main()` 函数。           |

> [!WARNING] 常见错误
> * **错误 1**：只编译 `main.c`。
>     * 结果：报错 `undefined reference`（未定义的引用）。
>     * 原因：编译器找到了菜单（.h），但找不到厨房里的厨师（.c）。
> * **错误 2**：将函数实现代码写在 `.h` 中。
>     * 结果：若多个文件引用该头文件，报错 `multiple definition`（重复定义）。

## 2. 关键预处理指令

### #define (宏定义)
用于文本替换。
~~~c
#define PI 3.14159      // 定义常量
#define MAX_SIZE 100
~~~

### Include Guards (头文件卫士)
**必背模板**。用于防止头文件被重复包含（Double Inclusion）。

~~~c
#ifndef MY_HEADER_H   // "If Not Defined": 如果这个标记还没存在...
#define MY_HEADER_H   // "Define": 那就定义它，并继续读取下面的内容...

// --- 头文件的具体内容写在这里 ---
// struct Point { ... };
// void my_function();

#endif                // "End If": 结束条件
~~~

## 3. 实战代码结构

### 第一步：编写头文件 (`tool.h`)
~~~c
#ifndef TOOL_H
#define TOOL_H

// 声明函数
void say_hello();
int add(int a, int b);

#endif
~~~

### 第二步：编写实现文件 (`tool.c`)
~~~c
#include <stdio.h>
#include "tool.h"  // 包含对应的头文件

// 实现函数
void say_hello() {
    printf("Hello C Language!\n");
}

int add(int a, int b) {
    return a + b;
}
~~~

### 第三步：编写主程序 (`main.c`)
~~~c
#include <stdio.h>
#include "tool.h"  // 包含头文件

int main() {
    say_hello();
    int sum = add(10, 5);
    printf("Result: %d\n", sum);
    return 0;
}
~~~

## 4. 编译指令

在终端中，必须将所有涉及的 `.c` 文件一起编译：

~~~bash
gcc main.c tool.c -o my_app
./my_app
~~~
# VSCode 文件配置指南

## 一  Task.json

### 1. Task 是什么？

VS Code 的 Task 就是：
 **把你平时敲在终端里的命令写进一个 JSON 文件，让 VS Code 帮你一键执行。**

你以前可能这样编译 C++：

```bash
clang++ main.cpp -o main
```

有了 Task，你按一下 **⌘ + Shift + B** 就能让 VS Code 自动做这件事。

Task 可以做：

- 编译 C++（最常见）
- 清理生成文件（rm）
- 调用 make
- 调用 cmake
- 运行 python、shell script
- 自动执行测试
- watch 文件变化自动编译

也就是说 **Task = 把命令自动化，让 VS Code 来跑脚本。**

### 2. Task 文件在哪里？

在你的项目文件夹下：

```
.vscode/tasks.json
```

如果这个文件不存在，你自己建一个：

```
mkdir .vscode
touch .vscode/tasks.json
```

###  3. 任务触发方式（非常重要）

VS Code 有 3 种方式调用任务：

#### **① 按 ⌘ + Shift + B**

执行默认的 "build" 类型任务
 （必须把 task 的 `group.kind: "build"` + `isDefault: true`）

#### **② 手动运行**

点击左上角菜单：

```
Terminal → Run Task...
```

#### **③ 被其他任务或调试调用**

例如 `launch.json` 里：

```json
"preLaunchTask": "build"
```

表示调试前自动执行名为 build 的任务。

### 4. Task 的最核心结构是什么？

先给你一个最小示例：

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build",
      "type": "shell",
      "command": "/usr/bin/clang++",
      "args": [
        "-std=c++17",
        "main.cpp",
        "-o",
        "main"
      ],
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": ["$gcc"]
    }
  ]
}
```

现在开始逐项讲解。

### 5. Task 的字段逐条讲解

#### **① `label`: 任务的名字**

```json
"label": "build"
```

- 随便取
- 但 launch.json 里引用它（preLaunchTask）必须一致

------

#### **② `type`: 任务类型**

```json
"type": "shell"
```

两种：

| 类型        | 作用                            |
| ----------- | ------------------------------- |
| `"shell"`   | 在 shell 中运行命令（支持管道 ` |
| `"process"` | 直接执行某个命令，不通过 shell  |

大部分情况用 `"shell"`，因为更灵活。

#### **③ `command`: 要执行的命令**

```json
"command": "/usr/bin/clang++"
```

也可以写：

```json
"command": "clang++"
```

但**绝对路径更稳定**，因为避免 VS Code 找不到命令。

#### **④ `args`: 参数数组**

```json
"args": [
  "-std=c++17",
  "main.cpp",
  "-o",
  "main"
]
```

等价终端命令：

```
clang++ -std=c++17 main.cpp -o main
```

------

#### **⑤ `group`: 指定任务类型（build / test）**

```json
"group": {
  "kind": "build",
  "isDefault": true
}
```

这表示：

- 这个任务是 **构建任务**
- 这是默认构建任务 → ⌘+Shift+B 执行它

这两句组合非常重要。

**目前**，VS Code 官方文档中列出的主要预定义 `kind` 就是 `"build"` 和 `"test"`

#### **⑥ `problemMatcher`: 让编译错误可点跳转**

```json
"problemMatcher": ["$gcc"]
```

让 VS Code 识别 clang/gcc 输出，并把错误显示在：

- Problems 面板
- 源代码下红色波浪线

常用内置：

- `$gcc`（也适用于 clang）
- `$eslint`
- `$tsc`

#### **⑦ `presentation`: 控制任务输出**

例如：

```json
"presentation": {
  "reveal": "always",
  "panel": "shared",
  "focus": false
}
```

- 是否自动显示输出窗口
- 控制输出显示在哪个 panel

*非必要，但很实用*

#### **⑧ `dependsOn`: 让任务互相依赖**

比如你想：

先 clean → 再 build

```json
"dependsOn": ["clean"]
```

#### **⑨ `options`: 改变 CWD 或环境变量**

```json
"options": {
  "cwd": "${workspaceFolder}/src"
}
```

或添加环境变量：

```json
"options": {
  "env": {
    "PATH": "/usr/local/bin:${env:PATH}"
  }
}
```

### 6. 常用 Task 模板

####  **模板 1：编译单个 main.cpp**

```json
{
  "label": "build",
  "type": "shell",
  "command": "clang++",
  "args": ["main.cpp", "-o", "main", "-std=c++17"],
  "group": { "kind": "build", "isDefault": true },
  "problemMatcher": ["$gcc"]
}
```

#### **模板 2：编译 src/\*.cpp 到 bin/main**

假设你的结构：

```
src/
bin/
{
  "label": "build",
  "type": "shell",
  "command": "clang++",
  "args": [
    "-std=c++17",
    "${workspaceFolder}/src/*.cpp",
    "-o",
    "${workspaceFolder}/bin/main"
  ],
  "group": { "kind": "build", "isDefault": true },
  "problemMatcher": ["$gcc"]
}
```

#### **模板 3：clean 任务**

```json
{
  "label": "clean",
  "type": "shell",
  "command": "rm",
  "args": ["-f", "${workspaceFolder}/bin/main"]
}
```

###  7. VS Code 中 Task 的常用变量

| **变量名**                       | **描述**                                         | **示例值**                           |
| -------------------------------- | ------------------------------------------------ | ------------------------------------ |
| **`${workspaceFolder}`**         | 当前工作区（最顶层文件夹）的路径。               | `/Users/username/project`            |
| **`${workspaceFolderBasename}`** | 当前工作区文件夹的名称（不带路径）。             | `project`                            |
| **`${file}`**                    | 当前打开的活动文件的完整路径。                   | `/Users/username/project/src/app.js` |
| **`${fileDirname}`**             | 当前活动文件的目录路径。                         | `/Users/username/project/src`        |
| **`${relativeFile}`**            | 当前活动文件相对于 `${workspaceFolder}` 的路径。 | `src/app.js`                         |
| **`${fileBasename}`**            | 当前活动文件的文件名（包括扩展名）。             | `app.js`                             |
| **`${fileBasenameNoExtension}`** | 当前活动文件的文件名（不包括扩展名）。           | `app`                                |
| **`${fileExtname}`**             | 当前活动文件的扩展名（包括点 `.`）。             | `.js`                                |



## 二 Launch.json

###  1.launch.json 是什么？

tasks.json 是负责编译，
launch.json 是负责运行/调试。

它不负责编译代码，
 它只解决：

- 要运行哪个可执行文件？
- 运行时要带哪些输入？
- 调试器用谁？LLDB？GDB？
- 程序报错时要不要停下来？
- 程序的工作目录在哪？

### 2. launch.json 的基本结构

launch.json 的框架：

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            // ① 配置名字（随便取）
            "name": "Debug OI Program",
            // ② 语言类型 (cppdbg 是 C++ 调试器扩展)
            "type": "cppdbg",
            // ③ 调试请求类型 — launch = 启动程序
            "request": "launch",

            // ④ 要运行的可执行文件
            "program": "${workspaceFolder}/main",

            // ⑤ 给程序的命令行参数（OI 常用）
            "args": [],

            // ⑥ 程序运行时的当前目录
            "cwd": "${workspaceFolder}",

            // ⑦ 是否在 main 函数入口停下
            "stopAtEntry": false,

            // ⑧ macOS 默认使用 LLDB
            "MIMode": "lldb",

            // ⑨ 是否要外部终端
            "externalConsole": false
        }
    ]
}
```

###  3.逐字段解释

#### ① `"name"` – 配置名称

它只是 VS Code 调试界面的一个“名字”。

例如：

```json
"name": "Debug OI Program"
```

不影响运行。

#### ② `"type": "cppdbg"`

macOS 上 OI C++ 调试插件一般用 lldb。

```json
"type": "lldb"
```

------

####  ③ `"request": "launch"`

launch.json 有两种方式：

- `"launch"`：VS Code 启动你的程序
- `"attach"`：VS Code 附加到已有进程（一般不用）

OI 选第一个：

```json
"request": "launch"
```

------

#### ④ `"program"` — 要运行的可执行文件

这个字段最重要。

```json
"program": "${workspaceFolder}/main"
```

解释：

`${workspaceFolder}` = 你打开的项目根目录
 `main` = tasks.json 编译生成的可执行文件

即 VS Code 最终执行：

```
./main
```

------

####  ⑤ `"args"` — 命令行参数

OI 有两种输入方式：

------

##### **① 标准输入（cin / scanf）**

这种不用写 args，直接从控制台输入。

------

##### **② 带输入文件（freopen）**

例如你写：

```cpp
freopen("input.txt", "r", stdin);
freopen("output.txt", "w", stdout);
```

那么运行时就不需要 args，只要保证工作目录正确（后面讲 cwd）。

------

##### **③ OI 类命令行输入示例（有些题会用）**

如果题目要求：

```
./main 100 200
```

你就在 args 放：

```json
"args": ["100", "200"]
```

VS Code 自动帮你传进去。

------

#### ⑥ `"cwd"` — 运行时的工作目录

工作目录影响：

- `freopen("input.txt")`
- `ifstream("a.in")`
- `ofstream("a.out")`
- 相对路径文件加载

OI 通常希望 **你的 input.txt 就放在项目根目录**。

所以：

```json
"cwd": "${workspaceFolder}"
```

如果你不设对，freopen 会找不到文件。

------

####  ⑦ `"stopAtEntry"` — 是否在程序开始就停下

OI 不需要调试一开始就停。

```json
"stopAtEntry": false
```

如果你想研究程序从 main 前的表现，可以改成 true。

####  ⑧ `"MIMode": "lldb"` – macOS 的调试器

macOS 默认使用 **LLDB**（不像 Linux 用 GDB）

所以写：

```json
"MIMode": "lldb"
```

不写也能运行，但推荐写清楚。

------

#### ⑨ `"externalConsole"` – 是否打开外部终端

OI 一般希望直接在 VS Code 终端看输出：

```json
"externalConsole": false
```

如果你想像 CodeBlocks 那样弹出一个黑色终端：

```json
"externalConsole": true
```

### 4：OI launch模版示例

#### **基础版（直接 cin/cout）**

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug OI Program",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/main",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "MIMode": "lldb",
            "externalConsole": false
        }
    ]
}
```

------

#### **使用测试文件 input.txt / output.txt（常见 OI 测试方式）**

C++ 代码（典型 OI 写法）：

```cpp
freopen("input.txt", "r", stdin);
freopen("output.txt", "w", stdout);
```

launch.json 只要保证 cwd 就行：

```json
"cwd": "${workspaceFolder}"
```

------

#### **带命令行参数的 OI 示例**

如果题目要求：

```
./main 10 20
```

配置：

```json
"args": ["10", "20"]
```

###  5.实质运行流程

你按 F5 时：

1. VS Code 读取 launch.json
2. 找到你点的那条 configuration
3. 执行 `"program"` 指定的文件
   - 运行方式由 `"MIMode"`（LLDB）控制
4. 把 `"args"` 给程序
5. 把 `"cwd"` 设置成运行目录（影响 freopen、相对路径）
6. 打开调试界面（断点、变量、堆栈）

**它不编译程序。**
 **它只运行 + 调试。**

（编译在 tasks.json ）

------

### 6.运行前自动编译

launch.json 可以自动触发 tasks.json：

```json
"preLaunchTask": "build"
```

完整配置：

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug OI Program",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/main",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "MIMode": "lldb",
            "externalConsole": false,
            "preLaunchTask": "build"
        }
    ]
}
```

这会让 F5 的行为变成：

1. 先自动编译（tasks.json）
2. 再调试（launch.json）



## 三 模版

### tasks.json

```json
{
    "version": "2.0.0",  // 指定任务配置文件的版本，这里使用 VS Code 推荐的 2.0 版本
    "tasks": [  // 定义一个任务列表
        {
            "label": "C++: Build",  // 任务的名称，用于在 VS Code 中显示
            "type": "shell",  // 任务类型为 shell，即在终端执行命令
            "command": "clang++",  // 要执行的命令，这里是 C++ 编译器 clang++
            "args": [  // 命令行参数列表
                "-std=c++17",  // 指定 C++ 标准为 C++17
                "-g",  // 生成调试信息，方便调试
                "-Wall",  // 开启所有警告
                "-Wextra",  // 开启额外的警告
                "${file}",  // 当前打开的文件
                "-o",  // 指定输出文件
                "${fileDirname}/${fileBasenameNoExtension}"  // 输出文件路径和文件名（不带扩展名）
            ],
            "options": {  // 执行命令时的选项
                "cwd": "${fileDirname}"  // 设置当前工作目录为当前文件所在目录
            },
            "problemMatcher": [  // 用于解析编译器输出的错误和警告
                "$gcc"  // 使用 VS Code 内置的 GCC/Clang 问题匹配器
            ],
            "group": {  // 指定任务分组
                "kind": "build",  // 属于 build（构建）任务组
                "isDefault": false  // 不是默认构建任务
            },
            "presentation": {  // 任务输出的显示方式
                "echo": true,  // 显示执行的命令
                "reveal": "always",  // 总是显示终端面板
                "focus": false,  // 执行任务时不自动聚焦终端
                "panel": "shared",  // 所有任务共用一个终端面板
                "showReuseMessage": false  // 不显示复用终端的提示信息
            }
        },
        {
            "label": "C++: Clean",  // 任务名称，用于清理生成的可执行文件
            "type": "shell",  // 在终端执行
            "command": "rm",  // 删除文件命令（Linux/macOS）
            "args": [
                "-rf",  // 强制删除，不提示
                "${fileDirname}/${fileBasenameNoExtension}",  // 要删除的目标文件（可执行文件）
                "${fileDirname}/${fileBasenameNoExtension}.dSYM" // 删除调试符号目录（.dSYM 文件夹）
            ],
            "options": {
                "cwd": "${fileDirname}"  // 当前工作目录
            },
            "presentation": {
                "echo": true,  // 显示命令
                "reveal": "silent",  // 执行时不自动显示终端
                "focus": false,
                "panel": "shared",
                "showReuseMessage": false
            }
        },
        {
            "type": "cppbuild",  // 指定任务类型为 C++ 构建
            "label": "C/C++: clang build active file",  // 任务名称
            "command": "/usr/bin/clang",  // 使用系统 clang 编译器
            "args": [
                "-fcolor-diagnostics",  // 输出彩色诊断信息
                "-fansi-escape-codes",  // 使用 ANSI 转义码增强终端显示
                "-g",  // 生成调试信息
                "${file}",  // 当前文件
                "-o",  // 输出选项
                "${fileDirname}/${fileBasenameNoExtension}"  // 输出可执行文件路径
            ],
            "options": {
                "cwd": "${fileDirname}"  // 当前工作目录
            },
            "problemMatcher": [
                "$gcc"  // 使用 GCC/Clang 问题匹配器
            ],
            "group": {
                "kind": "build",  // 构建任务
                "isDefault": true  // 设置为默认构建任务
            },
            "detail": "Task generated by Debugger."  // 任务说明，这里是调试器自动生成的
        }
    ]
}

```



### launch.json

```json
{
    // VSCode 调试配置文件
    "version": "0.2.0", // 配置文件版本
    "configurations": [
        {
            "name": "C++: Debug (Integrated Terminal)", // 集成终端调试（需要 CodeLLDB 扩展）
            "type": "lldb", // 使用 lldb 调试类型（需安装 CodeLLDB 扩展）
            "request": "launch", // 启动类型为 launch（启动程序）
            "program": "${fileDirname}/${fileBasenameNoExtension}", // 要调试的程序路径
            "args": [], // 程序运行参数（可以在此添加命令行参数）
            "cwd": "${fileDirname}", // 设置工作目录为当前文件所在目录
            "terminal": "integrated", // 使用 VSCode 集成终端（输入输出在底部终端面板）
            "preLaunchTask": "C++: Build", // 调试前先执行编译任务
            "postDebugTask": "C++: Clean" // 调试结束后执行清理任务，删除编译文件
        }
    ]
}
```










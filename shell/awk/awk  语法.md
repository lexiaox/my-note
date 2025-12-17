### 1. AWK 简介

`awk` 是一种编程语言，它允许你处理存储在文件中的信息。它扫描文件中的每一行，查找与指定模式相匹配的内容，然后执行相应的操作。

`awk` 的名字来源于它的三位创始人：**A**lfred Aho、Peter **W**einberger 和 Brian **K**ernighan。

### 2. AWK 的基本结构

一个 `awk` 程序通常由一系列 **模式-动作** 对组成：



```Bash
awk 'pattern { action }' input-file
```

- **`pattern` (模式):** 用于指定 `awk` 在输入行中查找的内容。如果省略，则匹配每一行。
    
- **`action` (动作):** 在找到匹配的模式时执行的一系列命令（指令）。如果省略，则默认执行 `{ print $0 }`（打印整行）。
    
- **`input-file` (输入文件):** 要处理的文件。数据也可以来自标准输入（`stdin`）或管道的输出。
    

### 3. AWK 的工作原理

`awk` 会逐行读取输入。对于每一行：

1. **分割记录（行）**：默认情况下，输入行由换行符分隔。
    
2. **分割字段（域）**：每一行又会被分割成若干字段（或称为域），默认情况下，字段由**任意空白字符**（空格或制表符）分隔。
    
3. **模式匹配**：`awk` 检查该行是否符合程序中指定的模式。
    
4. **执行动作**：如果匹配成功，则执行对应的动作。
    

### 4. 常用内置变量（预定义变量）

`awk` 有许多内置变量，其中最常用的是：

| **变量名**        | **描述**                                          |
| -------------- | ----------------------------------------------- |
| **`$0`**       | 当前记录（整行）的文本内容。                                  |
| **`$n`**       | 当前记录的第 **n** 个字段（域），例如 `$1` 是第一个字段，`$2` 是第二个字段。 |
| **`NF`**       | 当前记录（行）中的**字段数**（Number of Fields）。             |
| **`NR`**       | 当前记录（行）的**行号**（Number of Record）。               |
| **`FNR`**      | 与 `NR` 类似，但它记录的是**当前文件**的行号。                    |
| **`FS`**       | 输入字段分隔符（Field Separator），默认是任意空白字符。             |
| **`OFS`**      | 输出字段分隔符（Output Field Separator），默认是一个空格。        |
| **`RS`**       | 输入记录分隔符（Record Separator），默认是换行符。               |
| **`ORS`**      | 输出记录分隔符（Output Record Separator），默认是换行符。        |
| **`FILENAME`** | 当前正在处理的输入文件名。                                   |

### 5. 核心命令和用法

#### A. 打印 (`print`)

最常见的操作是打印。

- **打印整行：**
    
    
    
    ```Bash
    awk '{ print $0 }' filename
    # 或省略动作：
    awk '1' filename
    ```
    
- **打印指定的字段：**
    
    
    
    ```Bash
    awk '{ print $1, $3 }' filename  # 打印第一个和第三个字段
    # 注意：字段间用逗号 `,` 分隔，输出时会使用 OFS（默认空格）连接。
    ```
    
- **打印字段数：**
    
    
    
    ```Bash
    awk '{ print NF }' filename # 打印每一行的字段数量
    ```
    

#### B. 指定分隔符 (`-F` 或 `FS`)

如果文件的字段不是由默认的空白字符分隔（例如 CSV 文件使用逗号 `,`），你需要指定分隔符。

- **使用 `-F` 选项：**
    
    
    
    ```Bash
    # 使用逗号作为输入字段分隔符
    awk -F ',' '{ print $1, $2 }' csv_file.txt
    ```
    
- **使用 `BEGIN` 块中的 `FS` 变量：**
    
    Bash
    
    ```
    awk 'BEGIN { FS=":"; } { print $1 }' /etc/passwd # 使用冒号作为分隔符
    ```
    

#### C. 特殊模式（`BEGIN` 和 `END`）

- **`BEGIN` 模式:** 在读取任何输入之前执行的操作，常用于设置变量或打印标题。
    
    Bash
    
    ```
    awk 'BEGIN { print "--- 报告开始 ---"; OFS="\t" } { print $1, $2 } END { print "--- 报告结束 ---" }' filename
    ```
    
- **`END` 模式:** 在读取完所有输入后执行的操作，常用于计算总数或打印总结。
    
    Bash
    
    ```
    awk '{ total += $4 } END { print "第四列总和:", total }' filename
    ```
    

#### D. 模式匹配

模式可以是正则表达式、关系表达式或特殊块。

- **正则表达式匹配（包含）：**
    
    Bash
    
    ```
    # 打印所有包含 "error" 字符串的行
    awk '/error/ { print $0 }' log_file
    ```
    
- **正则表达式匹配（不包含）：**
    
    Bash
    
    ```
    # 打印所有不包含 "warning" 字符串的行
    awk '!/warning/' log_file
    ```
    
- **关系表达式：**
    
    Bash
    
    ```
    # 打印行号大于 10 的行
    awk 'NR > 10 { print $0 }' filename
    # 打印第一个字段等于 "Smith" 的行
    awk '$1 == "Smith" { print $0 }' filename
    ```
    
- **组合模式（布尔运算符）：** `&&` (和), `||` (或), `!` (非)
    
    Bash
    
    ```
    # 打印行号在 5 到 10 之间（包含 5 和 10）的行
    awk 'NR >= 5 && NR <= 10 { print $0 }' filename
    ```
    

### 6. AWK 控制语句

`awk` 提供了类似于 C 语言的逻辑结构。

- **`if-else` 语句：**
    
    Bash
    
    ```
    awk '{ if ($4 > 100) { print $1, "超过预算" } else { print $1, "在预算内" } }' filename
    ```
    
- **`next` 语句：** 跳过当前行的剩余动作，并读取下一行输入。
    
    Bash
    
    ```
    # 如果第一个字段是 "skip"，则跳过该行
    awk '$1 == "skip" { next } { print $0 }' filename
    ```
    
- **`exit` 语句：** 退出主输入循环，并进入 `END` 块（如果存在）。
    
    Bash
    
    ```
    # 读取前 5 行后退出
    awk 'NR == 5 { exit } { print $0 }' filename
    ```
    

---

### 💡 可以复制的版本 (纯文本)

应你的要求，这里是你可以直接复制到笔记中的纯文本版本：

```markdow
# AWK 用法笔记

## 1. AWK 简介
AWK是一种强大的文本处理语言，用于扫描文件中的行，查找匹配的模式，并执行相应的动作。

## 2. 基本语法结构
awk 'pattern { action }' input-file

## 3. 常用内置变量
- $0：当前整行记录。
- $n：第 n 个字段（域）。
- NF：当前行的字段数量。
- NR：当前记录（输入行）的总行号。
- FNR：当前文件的行号。
- FS：输入字段分隔符（默认是任意空白字符）。
- OFS：输出字段分隔符（默认是一个空格）。

## 4. 核心命令和用法
### A. 打印
- 打印整行：
  awk '{ print $0 }' filename
- 打印第1和第3个字段：
  awk '{ print $1, $3 }' filename

### B. 指定分隔符
- 使用 -F 选项：
  awk -F ',' '{ print $1, $2 }' csv_file.txt
- 使用 BEGIN 块：
  awk 'BEGIN { FS=":"; } { print $1 }' /etc/passwd

### C. 特殊模式
- BEGIN：在读取输入前执行。
  awk 'BEGIN { print "标题" }'
- END：在读取所有输入后执行。
  awk '{ sum += $4 } END { print "总和:", sum }' filename

### D. 模式匹配
- 正则表达式匹配（包含）：
  awk '/error/' log_file
- 关系表达式匹配：
  awk 'NR > 10' filename
- 组合模式：
  awk '$1 == "user" && $NF > 50' filename
```





/ /的 用法：[[awk 补充]]
begin ,end 的用法:[[AWK 中 `BEGIN` 和 `END` 块用法笔记]]
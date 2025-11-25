# Linux grep 命令详解

`grep` (Global Regular Expression Print) 用于在文件中搜索符合条件的字符串或正则表达式。

## 1. 核心场景
- **查代码**：在这个项目里，哪里调用了 `main()` 函数？
- **查日志**：日志文件里有没有 "Error" 报错？
- **查进程**：现在系统里运行了什么服务？

## 2. 核心语法
`grep [参数] "搜索内容" [文件路径]`

## 3. 常用参数 (Cheat Sheet)

| 参数 | 含义 | 场景示例 |
| :--- | :--- | :--- |
| **`-i`** | **忽略大小写** | `grep -i "error" app.log` (Error, error 都能搜到) |
| **`-r`** | **递归搜索** | `grep -r "TODO" .` (搜当前目录及子目录下所有文件) |
| **`-n`** | **显示行号** | `grep -n "main" test.c` (输出: `10: int main()`) |
| **`-v`** | **反向查找** | `grep -v "200 OK" access.log` (排除正常请求，只看异常) |
| **`-w`** | **全字匹配** | `grep -w "is" file` (只搜 "is"，不搜 "this") |
| **`-l`** | **只显文件名**| `grep -r -l "config" .` (只看哪些文件里有，不看具体内容) |

## 4. 进阶神技：上下文 (-A, -B, -C)
在看报错日志时，光看报错那一行没用，通常需要看它**前面**发生了什么，或**后面**的堆栈信息。

- `-A 5` (After): 显示匹配行 + 后面 5 行
- `-B 5` (Before): 显示匹配行 + 前面 5 行
- `-C 5` (Context): 显示匹配行 + 前后各 5 行

**示例：**
~~~bash
# 搜索 "Exception" 及其前后 5 行上下文
grep -C 5 "Exception" error.log
~~~

## 5. 实战组合拳 (IT 民工/运维常用)

### 5.1 查进程 (ps + grep)
最经典的用法，查看 python 脚本跑起来没有：
~~~bash
ps aux | grep python
~~~
*小技巧：如果不想要 grep 自己那一行，可以加 `grep -v grep`*

### 5.2 实时过滤日志 (tail + grep)
实时监控日志，但只看报错信息：
~~~bash
tail -f /var/log/syslog | grep --line-buffered "Error"
~~~

### 5.3 统计数量 (-c)
统计一下这个文件里出现了多少次 "404"：
~~~bash
grep -c "404" access.log
~~~

### 5.4 结合 find (精准打击)
只在 `.c` 文件中搜索 "include"，忽略其他类型文件：
~~~bash
find . -name "*.c" | xargs grep "include"
~~~

## 6. 正则表达式基础 (-E)
`grep` 支持正则，能做模糊匹配。建议加上 `-E` (Extended) 参数以支持更多符号。

- `^` : 行首。 `grep "^root" /etc/passwd` (搜以 root 开头的行)
- `$` : 行尾。 `grep ";$" test.c` (搜以分号结尾的行)
- `.` : 任意字符。

## 7. 现代化替代品：ripgrep (rg)
如果你喜欢 `fd`，那你一定会爱上 `rg`。

- **速度**：比 grep 快数倍（Rust 编写）。
- **智能**：默认忽略 `.gitignore` 和隐藏文件。
- **美观**：自带行号和高亮。

**Termux 安装：** `pkg install ripgrep`
**用法：** `rg "main"` (就这么简单，默认递归)
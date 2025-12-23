

## 1. 核心语法
# `find [查找路径] [查找条件] [处理动作]`

- **路径**：例如 `.` (当前目录), `/var/log` (指定目录), `/` (全盘)。
- **条件**：文件名、大小、权限、时间等。
- **动作**：默认是打印路径，也可以是删除、执行脚本等。

## 2. 常用查找条件 (Cheat Sheet)

| 场景      | 参数          | 示例                                | 说明                 |
| :------ | :---------- | :-------------------------------- | :----------------- |
| **按名称** | `-name`     | `find . -name "*.c"`              | 查找所有 .c 文件 (区分大小写) |
|         | `-iname`    | `find . -iname "config.xml"`      | 忽略大小写查找            |
| **按类型** | `-type`     | `find . -type f`                  | 只找文件 (file)        |
|         |             | `find . -type d`                  | 只找目录 (directory)   |
| **按大小** | `-size`     | `find . -size +100M`              | 查找大于 100MB 的文件     |
|         |             | `find . -size -10k`               | 查找小于 10KB 的文件      |
| **按深度** | `-maxdepth` | `find . -maxdepth 2 -name "*.md"` | 只向下搜 2 层目录 (性能优化)  |
| **空文件** | `-empty`    | `find . -type d -empty`           | 查找空目录 (适合清理垃圾)     |

## 3. 时间相关 (非常重要)
用于排查 "最近谁动了代码" 或 "清理旧日志"。

- **`-mtime` (修改时间)**: 文件内容被修改的时间。
- **`-atime` (访问时间)**: 文件被读取的时间。
- **`-ctime` (状态时间)**: 权限或所有权被修改的时间。

**示例：**
- `find . -mtime -7` : 查找 **7天内** 修改过的文件 (负号代表以内)。
- `find . -mtime +30` : 查找 **30天前** 修改过的文件 (正号代表以前)。

## 4. 权限与用户 (CTF/运维常用)

- `find / -user www-data` : 查找属于 www-data 用户的文件 (WebShell 排查)。
- `find / -perm -4000` : 查找 SUID 文件 (CTF 提权常用)。
- `find . -perm 777` : 查找权限为 777 的不安全文件。

## 5. 核心杀手锏：-exec (执行操作)
找到文件后，直接对它们执行命令。

**语法结构：**
`find . -name "*.log" -exec rm -rf {} \;`

- `{}` : 这是一个占位符，代表 find 找到的每一个文件名。
- `\;` : 命令的结束符 (在 Shell 中必须转义)。

**实战示例：**

1. **批量修改权限**：将所有 `.sh` 脚本加上执行权限

   ```bash
   find . -name "*.sh" -exec chmod +x {} \;
	```

2. **代码搜索 (结合 grep)**：在所有 `.c` 文件中搜索 "main"

```bash
    find . -name "*.c" -exec grep -H "main" {} \;
```

3. **清理 Git 冲突文件**：(Obsidian 同步冲突时很有用)

  ```bash
    # 查找所有包含 "conflicted copy" 的文件并列出
    find . -name "*conflicted copy*" 
    # 确认无误后删除
    # find . -name "*conflicted copy*" -delete   

```


## 6. 排除目录 (Prune)

在 Git 仓库中搜索时，通常不想搜 `.git` 目录。
```
### 在当前目录查找 main.c，但跳过 .git 目录
```bash
find . -path "./.git" -prune -o -name "main.c" -print
```


```

---

## 附录：IT 民工/Termux 专属技巧

### 1. Termux 快速清理

手机存储有限，清理缓存文件：

# 查找并删除所有 .tmp 结尾的临时文件

```bash
find . -name "*.tmp" -type f -delete
```


### 2. C 语言项目一键清理

编译后会生成很多 `.o` 文件或 `a.out`：

# 一键清理编译产物 (注意：-o 表示 OR)

```bash
find . -name "*.o" -o -name "a.out" -delete

```

### 3. 现代化替代品：fd

如果你觉得 `find` 语法太难记，且在 Termux 环境下：
```bash
1. 安装：`pkg install fd`
    
2. 特点：默认忽略 `.gitignore`，速度快，自带颜色。
   
```
 
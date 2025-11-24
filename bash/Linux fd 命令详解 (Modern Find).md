
`fd` 是一个简单、快速且用户友好的 `find` 命令替代品（用 Rust 编写）。

## 1. 为什么用 fd？
- **语法简单**：不用写 `find . -name`，直接写名字。
- **速度极快**：利用多核并行搜索。
- **智能忽略**：默认**自动忽略** `.gitignore` 中的文件和隐藏文件/目录（比如 `.git`），这在管理代码仓库时非常有用。
- **彩色输出**：文件名、目录名颜色区分明显。

## 2. 安装
- **Termux (Android)**: `pkg install fd`
- **Ubuntu/Debian**: `apt install fd-find`
  *(注意：在 Debian/Ubuntu 下命令名为 `fdfind`，建议设置别名 `alias fd=fdfind`)*
- **MacOS**: `brew install fd`
- **Windows**: `scoop install fd`

## 3. 常用命令对比 (Cheat Sheet)

| 功能 | 传统 find | 现代 fd |
| :--- | :--- | :--- |
| **基本搜索** | `find . -name "*pat*"` | `fd pat` |
| **模糊搜索** | `find . -iname "*pat*"` | `fd pat` (默认智能大小写) |
| **指定扩展名** | `find . -name "*.c"` | `fd -e c` |
| **包含隐藏文件**| (默认包含) | `fd -H pat` (Hidden) |
| **包含忽略文件**| (默认包含) | `fd -I pat` (No Ignore) |
| **执行命令** | `find . -exec rm {} \;` | `fd -x rm` |

## 4. 实战场景 (IT民工/CTF版)

### 4.1 找代码文件
只找 `.c` 文件，且文件名里包含 "sock"：
```bash
fd -e c sock
````

### 4.2 搜索 Obsidian 配置 (涉及隐藏文件)

Obsidian 的插件和配置都在 .obsidian 文件夹里（默认是隐藏的）。

如果要找 appearance.json：

Bash

```
# -H 表示搜索隐藏目录
fd -H appearance
```

### 4.3 批量删除/操作 (-x)

**核心参数 `-x` (exec)**：相比 `find` 的 `-exec {} \;`，`fd` 的 `-x` 更直观。

**场景：删除所有 `.bak` 备份文件**

Bash

```
fd -e bak -x rm
```

_(解释：找到每一个以 .bak 结尾的文件，自动作为参数传给 rm)_

场景：转换图片格式

把所有 jpg 图片转换成 png (假设安装了 convert 工具)：

Bash

```
# {} 是占位符，{.}.png 表示去掉后缀并加上 .png
fd -e jpg -x convert {} {.}.png
```

### 4.4 排除特定目录 (-E)

搜全盘文件，但不想看庞大的 `node_modules` 目录：

Bash

```
fd pattern -E node_modules
```

## 5. 小结

- **日常查找**：首选 `fd`，因为它快且命令短。
    
- **复杂运维**：如果需要按“修改时间”或“权限”查找（比如找 7 天前的文件），还是得用 `find`，因为 `fd` 专注于文件名搜索。
    



### 💡 给你的额外建议

因为你在 Termux 上用，建议你在 `.bashrc` 或 `.zshrc` 里加个别名，把 `find` 的部分习惯迁移过来。

如果你习惯了用 `ll` 查看列表，可以把 `fd` 和 `ls` 结合起来用：

* **命令：** `fd -e c -x ls -l`
* **效果：** 找出所有 C 文件，并以长列表格式（显示权限、大小、时间）展示出来。

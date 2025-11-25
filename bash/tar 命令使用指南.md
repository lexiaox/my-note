

`tar` (Tape Archive) 是 Linux/Unix 系统中最常用的归档和压缩工具，用于将多个文件打包成一个文件，并支持多种压缩算法（如 gzip, bzip2）。

## 1. 基本语法

```bash
tar [选项] [压缩文件名] [源文件或目录]
```

## 2. 常用操作速查

### 打包与压缩 (Create)

* **打包并压缩为 .tar.gz (最常用)**
    * 命令：`tar -czvf archive.tar.gz /path/to/dir`
    * 说明：`-z` 代表使用 gzip 压缩，速度与压缩率平衡。

* **打包并压缩为 .tar.bz2 (压缩率更高)**
    * 命令：`tar -cjvf archive.tar.bz2 /path/to/dir`
    * 说明：`-j` 代表使用 bzip2 压缩，体积更小但稍慢。

* **仅打包 (不压缩)**
    * 命令：`tar -cvf archive.tar /path/to/dir`
    * 说明：仅归档，不压缩体积。

### 解压 (Extract)

* **解压 .tar.gz**
    * 命令：`tar -xzvf archive.tar.gz`

* **解压到指定目录**
    * 命令：`tar -xzvf archive.tar.gz -C /target/directory`
    * 注意：`-C` 参数后接目标路径。

* **智能解压 (推荐)**
    * 命令：`tar -xvf archive.tar.gz`
    * 说明：现代 `tar` 版本可以自动识别压缩格式，无需加 `-z` 或 `-j`。

### 查看内容 (List)

* **查看压缩包内的文件列表**
    * 命令：`tar -tvf archive.tar.gz`

## 3. 常用选项说明

| 选项   | 英文             | 含义                       |
| :--- | :------------- | :----------------------- |
| `-c` | **c**reate     | 创建新的归档文件 (打包)            |
| `-x` | e**x**tract    | 从归档文件中提取文件 (解压)          |
| `-t` | lis**t**       | 列出归档文件的内容                |
| `-v` | **v**erbose    | 显示详细处理过程                 |
| `-f` | **f**ile       | 指定归档文件名 (**必须作为最后一个参数**) |
| `-z` | g**z**ip       | 针对 .tar.gz               |
| `-j` | bzip2          | 针对 .tar.bz2              |
| `-C` | **C**hange dir | 切换到指定目录进行解压              |

## 4. 进阶用法 (排除文件)

如果想打包目录但排除某些文件（如日志）：

```bash
tar -czvf project.tar.gz src/ --exclude='*.log'
```
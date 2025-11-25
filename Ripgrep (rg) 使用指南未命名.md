
Ripgrep (rg) 是一个面向行的搜索工具，功能类似 `grep`，但速度更快，且默认尊重 `.gitignore` 规则。

## 基本用法

* **当前目录搜索**: `rg pattern`
* **指定路径搜索**: `rg pattern path/to/search`

## 常用选项

* **忽略大小写**: `rg -i pattern` (或 `--ignore-case`)
* **全词匹配**: `rg -w pattern` (或 `--word-regexp`)
* **显示上下文**:
    * `rg -C 3 pattern` (显示前后各 3 行)
    * `rg -A 3 pattern` (显示后 3 行)
    * `rg -B 3 pattern` (显示前 3 行)
* **只显示文件名**: `rg -l pattern` (或 `--files-with-matches`)
* **反向匹配** (显示不包含模式的行): `rg -v pattern` (或 `--invert-match`)
* **显示行号**: `rg -n pattern` (默认通常开启)
* **统计匹配数**: `rg -c pattern` (或 `--count`)

## 文件过滤与类型

* **指定文件类型**: `rg -tpy pattern` (只搜索 python 文件)
* **排除文件类型**: `rg -Tjs pattern` (不搜索 javascript 文件)
* **查看支持的类型**: `rg --type-list`
* **Glob 模式过滤**:
    * `rg -g '*.txt' pattern` (只搜索 txt 文件)
    * `rg -g '!*.log' pattern` (排除 log 文件)
* **搜索隐藏文件**: `rg --hidden pattern`
* **忽略 .gitignore**: `rg --no-ignore pattern` (搜索所有文件，包括被 git 忽略的)

## 其他

* **字面量搜索** (不使用正则): `rg -F pattern` (或 `--fixed-strings`)
* **正则搜索**: 默认支持正则，例如 `rg 'foo|bar'`
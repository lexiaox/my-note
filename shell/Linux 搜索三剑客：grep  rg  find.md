
# 🧩 1. 工具定位（一句话总结）

|工具|功能定位|优势|劣势|
|---|---|---|---|
|**grep**|在文本中找字符串|基础、兼容性高|慢、不能过滤文件类型|
|**ripgrep (rg)**|递归快速搜索文件内容|极快、默认递归、强大过滤|需要安装|
|**find**|查文件，而不是内容|规则灵活、强大|不查内容（需配合 grep）|

---

# 🧩 2. 用法对比（最常用版）

## 🔍 搜索目录下所有包含 "hello" 的行

### grep

```bash
grep -R "hello" .
```

### rg（最简单）

```bash
rg "hello"
```

### find（+grep）

```bash
find . -type f -exec grep -Hn "hello" {} +
```

---

# 🧩 3. 搜索文件内容（内容搜索）

## 🔥 最常用 rg 搜索

```bash
rg "keyword"
```

## grep（慢）

```bash
grep -R "keyword" .
```

## find + grep（只搜索特定文件）

```bash
find . -name "*.c" -exec grep -n "keyword" {} +
```

---

# 🧩 4. 搜索文件名（文件搜索）

## find（最强）

```bash
find . -name "*.log"
```

## rg（也可以搜索文件名）

```bash
rg -g "*.log" -l
```

## grep（不适合搜索文件名）

---

# 🧩 5. 文件类型过滤

## rg 最方便

```bash
rg "main" -g "*.c"
```

## find（也行，但麻烦）

```bash
find . -name "*.c" -exec grep "main" {} +
```

## grep

需要 -R 全递归，但不能过滤文件类型。

---

# 🧩 6. 速度对比（实际使用体验）

1. **rg > ag > grep -R**
    
2. rg 使用 Rust 写的，自动多线程扫描
    
3. grep 每次都按字节流扫描文件，遇到大项目会非常慢
    
4. find 不扫描内容，速度取决于文件系统
    

**结论：项目搜索选 rg，系统兼容选 grep，文件管理选 find**

---

# 🧩 7. 常用命令大合集

---

## 🔥 grep 速查表

|用途|命令|
|---|---|
|搜索字符串|`grep "text" file`|
|递归搜索|`grep -R "text" .`|
|忽略大小写|`grep -i "text"`|
|显示行号|`grep -n "text"`|
|完整单词匹配|`grep -w "word"`|
|只显示文件名|`grep -l "text"`|
|使用正则|`grep -E "a|

---

## 🔥 ripgrep (rg) 速查表

|用途|命令|
|---|---|
|搜索内容|`rg "text"`|
|忽略大小写|`rg -i "text"`|
|搜索文件类型|`rg "text" -g "*.c"`|
|排除文件夹|`rg "text" -g "!build"`|
|显示行号（默认开启）|`rg -n "text"`|
|显示上下文|`rg -C 3 "text"`|
|只显示文件名|`rg -l "text"`|
|正则|`rg "^main"`|
|显示列号|`rg --column "text"`|

---

## 🔥 find 速查表

|用途|命令|
|---|---|
|查找文件|`find . -name "*.log"`|
|查找目录|`find . -type d -name "src"`|
|查找最近 1 天修改的文件|`find . -mtime -1`|
|删除匹配的文件|`find . -name "*.tmp" -delete`|
|与 grep 联用|`find . -name "*.c" -exec grep -n "main" {} +`|

---

# 🧩 8. 实战对比示例

---

## 📌 示例 1：查找所有包含 “error” 的行

### 使用 grep

```bash
grep -R "error" .
```

### 使用 rg（推荐）

```bash
rg "error"
```

### 使用 find + grep

```bash
find . -type f -exec grep -Hn "error" {} +
```

---

## 📌 示例 2：在项目中找 main 函数

```bash
rg "int main"
```

or

```bash
grep -R "int main" .
```

---

## 📌 示例 3：只搜索 Python 文件

```bash
rg "import" -g "*.py"
```

or

```bash
find . -name "*.py" -exec grep -n "import" {} +
```

---

# 🧩 9. 什么时候用哪个？

|场景|最佳工具|
|---|---|
|搜文件内容（快）|**rg**|
|搜文件名 / 文件管理|**find**|
|几乎所有系统自带|**grep**|
|大型工程内容搜索|**rg**|
|精确过滤文件类型并搜索内容|**rg**|
|深度文件筛选后再搜索内容|**find + grep**|

---

# 🧩 10. 最终口诀（强烈推荐记住）

```
查内容 → rg
查文件 → find
兼容性 → grep
```

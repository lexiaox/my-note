非常好 👍  
这次我们做一份完整、系统、清晰的 **C语言文件输入输出笔记**，包含两大类文件：

> 🧾 文本文件（text file）  
> 💾 二进制文件（binary file）

这份内容适合你长期保存复习。

---

# 📘 C语言文件读写笔记（完整版）

---

## 一、文件操作的基本流程

C 语言所有文件操作都依赖 `<stdio.h>`  
基本步骤：

1. **定义文件指针**
    
    ```c
    FILE *fp;
    ```
    
2. **打开文件**
    
    ```c
    fp = fopen("文件名", "模式");
    ```
    
3. **读写文件**
    
    - 文本：`fprintf`, `fscanf`, `fgets`, `fputs`
        
    - 二进制：`fwrite`, `fread`
        
4. **关闭文件**
    
    ```c
    fclose(fp);
    ```
    

---

## 二、文件打开模式

|模式|说明|
|---|---|
|`"r"`|只读打开（文件必须存在）|
|`"w"`|写入（文件存在则清空，不存在则创建）|
|`"a"`|追加写入（写入到末尾）|
|`"r+"`|读写（文件必须存在）|
|`"w+"`|读写（创建新文件或清空旧文件）|
|`"a+"`|读写（文件存在则追加）|
|`"rb"`, `"wb"`, `"ab"`|同上，但用于二进制文件|

---

## 三、文本文件的读写

### 📖 写入文本文件

```c
#include <stdio.h>

int main() {
    FILE *fp = fopen("output.txt", "w");
    if (!fp) {
        printf("打开文件失败！\n");
        return 1;
    }

    fprintf(fp, "Hello, world!\n");
    fprintf(fp, "数字：%d\n", 123);
    fputs("这是另一行文字。\n", fp);

    fclose(fp);
    return 0;
}
```

📘 **说明**

- `fprintf()`：格式化写入（类似 `printf`）
    
- `fputs()`：直接写字符串
    

---

### 📥 读取文本文件

```c
#include <stdio.h>

int main() {
    FILE *fp = fopen("output.txt", "r");
    if (!fp) {
        printf("文件打开失败！\n");
        return 1;
    }

    char line[100];
    while (fgets(line, sizeof(line), fp)) { // 一次读一行
        printf("%s", line);
    }

    fclose(fp);
    return 0;
}
```

📘 **说明**

- `fscanf(fp, "%d", &x)`：读格式化数据
    
- `fgets(line, size, fp)`：读一整行字符串
    
- `feof(fp)`：可判断是否到文件结尾
    

---

## 四、二进制文件的读写

二进制文件保存的是**原始内存数据**，速度快，不可直接用文本编辑器查看。

---

### 💾 写入二进制文件（`fwrite`）

```c
#include <stdio.h>

int main() {
    FILE *fp = fopen("data.bin", "wb");  // 以二进制方式写入
    if (!fp) {
        printf("打开文件失败！\n");
        return 1;
    }

    int nums[] = {10, 20, 30, 40, 50};
    fwrite(nums, sizeof(int), 5, fp);  // 写入5个int

    fclose(fp);
    return 0;
}
```

---

### 💾 读取二进制文件（`fread`）

```c
#include <stdio.h>

int main() {
    FILE *fp = fopen("data.bin", "rb");  // 以二进制方式读取
    if (!fp) {
        printf("打开文件失败！\n");
        return 1;
    }

    int nums[5];
    fread(nums, sizeof(int), 5, fp);  // 从文件读取5个int

    for (int i = 0; i < 5; i++) {
        printf("nums[%d] = %d\n", i, nums[i]);
    }

    fclose(fp);
    return 0;
}
```

---

## 五、读写结构体的例子（重点）

```c
#include <stdio.h>

typedef struct {
    char name[20];
    int age;
    double score;
} Student;

int main() {
    Student stu1 = {"Alice", 20, 95.5};
    Student stu2;

    // 写入
    FILE *fp = fopen("student.bin", "wb");
    fwrite(&stu1, sizeof(Student), 1, fp);
    fclose(fp);

    // 读取
    fp = fopen("student.bin", "rb");
    fread(&stu2, sizeof(Student), 1, fp);
    fclose(fp);

    printf("姓名: %s\n年龄: %d\n分数: %.1f\n", stu2.name, stu2.age, stu2.score);
    return 0;
}
```

🧠 这种方法常用于保存游戏存档、数据库记录、配置文件等。

---

## 六、文本 vs 二进制 文件对比总结

|对比项|文本文件|二进制文件|
|---|---|---|
|读写函数|`fprintf`, `fscanf`, `fgets`, `fputs`|`fwrite`, `fread`|
|内容格式|可读的 ASCII 字符|原始字节数据|
|文件大小|通常较大（有换行和字符编码）|较小、紧凑|
|可直接查看|✅ 是|❌ 否|
|速度|较慢|较快|
|适合|配置、日志、报告|图片、音频、结构体数据|

---

## 七、补充：安全与检测

- 判断文件是否打开成功：
    
    ```c
    if (fp == NULL) { ... }
    ```
    
- 判断是否到达文件结尾：
    
    ```c
    while (!feof(fp)) { ... }
    ```
    
- 关闭文件（一定要）：
    
    ```c
    fclose(fp);
    ```
    

---

## 八、示意图 🧭

```
程序内存 ←→ 文件指针 ←→ 磁盘文件
      ↑
   fread / fwrite （二进制）
   fscanf / fprintf （文本）
```

---

## ✅ 总结口诀

> fopen 打开先，  
> fprintf/fscanf 写与读；  
> fwrite/fread 传二进，  
> fclose 结束莫忘记。

---

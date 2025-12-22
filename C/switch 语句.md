在C语言中，`case`语句是`switch`语句的核心组成部分，用于根据表达式的值执行对应的代码块。以下是详细用法和注意事项：

### **1. 基本结构**

```c
cswitch (表达式) {
    case 常量1:
        // 代码块1
        break;
    case 常量2:
        // 代码块2
        break;
    ...
    default:
        // 默认代码块
}
```

- **表达式**：必须是整型（`int`、`char`、`枚举类型`）或字符型，不能是浮点数。
- **case常量**：必须是整型或字符型的**常量表达式**（如`1`、`'A'`、`10+5`），不能是变量或浮点数。
- **default**：可选，当所有case不匹配时执行，可放在任意位置（通常放最后）。

### **2. 执行流程**

- 计算`switch`后的表达式值。
- 依次匹配`case`后的常量：
    - 若匹配成功，从该`case`开始执行，直到遇到`break`或`switch`结束。
    - 若未匹配任何`case`，执行`default`块（如果存在）。
- **关键点**：若缺少`break`，会发生“**case穿透**”（执行后续所有case的代码，直到遇到`break`或结束）。

### **3. 代码示例**

```c
c#include <stdio.h>
int main() {
    int num = 2;
    switch (num) {
        case 1:
            printf("One\n");
            break;
        case 2:
            printf("Two\n");  // 匹配成功，执行此块
            // 注意：此处若省略break，会继续执行case 3的代码！
        case 3:
            printf("Three\n");  // 若case 2无break，此处也会执行
            break;
        default:
            printf("Default\n");
    }
    return 0;
}
```

**输出**：

```
Two
Three
```


### **4. 与if-else的对比**

- **switch**：适合多分支固定值判断，代码更清晰（尤其是分支较多时）。
- **if-else**：适合范围判断或复杂条件（如`x > 5 && x < 10`）。

### **5. 常见错误**

- **忘记break**：导致意外穿透，逻辑错误。
- **case常量非法**：如使用变量、浮点数或重复值。
- **变量作用域问题**：在case中直接定义变量（需用`{}`包裹）。
- **忽略default**：可能导致未处理的情况被遗漏。

通过合理使用`switch`和`case`，可以编写出更清晰、高效的条件分支代码，但需特别注意`break`和常量规则，避免潜在错误。
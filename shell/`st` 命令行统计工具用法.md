
---



# 📊 st 命令行统计工具用法

**st** 是一个轻量、简洁的命令行工具，用于从标准输入（stdin）或文件中快速计算**描述性统计数据**。它被设计为 Unix 管道工具，非常高效。

## 1. 安装方法

由于 st 是用 Go 语言编写的，通常通过 go install 安装（假设您已安装 Go 环境）。

* **Linux/macOS (通过 Go 安装):**
    * go install github.com/nferraz/st@latest
* **Arch Linux (AUR):**
    * yay -S st-git 或其他 AUR 助手。

## 2. 基础用法

st 默认从标准输入读取一列数字（每行一个数字），通过管道 | 接收数据。

### 示例数据 (假设在文件 data.txt 中)

10
15
20
5
50

### 常用操作概览

| 操作名称 | 命令格式 | 示例结果 (基于 data.txt) | 描述 |
| :--- | :--- | :--- | :--- |
| **默认输出** | cat data.txt | st | 显示基础统计量（取决于版本默认值）。 |
| **计算总和** | cat data.txt | st --sum | 计算所有数值的总和。 |
| **计算平均值** | cat data.txt | st --mean | 计算算术平均值。 |
| **计算中位数** | cat data.txt | st --median | 计算中位数（50% 分位数）。 |

## 3. 核心参数 (统计量)

使用 -- 或 - 的参数来指定需要计算的统计量，可以组合使用。

| 长参数 | 短参数 | 统计量 | 描述 |
| :--- | :--- | :--- | :--- |
| --count | -n | N | 数据点的数量（计数）。 |
| --mean | -m | mean | 算术平均值。 |
| --stddev | -sd | stddev | 标准差。 |
| --sum | -s | sum | 总和。 |
| --min | | min | 最小值。 |
| --max | | max | 最大值。 |
| --median | | median | 中位数。 |
| --var | --variance | var | 方差。 |
| --q1 | | q1 | 第一四分位数 (25%)。 |
| --q3 | | q3 | 第三四分位数 (75%)。 |
| --stderr | | stderr | 标准误差。 |

## 4. 快捷参数和高级用法

| 参数 | 输出统计量 | 描述 |
| :--- | :--- | :--- |
| --complete | N min q1 median q3 max sum mean stddev stderr | 输出所有主要描述性统计量。 |
| --precision N | | 设置输出数字的精度（小数点后位数）。 |
| --transpose | | 交换行和列，使统计量名称在左侧，值在右侧。 |

### 示例：使用 --complete 获取全部数据

$ cat data.txt | st --complete
# 输出格式： N min q1 median q3 max sum mean stddev stderr


5 5 12.5 15 35 50 100 20 17.46424 7.81025


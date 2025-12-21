

对于语句：`Node *newNode = (Node *)malloc(sizeof(Node));`

| 组成部分            | 物理意义                     | 存储位置      |
| :-------------- | :----------------------- | :-------- |
| `Node *newNode` | **定义指针变量**：声明一个用于存放地址的容器 | 栈 (Stack) |
| `malloc(...)`   | **分配内存实体**：在运行时动态申请字节空间  | 堆 (Heap)  |
| `sizeof(Node)`  | **计算偏移量**：确定结构体成员总共占据的大小 | 编译器计算     |
| `(Node *)`      | **语义约束**：告诉编译器如何解释这块内存地址 | 语法层面      |

> [!CAUTION] 注意
> 在 Linux 环境下（如 Termux 或 Ubuntu），如果 `malloc` 失败会返回 `NULL`。在对 `newNode` 进行 `newNode->data` 操作前，务必检查 `if (newNode != NULL)`，否则会触发 **Segmentation Fault**。
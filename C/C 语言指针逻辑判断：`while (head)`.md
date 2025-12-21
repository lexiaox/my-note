

#### 1. 语法等价性
在处理链表时，以下两种写法在编译器看来是完全等价的：
- **标准版**：`while (head != NULL)`
- **简写版**：`while (head)`

#### 2. 运行机制
- **进入循环**：当 `head` 指向一个有效的 `Node` 结构体时（地址 > 0）。
- **退出循环**：当 `head` 到达链表尾部的 `next`（其值为 `NULL`，即 0）时。

#### 3. 常见应用场景（内存释放）
```c
// 安全释放链表的标准范式
while (head) {
    Node *temp = head;
    head = head->next; // 必须在 free 之前移动指针
    free(temp);
}
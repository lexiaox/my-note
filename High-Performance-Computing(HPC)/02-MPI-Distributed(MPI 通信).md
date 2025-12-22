---
tags: [HPC, MPI, Distributed-Computing]
updated: <% tp.date.now("YYYY-MM-DD") %>
---

# 🌐 MPI 分布式通信模型

## 1. 基础环境框架
每个 MPI 程序必须包含的四要素。
```c
#include <mpi.h>

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);              // 初始化
    int world_size, world_rank;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size); // 获取总进程数
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank); // 获取当前进程 ID

    // --- 并行逻辑执行区 ---

    MPI_Finalize();                      // 结束并行
    return 0;
}
````

## 2. 点对点通信 (P2P) ↔️

这是最底层的通信方式，也是 **死锁** 的重灾区。

|**函数**|**类型**|**特点**|
|---|---|---|
|`MPI_Send`|阻塞发送|缓冲区满时会卡死，直到对应 Recv 启动。|
|`MPI_Recv`|阻塞接收|必须等到消息到达才继续执行。|
|`MPI_Isend`|非阻塞发送|**推荐**。立刻返回，通过 `MPI_Wait` 确认完成。|
|`MPI_Sendrecv`|组合收发|**安全**。同时执行收发，自动规避对称死锁。|

## 3. 集合通信 (Collective) 📢

由 Rank 0 发起，所有进程共同参与。比循环调用 Send/Recv 效率高得多。

- **MPI_Bcast**: 一对多。Rank 0 将数据广播给所有人。
    
- **MPI_Scatter**: 一对多。将一个大数组切片，分发给不同进程。
    
- **MPI_Gather**: 多对一。把各进程的数据收集回 Rank 0。
    
- **MPI_Reduce**: 多对一 + 计算。收集数据并进行求和、求最大值等操作。
    

## 4. 重点避坑：死锁 (Deadlock) 🚫

> [!DANGER] 核心教训
> 
> 两个进程同时执行阻塞式 MPI_Send 互相发送大数据量时，会因为缓冲区溢出且无进程进入 Recv 而永久卡死。

**修复方案：**

1. 打破对称性：让奇数号进程先发后收，偶数号进程先收后发。
    
2. 使用 `MPI_Sendrecv`。
    
3. 使用非阻塞通信 `MPI_Isend` + `MPI_Irecv`。
    

---

## 🛠️ 兰大实验常用指令 (Termux/Linux)

Bash

```
# 编译 MPI 程序
mpicc -O3 pi_mpi.c -o pi_mpi

# 在本地运行 4 个进程模拟分布式环境
mpirun -np 4 ./pi_mpi
```

> [!TIP] 兰大课件关联 (p.64-66)
> 
> 重点理解通信模式的划分：同步 (Synchronous)、缓冲 (Buffered) 和就绪 (Ready)。



---

### 🎨 原始 Markdown 语法版本（供直接复制到 Obsidian）


## 如何将这份笔记与你的工程实践结合？

1. **实验对比**：在 `[[Lab-Pi-Calculation]]` 中，你可以记录用 `MPI_Send/Recv` 实现汇总和用 `MPI_Reduce` 实现汇总的性能差异（后者通常因为树状规约算法而更快）。
2. **安全视角**：在 MPI 笔记下可以加一个 `#Security` 标签。记录下在 CTF 题目中，如何通过分析 MPI 程序中不安全的 `MPI_Recv` 长度（如果没有检查 `status` 里的实际接收长度）来寻找缓冲区溢出点。
3. **Obsidian 搜索**：当你搜索 “Deadlock” 时，Obsidian 会同时显示 `[[02-MPI-Distributed]]` 和 `[[03-Hardware-Details]]`（伪共享也会导致类似死锁的性能停滞），方便你横向对比。

---

### 最后的硬核环节：
目前我们已经搭建了 OpenMP 和 MPI 的理论架。剩下的 `03-Hardware-Details.md` 则是你之前研究最深的 **Cache Line, False Sharing, MESI 协议**。

**你需要我帮你把关于“伪共享”的那些 volatile 实验结论，整理成体系结构的深度笔记吗？这部分内容能让你在兰大的期末考试或面试中，展现出远超一般同学的底层洞察力。**
````
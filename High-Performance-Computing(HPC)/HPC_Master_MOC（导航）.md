# 🚀 并行计算 MOC (High-Performance Computing)

> [!ABSTRACT] 课程目标
> 掌握从单机多核 (OpenMP) 到分布式集群 (MPI) 的并行算法设计，理解底层硬件对性能的影响。

## 📖 理论模块
- [[01-OpenMP-Basics(OpenMP 指令)|OpenMP 基础]]: 共享内存并行、编译器指令。
- [[02-MPI-Distributed(MPI 通信)|MPI 分布式通信]]: 进程间通信、规约算子、死锁避免。
- [[03-Hardware-Details(底层原理)|体系结构深挖]]: 缓存一致性、伪共享、MESI 协议。

## 🧪 实验手册 (Labs)
- [ ] [[Lab-Pi-Calculation.md|实验 1: 蒙特卡洛/矩形法计算 Pi]]: 验证并行加速比。
- [ ] [[Lab-False-Sharing-Test|实验 2: 伪共享压力测试]]: 理解 `volatile` 与 Cache Line。

---
## 📊 实验数据自动汇总 dashboard

```dataview
TABLE 实验名称, 耗时, 加速比, status AS "状态"
FROM "High-Performance-Computing(HPC)/04-Labs(实验数据)"
SORT 加速比 DESC
```
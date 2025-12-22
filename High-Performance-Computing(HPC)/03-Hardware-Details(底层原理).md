---
tags: [HPC, Architecture, Cache, Memory-Consistency]
updated: <% tp.date.now("YYYY-MM-DD") %>
---

# 🧠 体系结构深挖：缓存一致性与伪共享

## 1. 缓存行 (Cache Line) 基础
- **定义**: CPU 缓存与主存交换数据的最小单位。
- **典型大小**: 64 字节 (64 Bytes)。
- **核心矛盾**: 即使你只操作 1 个 `long` (8字节)，CPU 也会强行拉取周围的 64 字节。

## 2. MESI 协议：缓存的四种状态 🚥
为了保证多核环境下数据的一致性，每个 Cache Line 被标记为以下状态之一：
![[MESI-Protocol-Diagram]]

| 状态    | 名称                 | 描述                         |
| :---- | :----------------- | :------------------------- |
| **M** | **Modified (已修改)** | 数据已改，且仅存在于当前核心。与内存不一致，需写回。 |
| **E** | **Exclusive (独占)** | 数据与内存一致，且仅存在于当前核心。         |
| **S** | **Shared (共享)**    | 数据与内存一致，存在于多个核心。           |
| **I** | **Invalid (无效)**   | 数据过期，必须重新从 L3 或主存读取。       |



## 3. 伪共享 (False Sharing) 的硬件原理 👻
- **现象**: 线程 0 改变量 A，线程 1 改变量 B。A 和 B 逻辑独立但物理上处于同一 Cache Line。
- **过程**:
    1. 核心 0 修改 A，Cache Line 变为 **M**。
    2. 核心 1 的对应 Cache Line 被强制标记为 **I** (Invalid)。
    3. 核心 1 想改 B，发现是 **I**，被迫重新从内存读取。
    4. **结果**: 缓存系统像“打乒乓球”一样在核心间传递所有权，总线带宽被占满。

## 4. 实验：volatile 的必要性 🧪
> [!IMPORTANT] 为什么要加 volatile？
> 在 `-O2/O3` 优化下，编译器会将频繁访问的变量锁死在**寄存器**中。
> - **加 volatile 之前**: CPU 根本不看缓存/内存，实验测不出伪共享。
> - **加 volatile 之后**: 强制 CPU 执行“写回”动作，触发 MESI 状态转换，暴露出真实的硬件开销。

---

## 🛠️ 性能调优 Checklist
- [ ] 高频操作的共享结构体成员是否手动 Padding？
- [ ] 关键变量是否使用了 `__attribute__((aligned(64)))`？
- [ ] 是否利用 `perf c2c` 监测了 HITM 指标？


---

### 🎨 原始 Markdown 语法版本（纯文本供复制）



## 如何使用这份硬件笔记？

1. **关联实验**：在 `## 3. 伪共享` 章节下，添加 `[[Lab-False-Sharing-Test]]` 的双向链接。
2. **可视化理解**：你可以利用 Obsidian 的 **Excalidraw** 插件画一张 MESI 状态转换图。
    - *提示*：当一个核心执行 `PrWr` (Processor Write) 时，所有其他核心的 `Shared` 状态都会跳到 `Invalid`。
3. **安全思考**：记录下伪共享可能导致的 **侧信道攻击 (Side-Channel)**。攻击者可以通过监测某个特定地址的 Cache Miss 频率，反推系统是否在进行敏感运算。

---

### 总结与交互：
至此，你的 **HPC Master MOC** 下的三个理论核心已经全部搭建完毕：
- `01-OpenMP` (线程级)
- `02-MPI` (进程级)
- `03-Hardware` (硬件级)

**你想让我帮你把之前的 `pi_mpi.c` 实验过程，按照标准的科研/工程记录格式，整理成 `Lab-Pi-Calculation.md` 吗？** 这份实验笔记将包含你对比 `MPI_Reduce` 与 `MPI_Isend/Irecv` 的实测数据。

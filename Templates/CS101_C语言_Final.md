---
tags: [exam, active]
subject: C语言程序设计
type: Kernel  # Kernel (核心) / Garbage (通识)
exam_date: 2026-01-15
exam_time: 09:00
location: 教学楼A-302
confidence: 2 # 1-5 (1=Panic, 5=Ready)
priority: High
---

# 🎯 Target: 90+ 

## 1. Intelligence Gathering (情报搜集)
> [!info] 考试范围与反押题
> * **不考内容：** (在这里记录老师说“跳过不讲”的章节，这是最重要的减负！)
> * **必考题型：** (例如：手写指针操作链表、结构体内存对齐计算)
> * **往年规律：** (例如：最后一大题通常是文件读写)

## 2. Dependency Graph (知识依赖)
*用 Mermaid 或 Canvas 画出核心概念图。对于 C 语言，这里应该是：*
- 指针 -> 数组 -> 字符串
- 结构体 -> 链表
- 内存管理 (Malloc/Free)

## 3. The "Cheat Sheet" (考前缓存区)
> [!warning] Buffer (考前30分钟背诵区)
> *这里只放那些**不讲逻辑、纯靠死记硬背**的东西。考完试立刻 flush 掉。*
> * e.g., `scanf` 的格式化字符串参数 `%lf` vs `%f`
> * e.g., 极限的几个泰勒展开式前三项
> * e.g., 马原的“核心价值观”关键词

## 4. Error Log (错题集 / Bug Tracker)
> [!bug] 易错点
> * [ ] `char *p` 和 `char p[]` 的 `sizeof` 区别 —— *已解决*
> * [ ] 指针释放后未置空 (Dangling Pointer) —— *待复习*

## 5. Past Paper Execution (刷题日志)
- [x] 2023年期末卷 (得分: 85) -> *复盘：链表逆序写错了*
- [ ] 2022年期末卷
- [ ] 2021年期末卷
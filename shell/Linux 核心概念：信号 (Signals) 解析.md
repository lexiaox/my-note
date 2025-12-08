

## 1. 概念纠正
用户常误将 `SIGHUP` 拼写为 "SIGNUP"，将退出行为误解为 "SIGNOUT"。
* **Correct**: `SIGHUP` (Signal Hang Up)
* **Correct**: `SIGTERM` / `SIGINT` (用于退出的信号)

## 2. 常见信号详解表

| 信号名称        | 编号  | 全称        | 触发方式 (典型)         | 默认动作     | 备注                                  |
| :---------- | :-- | :-------- | :---------------- | :------- | :---------------------------------- |
| **SIGHUP**  | 1   | Hang Up   | 关闭终端窗口 / 断开 SSH   | 终止进程     | `nohup` 命令即用于忽略此信号。常用于通知服务**重载配置**。 |
| **SIGINT**  | 2   | Interrupt | 键盘按下 `Ctrl + C`   | 终止进程     | 程序可以捕获并处理（例如做清理工作）。                 |
| **SIGKILL** | 9   | Kill      | `kill -9 <PID>`   | **强制终止** | **不可捕获、不可忽略**。直接由内核清理内存。            |
| **SIGTERM** | 15  | Terminate | `kill <PID>` (默认) | 终止进程     | "礼貌"的终止请求，程序可以拒绝。                   |
| **SIGSTOP** | 19  | Stop      | 键盘按下 `Ctrl + Z`   | 暂停进程     | 进入 `T` (Stopped) 状态。                |

## 3. 信号与进程生命周期

信号是控制进程状态流转的主要手段：

1.  **Running (R)** $\xrightarrow{\text{SIGSTOP}}$ **Stopped (T)**
    * 进程被挂起，暂停执行。
2.  **Stopped (T)** $\xrightarrow{\text{SIGCONT}}$ **Running (R)**
    * 进程恢复执行（如 `bg` 或 `fg` 命令）。
3.  **Running (R)** $\xrightarrow{\text{SIGHUP/SIGKILL}}$ **Terminated/Zombie (Z)**
    * 进程生命结束。如果父进程未回收，则变成僵尸进程。

## 4. 开发者视角 (C语言)
在 C 语言中，使用 `<signal.h>` 库处理信号：
* **注册处理**：`signal(SIGINT, handler_function);`
* **发送信号**：`kill(pid, sig);` (系统调用)

> **注意**：编写 Daemon (守护进程) 时，标准做法之一就是 Fork 两次并调用 `setsid()`，脱离终端控制，从而天然避免 `SIGHUP` 的影响。
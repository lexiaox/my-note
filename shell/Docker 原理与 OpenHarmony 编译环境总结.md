

## 1. 核心概念：容器 vs 虚拟机
| 特性 | 虚拟机 (VM) | 容器 (Docker) |
| :--- | :--- | :--- |
| **隔离级别** | 硬件级虚拟化 (Hypervisor) | 操作系统级虚拟化 (Kernel) |
| **内核** | 拥有独立的 Guest Kernel | 共享宿主机 (Host) Kernel |
| **启动速度** | 分钟级 | 秒级 |
| **本质** | 完整操作系统 | 带有Namespace隔离的**进程** |

## 2. 关键技术 (Linux Kernel)
1.  **Namespaces (隔离)**:
    * `PID`: 进程编号隔离。
    * `NET`: 网络栈隔离。
    * `MNT`: 文件系统挂载点隔离。
2.  **Cgroups (限制)**: 限制 CPU、RAM 使用量，防止编译任务卡死宿主机。
3.  **UnionFS (存储)**: 镜像分层存储，Copy-on-Write (写时复制) 机制。

## 3. OpenHarmony 场景实战
**场景**: 使用 Docker 作为纯净的编译环境 (Build Environment)，而非运行 OS。

### 常用命令

# 1. 挂载源码并进入交互式终端
   
-   -v $(pwd):/src : 将当前宿主机源码目录挂载到容器 /src
-  --rm : 退出后立即删除容器实例（不留垃圾）
- docker run -it --rm -v $(pwd):/src -w /src [image_name] /bin/bash

# 2. 后台查看与进入
- docker ps                   # 查看运行中容器
- docker exec -it [id] bash   # 进入已有容器
- docker system prune         # 清理未使用的资源
## 3. 启动环境（最常用）

```Bash
# -v: 将物理机的代码目录映射到容器内（实现：代码在本地写，编译在容器跑）
# -w: 指定工作目录
# --rm: 容器退出后自动删除（保持系统洁净，因为数据都在挂载卷里）
docker run -it --rm \
  -v $(pwd):/home/openharmony \
  -w /home/openharmony \
  swr.cn-south-1.myhuaweicloud.com/openharmony-docker/docker_oh_standard:3.2 \
  /bin/bash
```
## 4. 调试与理解

- **在容器内**: 输入 `ps -ef`，你往往只能看到极少的进程（因为 PID Namespace）。
    
- **在宿主机**: 输入 `ps -ef | grep [容器内进程名]`，你是能看到该进程的真实 PID 的。
    
	- **结论**: Docker 里的 OpenHarmony 编译任务，本质上就是宿主机上的一个普通计算任务，只是被“关”起来了。
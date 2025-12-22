
**日期**: 2025-12-13
**标签**: #Network #Security #Concept #Nginx #Clash

## 1. 定义
代理服务器（Proxy Server）是一种充当客户端和目标服务器之间中介的服务器系统。它拦截请求并代表用户或服务器进行转发。

## 2. 核心分类

### A. 正向代理 (Forward Proxy)
> **"Client 的代理人"**
- **工作视角**: 位于客户端和互联网之间。
- **典型软件**: Clash, Shadowsocks, Squid (客户端模式)。
- **主要功能**:
    - **访问控制**: 突破防火墙 (GFW) 或公司内网限制。
    - **匿名性**: 隐藏 Client IP。
    - **缓存**: 加速资源访问。
- **CTF 场景**: 攻击者使用代理链 (Proxy Chains) 隐藏自身来源。

### B. 反向代理 (Reverse Proxy)
> **"Server 的看门人"**
- **工作视角**: 位于互联网和内部服务器集群之间。
- **典型软件**: Nginx, HAProxy, Traefik, Cloudflare。
- **主要功能**:
    - **负载均衡 (Load Balancing)**: 将流量分发到后端 (Backend) 集群。
    - **安全 (Security)**: 隐藏后端真实 IP，部署 WAF (Web Application Firewall)。
    - **SSL Termination**: 集中管理 HTTPS 加密解密。
- **CTF 场景**: 渗透测试时，你攻击的目标通常是反向代理，需要尝试绕过它找到真实后端 (Real IP)。

## 3. 常见误区：Proxy vs VPN
| 特性 | Proxy | VPN (Virtual Private Network) |
| :--- | :--- | :--- |
| **层级** | 通常工作在应用层 (HTTP/SOCKS) | 工作在网络层 (IP) 或数据链路层 |
| **范围** | 通常只代理特定的软件 (浏览器) | 代理整个系统的流量 |
| **加密** | 不一定加密 (如 HTTP 代理) | 通常建立全局加密隧道 |
| **现代演变** | 现代工具 (如 Clash TUN 模式) 通过虚拟网卡实现了类似 VPN 的全局代理效果。 | |

## 4. 故障案例分析 (Fake IP)
- **现象**: `ping` 返回 `198.18.x.x`。
- **原因**: 代理软件 (Clash) 开启 Fake-IP 模式，劫持 DNS 解析以防止 DNS 污染并加速连接。
- **副作用**: 在需要三层网络认证（如校园网 Captive Portal）的环境下，会导致认证页面无法加载，因为物理链路尚未连通。
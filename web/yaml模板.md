---
创建时间: 2025-12-23 22:22
tags:
  - web
status: 📝 编写中
---

proxies:
  - name: "Vultr-SG-REALITY"
    type: vless
    server: xxx.xxx.xxx.xxx      # 【填空 1】：填入你服务器的公网 IP。
    port: xxx                   # 【填空 2】：填入你 Xray 监听的端口，REALITY 协议推荐用 443。
    uuid: 83418d10-xxxx...      # 【填空 3】：填入你的 UUID（用户唯一 ID），必须与服务端匹配。
    network: tcp                # 【默认】：REALITY 配合 Vision 流控时，传输协议必须是 tcp。
    udp: true                   # 【默认】：必须为 true，否则 Dota 2 无法对战。
    tls: true                   # 【默认】：REALITY 是基于 TLS 的。
    flow: xtls-rprx-vision      # 【默认】：目前最强的防封指纹流控。
    servername: www.nus.edu.sg  # 【填空 4】：填入你的伪装域名（SNI），要与服务端 dest 里的域名一致。
    reality-opts:
      public-key: YYj5ZgfR...   # 【填空 5】：填入你服务器生成的 REALITY PublicKey（公钥）。
      short-id: 12345678...     # 【填空 6】：填入你服务器生成的 Short ID。
    client-fingerprint: chrome  # 【默认】：模拟 Chrome 浏览器的 TLS 指纹。

  

proxy-groups:

- name: 🚀 节点选择

type: select

proxies:

- " Vultr-SG-REALITY"

- DIRECT

  

rules:

- GEOIP,CN,DIRECT

- MATCH,🚀 节点选择
  
  
  
  这份模板是基于 **Mihomo (Meta) 内核** 的标准 YAML 配置，专门用于实现 **VLESS + REALITY + Vision** 方案。对于 IT 专业人士来说，理解每一行参数对应的网络协议细节，有助于你在兰大校园网环境下进行深度调优。

以下是各个字段的详细逻辑解释：

### 1. 代理节点配置 (`proxies`)

这一部分定义了客户端如何与你的 Vultr 新加坡服务器建立加密隧道。

- **`type: vless`**:
    
    - **解释**：无状态代理协议，它是目前最轻量且扩展性最强的协议之一，不包含加密逻辑（加密由底层的 TLS/REALITY 完成）。
        
- **`uuid`**:
    
    - **解释**：用户的唯一标识符（相当于密码）。只有客户端和服务端一致时，服务器才会处理你的请求。
        
- **`flow: xtls-rprx-vision`**:
    
    - **核心逻辑**：这是该协议的“灵魂”。它通过消除 TLS 流量的特征（指纹），让代理流量看起来更像普通的网页浏览。
        
    - **IT 价值**：在校园网等有深度包检测（DPI）的环境下，它能有效防止流量被识别为翻墙工具。
        
- **`udp: true`**:
    
    - **核心逻辑**：允许转发 UDP 数据包。
        
    - **游戏价值**：**Dota 2 等对战游戏必须开启此项**，否则你只能打开 Steam 商店，但无法连接至对战服务器。
        
- **`reality-opts`**:
    
    - **`public-key`**: 服务端生成的公钥，用于 REALITY 握手。
        
    - **`short-id`**: 握手时的简短身份验证标识。
        
    - **`servername` (SNI)**: 伪装域名（如 `www.nus.edu.sg`）。
        
    - **安全逻辑**：REALITY 协议会消除 TLS 握手的特征，使你的连接在 DPI 看来，就是在访问一个真实的新加坡高校官网。
        

---

### 2. 策略组配置 (`proxy-groups`)

这一部分决定了流量的“出口选择开关”。

- **`type: select`**:
    
    - **解释**：手动选择模式。在 Clash 界面上，你可以手动切换是走服务器（`Vultr-SG-REALITY`）还是走直连（`DIRECT`）。
        
- **`proxies` 列表**:
    
    - **逻辑**：将你的服务器节点和 `DIRECT`（本地网络直连）打包在一起供你选择。
        

---

### 3. 分流规则 (`rules`)

这是最体现“IT 效率”的部分，决定了哪些流量需要翻墙，哪些不需要。

- **`- GEOIP,CN,DIRECT`**:
    
    - **逻辑**：**地理位置分流**。Clash 会查询目标 IP 的归属地，如果是中国（CN），则直接走本地校园网（DIRECT）。
        
    - **价值**：确保你访问百度、淘宝、兰大官网时不经过新加坡绕路，速度最快且省流量。
        
- **`- MATCH,🚀 节点选择`**:
    
    - **逻辑**：**兜底规则**（Final Rule）。所有不属于中国 IP 的流量（比如 Google, Steam, YouTube），全部交给上面定义的“节点选择”策略组去处理。
        

---


a# 基础端口配置
port: 7890
socks-port: 7891
mixed-port: 7890
allow-lan: true
mode: rule
log-level: info
external-controller: 127.0.0.1:9090

# 1. 代理节点列表
proxies:
  # 方案 A + C: REALITY 协议 Vultr 节点 (实测为美国)
  - name: "🇺🇸 Vultr-USA-REALITY" 
    type: vless
    server: 104.207.152.107
    port: 443
    uuid: 93ffbb04-b082-49ae-a2a7-729c3ed7ce2c
    network: tcp
    udp: true
    tls: true
    flow: xtls-rprx-vision
    servername: www.tesla.com
    reality-opts:
      public-key: vfdtWv1vlnzjxRNGyygaIau6h1fJ14FT4idvVE3ToE0
      short-id: 12345678 
    client-fingerprint: chrome

# 2. 策略组
proxy-groups:
  - name: "ss"
    type: select
    proxies:
      - "🇺🇸 Vultr-USA-REALITY"
      - DIRECT

# 3. 规则
rules:
  - MATCH,ss
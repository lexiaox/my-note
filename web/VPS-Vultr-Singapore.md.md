# 🚀 Vultr 新加坡节点配置备份 (2025-12-21)

## 1. 基础连接信息
- **IP 地址**: `45.76.186.115`
- **SSH 端口**: `22222`
- **登录账号**: `root`
- **系统**: Ubuntu 22.04 LTS

## 2. REALITY 核心参数 (密钥)
> [!WARNING]
> 这里的 PrivateKey 绝对不能泄露，它是你服务器身份的唯一证明。

- **UUID**: `83418d10-12b4-45f3-bfc6-a0cdfe9d20b5`
- **PublicKey**: `YYj5ZgfRgFFg_LRw0OPuv79oxpIvLcqiuvBcCF1GNSg`
- **PrivateKey**: `6Mq4KsPwgFFWKTzzjX9p4H-AtXCvYSksqmW7qk1ACUU`
- **Short ID**: `12345678abcdef`
- **SNI (伪装域名)**: `www.nus.edu.sg`

## 3. 服务端配置文件 (config.json)
路径: `/usr/local/etc/xray/config.json`

```json
{
    "log": { "loglevel": "info" },
    "inbounds": [
        {
            "port": 443,
            "protocol": "vless",
            "settings": {
                "clients": [{ "id": "83418d10-12b4-45f3-bfc6-a0cdfe9d20b5", "flow": "xtls-rprx-vision" }],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "reality",
                "realitySettings": {
                    "show": false,
                    "dest": "www.nus.edu.sg:443",
                    "xver": 0,
                    "serverNames": ["www.nus.edu.sg"],
                    "privateKey": "6Mq4KsPwgFFWKTzzjX9p4H-AtXCvYSksqmW7qk1ACUU",
                    "shortIds": ["12345678abcdef"]
                }
            }
        }
    ],
    "outbounds": [{ "protocol": "freedom", "tag": "direct" }]
}
```

## 4. 常用运维指令
- **查看日志**: `journalctl -u xray -f`
- **重启服务**: `systemctl restart xray`
- **检查端口**: `ss -tulpn | grep 443`
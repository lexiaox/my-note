完美 ✅  
你安装的是 **命令行版 OneDrive**（`onedrive v2.5.9-1+np1+1.1`），  
这是 Linux 上最常用的官方同步客户端。下面我一步步教你**上传文件**。

---

## 🧭 一、首次授权（如果还没登录）

执行：

```bash
onedrive
```

它会提示一个网址（形如 `https://login.microsoftonline.com/...`），  
用浏览器打开 → 登录你的 Microsoft 账号 → 复制授权码 → 粘贴回终端。  
成功后，它会在：

```
~/.config/onedrive/
```

生成配置文件。

---

## 📂 二、默认同步文件夹

默认目录是：

```
~/OneDrive
```

也就是你家目录下的一个文件夹。  
（如果不存在，它会自动创建）

---

## 🚀 三、上传文件方法

### ✅ 方法1：直接复制 + 同步

1. 把要上传的文件复制进去：
    
    ```bash
    cp ~/Downloads/test.txt ~/OneDrive/
    ```
    
2. 然后运行：

```
    onedrive --synchronize
    
```
 
  它会扫描本地 OneDrive 文件夹并上传所有变化。


---

### ✅ 方法2：只上传，不下载（推荐）

如果你只想上传、不想下载远端的文件：

```bash
onedrive --synchronize --upload-only
```

这样只会往云端传，不会拉回云端内容。

---

### ✅ 方法3：上传某个特定子目录

假如你在 `~/OneDrive/docs/` 放了文档：

```bash
onedrive --synchronize --upload-only --single-directory "docs"
```

---

## 📡 四、后台自动上传（可选）

你可以让 OneDrive 实时同步：

```bash
onedrive --monitor
```

保持运行时，它会自动检测变化并上传。  
要开机自启：

```bash
systemctl --user enable onedrive
systemctl --user start onedrive
```

---

## 🔍 五、查看同步状态

```bash
onedrive --display-config
onedrive --display-sync-status
```

---

要不要我帮你写一个简易脚本，比如输入 `upload filename` 就自动帮你复制并上传到 OneDrive？  
（适合日常快速上传）
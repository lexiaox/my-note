# Termux 提示符下执行
proot-distro login debian --user tom

# 进入 Code Server 目录
cd ~/code-server

# 启动 Code Server (保持此窗口打开)
./code-server-4.105.1-linux-arm64/bin/code-server --bind-addr 127.0.0.1:8888
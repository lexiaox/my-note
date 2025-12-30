### 1. 核心配置
- **模式**: RSYNC
- **存储路径**: `/data/timeshift`
- **排除项**: `/home/ldy` (文档由 OneDrive 负责，Timeshift 仅负责系统环境)

### 2. 存档命令 (CLI 版)
如果你不想开 GUI，可以直接用命令：
```bash
# 创建快照并添加描述
sudo timeshift --create --comments "稳定版存档_20251217"

# 查看所有快照
sudo timeshift --list

# 恢复指定快照 (交互式)
sudo timeshift --restore
```

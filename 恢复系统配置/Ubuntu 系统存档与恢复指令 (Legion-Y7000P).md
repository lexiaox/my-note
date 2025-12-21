### 1. 硬件环境记录
- **系统分区 (`/`)**: `nvme0n1p5` (101.1G)
- **存档分区 (`/data`)**: `nvme0n1p8` (500.6G)
- **引导分区 (`/boot/efi`)**: `nvme0n1p1`

### 2. Timeshift 维护指令
```bash
# 指定存档位置
sudo timeshift --snapshot-device /dev/nvme0n1p8

# 创建快照 (建议在重大实验前执行)
sudo timeshift --create --comments "实验前备份"

# 查看所有快照
sudo timeshift --list

# 恢复系统 (会引导你选择快照并确认磁盘映射)
sudo timeshift --restore
```

### 3. 恢复注意事项

- **数据安全**: Timeshift 默认不备份 `/home/ldy` 下的文件，因此恢复系统不会导致你的 OneDrive 笔记回滚。
    
- **挂载点**: 恢复时请确保目标分区依然映射到 `nvme0n1p5`。


Tmux 命令极其依赖 `-t` 参数来指定目标，直接跟数字通常会报错。

### 常用删除命令
| 操作对象 | 命令格式 | 示例 |
| :--- | :--- | :--- |
| **杀掉会话 (Session)** | `tmux kill-session -t <会话名/编号>` | `tmux kill-session -t 0` <br> `tmux kill-session -t myproject` |
| **杀掉窗口 (Window)** | `tmux kill-window -t <窗口编号>` | `tmux kill-window -t 1` |
| **杀掉窗格 (Pane)** | `tmux kill-pane -t <窗格编号>` | `tmux kill-pane -t 0` <br> `tmux kill-pane -t %1` |
| **杀掉所有服务** | `tmux kill-server` | `tmux kill-server` (慎用，关闭所有 tmux) |

### 常见报错解释
- **`ambiguous command: kill`**:
  - 原因：tmux 无法确定你要 kill 哪种对象（session/window/pane）。
  - 解决：使用完整的命令，如 `kill-session`。
- **`command ... too many arguments`**:
  - 原因：你可能直接写了数字（如 `kill-pane 0`）。
  - 解决：在数字前加上 `-t`（如 `kill-pane -t 0`）。
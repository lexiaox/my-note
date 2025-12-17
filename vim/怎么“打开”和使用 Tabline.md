

 **Tabline :

- 左上角的 `[No Name]` 表示你当前只打开了一个未命名的缓冲区。
    
- 右上角的 `buffers` 表示当前显示模式是 Buffer 列表。
    

之所以看起来空荡荡的，是因为你**只打开了一个文件**。

#### 如何让 Tabline 动起来？

试着输入以下命令打开几个新文件（模拟场景）：



``` Vim Script
:e test1.c
:e test2.h
:e Makefile
```

你会发现顶部的 Tabline 变成了类似这样的样子： `test1.c > test2.h > Makefile`

#### 如何在 Tabline (Buffer) 之间切换？

有了多个文件后，你需要命令来切换：

- **下一个文件**：`:bnext` (简写 `:bn`)
    
- **上一个文件**：`:bprev` (简写 `:bp`)
    
- **直接跳到第 N 个**：`:b1`, `:b2` 等。
    
- **关闭当前文件**：`:bd` (Buffer Delete)，这会把当前文件从 Tabline 移除。

## 1. memset：按字节填充内存

	头文件: <string.h>
	功能: 将内存块的前 n 个字节设置为指定值。
	原型: void *memset(void *s, int c, size_t n);

	参数:
```
	s: 目标地址
	c: 填充值 (按字节)
	n: 填充的字节数
```


	示例:
```C
	int array[50];
	memset(array, 0, sizeof(array));
```

	注意：只有设置 c=0 时才能可靠清零。设置其他值会导致非零整数值。

---

## 2. memcpy：按字节复制内存

```
	头文件: <string.h>
	功能: 从源地址 src 复制 n 个字节到目标地址 dest。
	原型: void *memcpy(void *dest, const void *src, size_t n);
```

```
	参数:
	dest: 目标地址
	src: 源地址
	n: 要复制的字节数
```


```C示例:
	int source_board[10][10];
	int target_board[10][10];
	memcpy(target_board, source_board, sizeof(int) * 10 * 10);
```

	注意：memcpy 不处理内存重叠。如果内存重叠，请使用 memmove。



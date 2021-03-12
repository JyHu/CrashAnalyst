# 整数溢出

[Integer Overflow](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/integer_overflow)

检测算术溢出。

---

## 总览

此检查检测到具有未定义行为的加，减，乘和除溢出。

### C中的签名加法溢出

在以下代码中，`x`变量在加法之前具有最大值，并且加法结果溢出，优化器可能无法以可预测的方式处理该变量。`int32_t``x`

```
int32_t x = (1U << 31) - 1;
x += 1; // Error: the add result can't fit in x
```

> **注意**
> `-fwrapv `启用编译器标志后，除签名的除法检查外，UBSan溢出检查将被禁用。

#### 解

解决带符号溢出的一种方法是使用更大的类型。

如果不需要表示负数，则另一种选择是使用无符号类型，这些类型定义为在算术溢出时自动换行。或者，将`-fwrapv`标志传递给编译器以在溢出时启用带符号的环绕。但是，这可能会对性能产生不利影响。
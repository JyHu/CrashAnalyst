# 无效班次

[Invalid Shift](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/invalid_shift)

检测无效和溢出的班次。

---

## 总览

此检查将检测到具有无效移位量的按位移位，以及可能溢出的移位。这些移位具有不确定的行为，并且可能会被优化程序消除。

### C中无效的班次金额

以下代码显示了移位量无效的移位，因为其结果无法用目标类型表示。

```
int32_t x = 1;
x <<= 32; // Error: (1 << 32) can't be represented in an int32_t
```

如果优化器可以证明移位量可能无效，则可以用任意值替换移位结果。

#### 解

使用较大的目标类型，例如。`int64_t`

### C中的移位溢出

在以下代码中，第二个移位溢出x，因为`((1U << 31) - 1) << 2`不能用表示。`int32_t`

```
int32_t x = (1U << 31) - 1;
x <<= 2; // Error: the shift result can't fit in x
```



#### 解

使用较大的目标类型，例如。`int64_t`
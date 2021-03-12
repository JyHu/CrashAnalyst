# 无效的浮动演员表

[Invalid Float Cast](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/invalid_float_cast)

检测到浮点类型，从浮点类型或在浮点类型之间的超出范围的强制转换。

---

## 总览

此检查检测到浮点类型，浮点类型或浮点类型之间的超出范围的强制转换。无效的转换具有未定义的行为，通常会产生任意值。这些任意值可能因平台而异。

### C中的浮点数双精度无效分配

从`n`到类型的转换`m`具有未定义的行为，因为其值不能由目标类型表示。

```
double n = 10e50;
float m = (float)n; // Error: 10e50 can't be represented as a float.
```



#### 解

使用其他目标类型或完全避免进行强制转换。
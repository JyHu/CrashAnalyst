# 无效的布尔值

[Invalid Boolean](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/invalid_boolean)

检测程序何时访问布尔变量，并且其值不是true或false。

---

## 总览

该检查检测到布尔值不为true或false时访问布尔变量。当使用整数或指针而没有适当的强制转换时，可能会出现此问题。超出范围的布尔值的使用具有未定义的行为，这可能很难调试。

### C中无效的布尔变量访问

以下代码的目的是在非零`success`时调用该函数`result`。但是，因为使用了布尔检查，作为优化，编译器可能仅发出检查的最低有效位（`predicate`即）的指令`0`，从而导致逻辑错误。

```
int result = 2;
bool *predicate = (bool *)&result;
if (*predicate) { // Error: variable is not a valid Boolean
    success();
}
```



#### 解

使用整数比较而不是布尔检查。

```
int result = 2;
if (result != 0) { // Correct
  success();
}
```






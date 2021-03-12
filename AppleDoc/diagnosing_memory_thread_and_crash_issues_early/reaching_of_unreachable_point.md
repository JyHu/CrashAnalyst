# 到达不可达点

[Reaching of Unreachable Point](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/reaching_of_unreachable_point)

检测程序何时到达不可达点。

---

## 总览

此检查将检测到使用创建的程序中无法到达控制点的控制流 。到达不可达的程序点可能会导致程序突然终止。`__builtin_unreachable`

### 在C中执行无法访问的代码

如果该`switch`语句无法处理函数返回的值， 则到达。`__builtin_unreachable()`

```
switch (value_returning_function()) {
case ...:                  // Warning: if the cases are not exhaustive
default:                   // __builtin_unreachable may be reached
    __builtin_unreachable();
}
```



#### 解

确保`switch`语句和其他控制流语句是详尽无遗的。
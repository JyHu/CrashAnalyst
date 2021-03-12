# 被零除

[Division by Zero](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/division_by_zero)

检测除数为零的除法。

---

## 总览

此检查检测除数为零的整数和浮点除法。被零除具有不确定的行为，并且可能导致崩溃或错误的程序输出。

### C中的零除整数

在以下代码中，`for`循环在其第一次迭代中执行零除。

```
int sum = 10;
for (int i = 0; i < 64; ++i) {
    sum /= i; // Error: division by zero on the first iteration
}
```

> **注意**
> 如果优化器确定在其任何迭代中都会触发未定义的行为，则可以删除循环的某些部分。

#### 解

修改逻辑，以在除数等于零时检查并避免除法。


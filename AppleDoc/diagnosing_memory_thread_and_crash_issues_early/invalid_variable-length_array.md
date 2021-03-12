# 无效的可变长度数组

[Invalid Variable-Length Array](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/invalid_variable-length_array)

检测不是正数的数组边界。

---

## 总览

此检查检测到的数组边界不是正数。具有非正长度的可变长度数组具有未定义的行为，并可能导致堆栈损坏。

### C中的负可变长度数组边界

在以下代码中，对函数的调用返回负数，从而导致数组无效。`invalid_index_returning_function`

```
int invalid_index_returning_function() {
    return -1;
}
int idx = invalid_index_returning_function();
int array[idx]; // Error: invalid array length
```



#### 解

解决此问题的一种方法是在构造数组之前检查数组边界。
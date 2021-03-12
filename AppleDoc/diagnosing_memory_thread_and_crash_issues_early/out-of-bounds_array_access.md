# 越界数组访问

[Out-of-Bounds Array Access](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/out-of-bounds_array_access)

检测数组的越界访问。

---

## 总览

此检查检测具有固定长度或可变长度大小的数组的越界访问。越界数组访问具有未定义的行为，并且可能导致崩溃或错误的程序输出。

注意

此检查不会检测到对堆分配的数组的越界访问。

### C语言中的越界数组访问

在以下示例中，对的越界访问`array`发生在循环的最后一次迭代中。

```
int array[5];
for (int i = 0; i <= 5; ++i) {
    array[i] += 1; // Error: out-of-bounds access on the last iteration
}
```



#### 解

确保访问的索引不超出数组范围。
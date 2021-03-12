# 未分配内存的重新分配

[Deallocation of Nonallocated Memory](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/deallocation_of_nonallocated_memory)

检测何时释放未分配的内存。

---

## 总览

此检查可以检测`free`未分配的内存中何时调用了`malloc`。尝试取消分配未分配的内存可能导致崩溃。

### C中堆栈变量的解除分配

在下面的示例中，该`value`变量在函数退出时分配在堆栈上并释放，因此对其进行调用`free`是不正确的。

```
int value = 42;
free(&value); // Error: free called on stack allocated variable
```

#### 解

确保`free`未在堆栈上分配的变量上调用该函数。
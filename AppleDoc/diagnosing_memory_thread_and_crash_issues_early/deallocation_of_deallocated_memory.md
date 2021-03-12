# 释放内存的释放

[Deallocation of Deallocated Memory](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/deallocation_of_deallocated_memory)

检测释放内存后何时释放内存。

---

## 总览

此检查检测何时`free`在已被释放的内存上调用何时（通常称为“双重释放”错误）。尝试多次重新分配内存可能导致崩溃或其他不可预测的行为。

### C中释放内存的重新分配

在以下示例中，在释放变量的内存后将其释放。`p_int`

```
int *pointer = malloc(sizeof(int));
free(pointer);
free(pointer); // Error: free called twice with the same memory address 
```

#### 解

确保`free`为分配的内存地址仅调用一次该函数。
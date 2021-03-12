# 缓冲区的上溢和下溢

[Overflow and Underflow of Buffers](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/overflow_and_underflow_of_buffers)

检测何时在缓冲区边界之外访问内存。

---

## 总览

此检查检测到何时在缓冲区边界之外访问内存。访问缓冲区末尾后的内存时报告溢出。当访问缓冲区开始之前的内存时，报告下溢。在堆和堆栈缓冲区以及全局变量上执行清理。缓冲区上溢和下溢会导致崩溃或其他不可预测的行为。

### C中的全局，堆和堆栈溢出

在下面的例子中，，，和变量各自具有范围有效的索引，但在索引进行访问，从而引起溢出。`global_array``heap_buffer``stack_buffer``[0, 9]``10`

```
int global_array[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
void foo() {
    int idx = 10;
    global_array[idx] = 42; // Error: out of bounds access of global variable
    char *heap_buffer = malloc(10);
    heap_buffer[idx] = 'x'; // Error: out of bounds access of heap allocated variable
    char stack_buffer[10];
    stack_buffer[idx] = 'x'; // Error: out of bounds access of stack allocated variable
}
```

#### 解

在尝试访问索引处的缓冲区之前，请添加边界检查。
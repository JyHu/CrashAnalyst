# 函数返回后堆栈存储器的使用

[Use of Stack Memory After Function Return](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/use_of_stack_memory_after_function_return)

在其声明函数返回后检测何时访问堆栈变量内存。

---

## 总览

在该函数返回后，该检查将检测在访问该函数中声明的堆栈变量的内存的任何时间。函数返回后尝试访问堆栈内存可能会导致崩溃或其他不可预测的行为。

> **注意**
> 默认情况下，此检查处于禁用状态。您可以在“编辑方案”对话框中的“地址清理器”选项下启用它。

### 在C中返回后使用堆栈存储器

在下面的示例中，该函数返回一个指向堆栈变量的指针，并尝试访问返回的指针的内存。`integer_pointer_returning_function`

```
int *integer_pointer_returning_function() {
    int value = 42;
    return &value;
}
int *integer_pointer = integer_returning_function();
*integer_pointer = 43; // Error: invalid access of returned stack memory

```

#### 解

使用指针参数允许函数通过引用返回值。
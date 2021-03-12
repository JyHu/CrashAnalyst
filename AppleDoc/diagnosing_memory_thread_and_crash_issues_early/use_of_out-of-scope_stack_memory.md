# 使用范围外堆栈存储器

[Use of Out-of-Scope Stack Memory](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/use_of_out-of-scope_stack_memory)

检测何时在变量声明的范围之外访问变量。

---

## 总览

此检查检测何时在声明变量的范围之外访问变量。尝试访问范围外的内存可能导致无法预测的行为。

### 在C中使用范围外堆栈存储器

在下面的示例中，`pointer`有条件地为变量分配了指向函数返回值的指针，然后从其声明范围之外对其进行访问。`integer_returning_function`

```
int *pointer = NULL;
if (bool_returning_function()) {
    int value = integer_returning_function();
    pointer = &value;
}
*pointer = 42; // Error: invalid access of stack memory out of declaration scope
```

#### 解

确保不在变量范围之外访问变量，或使用`malloc`函数分配内存。
# 非空变量分配违规

[Nonnull Variable Assignment Violation](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/nonnull_variable_assignment_violation)

检测何时将空值错误地分配给变量。

---

## 总览

此检查检测何时为带注释的变量`_Nonnull`分配了空值。

> **注意**
> 默认情况下，禁用变量分配的非空违反检查。您可以通过使用编译器标志进行构建来启用它`-fsanitize=nullability-assign`。

### 在C中使用变量分配违反_Nonnull注释

在以下示例中，对的调用中断了变量的注释。`assigns_a_value``_Nonnull``q`

```
void assigns_a_value(int *p) {     
    int *_Nonnull q = p; // Warning: null can be assigned
}
assigns_a_value(NULL); // Error: _Nonnull variable violation
```

#### 解

更正逻辑错误或删除`_Nonnull`注释。
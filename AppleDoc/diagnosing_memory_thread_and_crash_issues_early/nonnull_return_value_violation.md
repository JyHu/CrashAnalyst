# 非空返回值违反

[Nonnull Return Value Violation](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/nonnull_return_value_violation)

检测函数何时错误地返回空值。

---

## 总览

此检查检测标记有属性的函数或带有注释的返回类型的函数何时返回空值。`returns_nonnull``_Nonnull`

> **注意**
> `_Nonnull`默认情况下，对带注释的返回类型的非空违反检查是禁用的。您可以通过使用编译器标志进行构建来启用它`-fsanitize=nullability-return`。

### 违反了C语言中的returns_nonnull属性

在以下代码中，违反了函数的属性。`returns_nonnull``nonnull_returning_function`

```
__attribute__((returns_nonnull)) int *nonnull_returning_function(int *p) {
    return p; // Warning: NULL can be returned here
}
nonnull_returning_function(NULL); // Error: nonnull return value attribute violation
```



#### 解

纠正逻辑错误，根据需要在函数中插入空防护，或删除属性并相应地重做函数调用程序逻辑。`returns_nonnull`

### 违反了C中返回类型的_Nonnull批注

在以下代码中，违反`_Nonnull`了该函数的返回类型的注释。`nonnull_returning_function`

```
int *_Nonnull nonnull_returning_function(int *p) {
    return p; // Warning: NULL can be returned here
}
nonnull_returning_function(NULL); // Error: nonnull return value attribute violation
```



#### 解

纠正逻辑错误，根据需要在函数中插入空防护，或删除`_Nonnull`注释并相应地重做函数调用程序逻辑。
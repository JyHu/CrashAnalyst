# 非空参数违反

[Nonnull Argument Violation](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/nonnull_argument_violation)

检测何时错误地将空值作为参数传递。

---

## 总览

此检查检测何时将带有标有该`nonnull`属性或`_Nonnull`注释的自变量的函数传递给空值。

> **注意**
> `_Nonnull`默认情况下，对带注释的参数的非空违反检查是禁用的。您可以通过使用编译器标志进行构建来启用它`-fsanitize=nullability-arg`。

### 违反C中的非空参数属性

在以下示例中，对该函数的调用中断了parameter的属性。`has_nonnull_argument``nonnull``p`

```
void has_nonnull_argument(__attribute__((nonnull)) int *p) { 
     // ... 
}
has_nonnull_argument(NULL); // Error: nonnull parameter attribute violation
```



#### 解

纠正逻辑错误，或删除`nonnull`属性并相应地重做被调用函数的逻辑。

### 违反C语言中某个参数的_Nonnull注释

在以下示例中，对函数的调用中断了参数的注释。`has_nonnull_argument``_Nonnull``p`

```
void has_nonnull_argument(int * _Nonnull p) { 
     // ... 
}
has_nonnull_argument(NULL); // Error: _Nonnull annotation violation
```



#### 解

纠正逻辑错误，或删除`_Nonnull`属性并相应地重做被调用函数的逻辑。
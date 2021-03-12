# 无效的枚举值

[Invalid Enumeration Value](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/invalid_enumeration_value)

检测枚举变量何时具有无效值。

---

## 总览

当其值不在类型的有效范围内时，此检查将检测对枚举变量的访问。当枚举未初始化时，或者当整数用作没有适当类型转换的枚举值时，可能会发生这种情况。超出范围的枚举值的使用具有未定义的行为，并且可能表明程序中存在逻辑错误。

### C ++中无效的枚举变量访问

在以下示例中，对`E`类型的强制转换无效，因为`2`它不在枚举的定义范围内。

```
enum E {
    a = 1
};
int value = 2;
enum E *e = (enum E *)&value;
return *e; // Error: 2 is out of the valid range for E
```



#### 解

确保枚举变量仅使用其定义范围内的值。
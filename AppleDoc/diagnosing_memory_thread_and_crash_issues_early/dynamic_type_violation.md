# 动态类型违规

[Dynamic Type Violation](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/dynamic_type_violation)

检测对象何时具有错误的动态类型。

---

## 总览

此检查检测对象何时具有错误的动态类型。动态类型冲突可能导致意外的代码执行。

### C ++中类型不正确的实例上的成员调用

在以下代码中，用于创建动态类型错误的变量。`reinterpret_cast`

```
struct Animal {
    virtual const char *speak() = 0;
};
struct Cat : public Animal {
    const char *speak() override {
        return "meow";
    }
};
struct Dog : public Animal {
    const char *speak() override {
      return "woof";
    }
};
auto *dog = reinterpret_cast<Dog *>(new Cat); // Error: dog has incorrect dynamic type
dog->speak(); // Error: this call has undefined behavior
```

该方法调用`dog->speak()`是可疑的。如果中的`speak`方法`Dog`被标记`final override`，则`dog->speak()`可能会返回`"woof"`，因为优化器可以取消调用的虚拟化；如果没有，它可能会返回`"meow"`。

> **注意**
> UBSan检查需要运行时类型信息，并且与`-fno-rtti`编译器标志不兼容。

#### 解

仅在有可能验证要投射的对象是目标类型的实例时才谨慎使用。`reinterpret_cast`
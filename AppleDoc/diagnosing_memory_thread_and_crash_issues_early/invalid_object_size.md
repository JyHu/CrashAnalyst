# 无效的物件大小

[Invalid Object Size](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/invalid_object_size)

检测由于类型大小不同而导致的无效指针强制转换。

---

## 总览

此检查将检测源类型的大小小于目标类型的大小的指针强制转换。使用这种强制转换的结果来访问越界数据具有未定义的行为。

### C ++中空间不足的类型从类型向下转换

在以下示例中，从`Base *`到的转换`Derived *`是可疑的，因为`Base`它的大小不足以包含的实例`Derived`。

```
struct Base {
    int pad1;
};
struct Derived : Base {
    int pad2;
};
Derived *getDerived() {
    return static_cast<Derived *>(new Base); // Error: invalid downcast
}
```

诸如之类的表达式可能会被优化器删除，因为它返回的指针指向的对象的大小不足以包含字段。`getDerived()->pad2``getDerived()``pad2`

> **注意**
> UBSan检查可能不会在低优化级别上触发。

#### 解

解决此问题的一种方法是避免下降，例如，`Derived`在需要的地方使用对象的实例。
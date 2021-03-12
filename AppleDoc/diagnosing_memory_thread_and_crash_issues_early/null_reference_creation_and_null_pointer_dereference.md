# 空引用创建和空指针取消引用

[Null Reference Creation and Null Pointer Dereference](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/null_reference_creation_and_null_pointer_dereference)

检测空引用和空指针取消引用的创建。

---

## 总览

此检查检测空引用和空指针取消引用的创建。取消引用空指针始终具有未定义的行为，并且可能导致崩溃。如果编译器发现了指针取消引用，它将将该指针视为非空。结果，可以优化对保证被取消引用的指针的空相等检查。

### 在C ++中创建一个空引用

在下面的示例中，将创建一个空引用。C ++中的引用必须为非null。

```
int &x = *(int *)nullptr; // Error: null reference
```



#### 解

请改用指针。

```
int *x = nullptr; // Correct
```

### 通过C ++中的空指针进行成员访问

在下面的示例中，对具有空地址的对象进行成员调用。编译器可能会删除`this`指针上的null检查，因为它必须为`nonnull`。

```
struct A {
    int x;
    int getX() {
        if (!this) { // Warning: redundant null check may be removed
            return 0;
        }
        return x; // Warning: 'this' pointer is null, but is dereferenced here
    }
};
A *a = nullptr;
int x = a->getX(); // Error: member access through null pointer
```



> **重要**
> 始终避免对`this`指针进行空检查。

#### 解

避免在空对象上调用方法。
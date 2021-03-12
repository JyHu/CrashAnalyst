# 指针未对齐

[Misaligned Pointer](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/misaligned_pointer)

检测代码何时访问未对齐的指针或创建未对齐的引用。

---

## 总览

此检查检测对未对齐指针的读取或写入，或创建未对齐引用。如果指针的地址不是其类型的对齐方式的倍数，则该指针未对齐。取消引用未对齐的指针具有未定义的行为，并可能导致崩溃或性能下降。

对齐冲突经常发生在对数据进行序列化或反序列化的代码中，可以通过使用保留数据对齐的序列化格式来避免这种情况。

### C中整数指针分配未对齐

在下面的示例中，`pointer`变量必须具有4字节对齐方式，但只有1字节对齐方式。

```
int8_t *buffer = malloc(64);
int32_t *pointer = (int32_t *)(buffer + 1);
*pointer = 42; // Error: misaligned integer pointer assignment
```

#### 解

使用类似的赋值函数`memcpy`，该函数可以处理未对齐的输入。

```
int8_t *buffer = malloc(64);
int32_t value = 42;
memcpy(buffer + 1, &value, sizeof(int32_t)); // Correct
```

> **注意**
> `memcpy`即使参数未对齐，编译器通常也可以安全地优化对的调用。

### C语言中结构指针分配错误

在下面的示例中，`pointer`变量必须具有8字节对齐方式，但只有1字节对齐方式。

```
struct A {
    int32_t i32;
    int64_t i64;
};
int8_t *buffer = malloc(32);
struct A *pointer = (struct A *)(buffer + 1);
pointer->i32 = 7; // Error: pointer is misaligned
```

#### 解

一种解决方案是将结构标记为已打包。在下面的示例中，该`A`结构被打包，以防止编译器在成员之间添加填充。

```
struct A { ... } __attribute__((packed));
```

> **重要**
> 将结构标记为已打包可能会对性能产生不利影响。
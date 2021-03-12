# 释放内存的使用

[Use of Deallocated Memory](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/use_of_deallocated_memory)

在释放内存后检测何时使用内存。

---

## 总览

此检查检测释放内存后何时使用内存。尝试使用释放的内存可能导致无法预测的行为。

### 在Objective-C中使用已分配内存

在以下示例中，变量具有所有权。由于引用的对象没有强引用，因此将其释放在自动释放池中，从而导致变量指向无效的内存。`unsafePointer``__unsafe_unretained`

```
__unsafe_unretained MyClass *unsafePointer;
@autoreleasepool {    
    MyClass *object = [MyClass new];
    unsafePointer = object;
}
NSLog(@"%d", unsafePointer->instanceVariable); 
// Error: unsafePointer is deallocated in autorelease pool
```



#### 解

使用或引用代替。强所有权确保仅当没有剩余的强引用对该对象时才释放该引用的对象。弱所有权对它所引用的对象的生命周期没有影响，但是可以确保在释放对象时引用一个变量。`__strong``__weak``__unsafe_unretained``nil`

### 在Objective-C中使用释放指针

当使用指向非对象类型的指针时，也会存在此问题。

在以下示例中，释放对象时，指向实例变量的指针无效。

```
int *unsafePointer;
@autoreleasepool {    
    MyClass *object = [MyClass new];
    unsafePointer = &object->instanceVariable;
}
NSLog(@"%d", *unsafePointer);
// Error: unsafePointer is invalidated when object is deallocated in autorelease pool
```

#### 解

尽可能使用属性访问器，而不是直接访问实例变量和指针。
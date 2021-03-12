# 未初始化的互斥体

[Uninitialized Mutexes](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/uninitialized_mutexes)

在初始化之前检测何时使用互斥锁。

---

## 总览

该检查可以随时检测，或者被未初始化的变量调用。尝试使用未初始化的互斥锁会导致错误，并且会消除在锁定互斥锁时可能存在的有关排序的保证。`pthread_mutex_lock(_:)``pthread_mutex_unlock(_:)``pthread_mutex_t`

### 在C中使用未初始化的互斥锁

在下面的示例中，该函数在未初始化的变量上调用。`pthread_mutex_lock(_:)``pthread_mutex_t`

```
static pthread_mutex_t mutex;
void performWork() {
    pthread_mutex_lock(&mutex); // Error: uninitialized mutex
    // ...
    pthread_mutex_unlock(&mutex);
}
```



#### 解

使用该函数可确保在使用互斥锁之前调用初始化。`pthread_once(_:_:)`

```
static pthread_once_t once = PTHREAD_ONCE_INIT;
static pthread_mutex_t mutex;
void init() {    
    pthread_mutex_init(&mutex, NULL);
}
void performWork() {
    pthread_once(&once, init); // Correct
    pthread_mutex_lock(&mutex);
    // ...
    pthread_mutex_unlock(&mutex);
}
```


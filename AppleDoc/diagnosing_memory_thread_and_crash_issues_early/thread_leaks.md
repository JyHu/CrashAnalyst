# 螺纹泄漏

[Thread Leaks](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/thread_leaks)

使用后检测何时未关闭线程。

---

## 总览

此检查将检测使用该函数创建的线程，而无需对该函数进行相应的调用。线程泄漏可能导致性能下降和程序崩溃。`pthread_create(_:_:_:_:)``pthread_join(_:_:)`

### C中的线程泄漏

在以下示例中，将`thread`创建变量，但使用后不会将其关闭。

```
void *run(){
    pthread_exit(0);
}
pthread_t thread;
pthread_create(&thread, NULL, run, NULL); // Error: thread leak
sleep(1);
```

#### 解

将调用添加到该函数。`pthread_join(_:_:)`

```
void *run(){
    pthread_exit(0);
}
pthread_t thread;
pthread_create(&thread, NULL, run, NULL);
sleep(1);
pthread_join(thread, NULL); // Correct
```

另外，您可以通过将属性传递给，或在创建后调用该线程来创建分离线程。`PTHREAD_CREATE_DETACHED``pthread_create(_:_:_:_:)``pthread_detach(_:)`
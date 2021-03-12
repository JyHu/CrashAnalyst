# 数据竞赛

[Data Races](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/data_races)

检测跨多个线程对可变状态的非同步访问。

---

## 总览

此检查检测多个线程何时在没有同步的情况下访问同一内存，并且至少一个访问是写操作。

### 生产者和消费者职能之间的数据竞赛

在下面的示例中，`producer()`函数设置全局变量`message`，并且`consumer()`函数在打印消息之前等待设置标志。因为`producer()`是在一个线程`consumer()`上执行而在另一个线程上执行，所以不能保证顺序，从而导致数据争用。

```
var message: String? = nil
var messageIsAvailable: Bool = false
// Executed on Thread #1
func producer() {
    message = "hello!"
    messageIsAvailable = true
}
// Executed on Thread #2
func consumer() {
    repeat {
        usleep(1000)
    } while !messageIsAvailable
    print(message)
}
```

#### 解

使用[调度](https://developer.apple.com/documentation/dispatch)API协调`message`跨多个线程的访问。
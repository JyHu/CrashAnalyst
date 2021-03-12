# 快速访问种族

[Swift Access Races](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/swift_access_races)

检测多个线程何时在相同结构上调用mutation方法，或何时传递共享变量（如`inout`不同步）。

---

## 总览

此检查检测在没有同步的情况下在同一结构上调用变异函数而未同步或将共享变量作为`inout`参数传递给函数调用而没有同步时发生的访问竞争。访问竞赛可能导致不可预测的行为。

### 变异结构方法的竞速竞赛

在下面的示例中，`producer()`函数将消息添加到全局数组，并且`consumer()`函数删除消息并将其打印。因为`producer()`是在一个线程`consumer()`上执行而在另一个线程上执行，并且在数组上都调用了变异方法，所以在上存在访问竞争`messages`。

```
var messages: [String] = []
// Executed on Thread #1
func producer() {
    messages.append("A message");
}
// Executed on Thread #2
func consumer() {
    repeat {
        let message = messages.remove(at: 0)
        print("\(message)")
    } while !messages.isEmpty
}
```

#### 解

使用[调度](https://developer.apple.com/documentation/dispatch)API协调`messages`跨多个线程的访问。

### 使用inout参数的访问竞赛

在以下示例中，该函数将数字写入全局字符串，并将函数将字母写入同一字符串。因为这两个函数在不同的线程上调用，两者都访问，因为上存在一个访问竞争。`writeNumbers()``writeLetters()``log``inout,``log`

```
var log: String = ""
// Executed on Thread #1
func writeNumbers() {
    print(1, 2, 3, separator: ",", to: &log)
}
// Executed on Thread #2
func writeLetters() {
    print("a", "b", "c", separator:",", to: &log)
}
```



#### 解

使用[调度](https://developer.apple.com/documentation/dispatch)API协调`log`跨多个线程的访问。
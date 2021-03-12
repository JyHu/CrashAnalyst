# 在集合和其他API上竞赛

[Races on Collections and Other APIs](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/races_on_collections_and_other_apis)

检测何时一个线程访问一个可变对象，而另一个线程对该对象进行写操作，从而导致数据争用。

---

## 总览

线程清理程序已扩展为检测[Foundation](https://developer.apple.com/documentation/foundation)和[Core Foundation](https://developer.apple.com/documentation/corefoundation)框架API的不安全线程访问。此功能适用于以下收集类型：

- [`NSMutableArray`](https://developer.apple.com/documentation/foundation/nsmutablearray)
- [`NSMutableDictionary`](https://developer.apple.com/documentation/foundation/nsmutabledictionary)
- [`CFMutableArray`](https://developer.apple.com/documentation/corefoundation/cfmutablearray)
- [`CFMutableDictionary`](https://developer.apple.com/documentation/corefoundation/cfmutabledictionary)



### 可变数组的集合竞赛

在下面的示例中，在一个线程中枚举了一个可变数组，同时在另一个线程中将其写入，而没有任何访问同步。

```
let array: NSMutableArray = []
var sum: Int = 0
// Executed on Thread #1
for value in array {
    sum += value as! Int
}
// Executed on Thread #2
array.add(42)
```

#### 解

使用[调度](https://developer.apple.com/documentation/dispatch)API协调`array`跨多个线程的访问。

### 带有可变字典的收藏竞赛

在下面的示例中，一个可变的字典在一个线程中枚举，而同时在另一个线程中被写入，而没有任何访问同步。

```
let dictionary: NSMutableDictionary = [:]
var sum: Int = 0
// Executed on Thread #1
for key in dictionary.keyEnumerator() {
    sum += dictionary[key] as! Int
}
// Executed on Thread #2
dictionary["forty-two"] = 42
```

#### 解

使用[调度](https://developer.apple.com/documentation/dispatch)API协调`dictionary`跨多个线程的访问。
# 解决Swift运行时错误导致的崩溃

[Addressing Crashes from Swift Runtime Errors](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_crashes_from_swift_runtime_errors)

识别Swift运行时错误的迹象，并解决运行时错误导致的崩溃。

---

## 总览

Swift使用内存安全技术来及早发现编程错误。可选要求您考虑如何最好地处理`nil`价值。类型安全性可防止将对象强制转换为与该对象的实际类型不匹配的类型。

如果您使用`!`运算符来强制打开一个可选值`nil`，或者如果您强制类型转换失败，而该`as!`运算符因运算符而失败，则Swift运行时会捕获这些错误，并有意使应用程序崩溃。如果您可以重现运行时错误，则Xcode将有关问题的信息记录到控制台。在ARM处理器上，崩溃报告中的异常信息如下所示：

```
Exception Type:  EXC_BREAKPOINT (SIGTRAP)
...
Termination Signal: Trace/BPT trap: 5
Termination Reason: Namespace SIGNAL, Code 0x5
```

在Intel处理器（包括适用于macOS，Mac Catalyst的应用程序以及适用于iOS，watchOS和tvOS的模拟器）上，崩溃报告中的异常信息如下所示：

```
Exception Type:        EXC_BAD_INSTRUCTION (SIGILL)
...
Exception Note:        EXC_CORPSE_NOTIFY

Termination Signal:    Illegal instruction: 4
Termination Reason:    Namespace SIGNAL, Code 0x4
```



### 确定错误的位置

崩溃报告显示遇到运行时错误的线程，在回溯中带有一个框架，用于标识特定的代码行。

```
Thread 0 Crashed:
0   MyCoolApp                         0x0000000100a71a88 @objc ViewController.viewDidLoad() (in MyCoolApp) (ViewController.swift:18)
1   MyCoolApp                         0x0000000100a71a40 @objc ViewController.viewDidLoad() (in MyCoolApp) (ViewController.swift:18)
2   UIKitCore                         0x00000001c569e920 -[UIViewController _sendViewDidLoadWithAppearanceProxyObjectTaggingEnabled] + 100
3   UIKitCore                         0x00000001c56a3430 -[UIViewController loadViewIfRequired] + 936
4   UIKitCore                         0x00000001c56a3838 -[UIViewController view] + 28
```

在此示例中，线程0遇到错误。的上线18发生运行错误这个线程示出了帧0 ，在方法：`ViewController.swift``viewDidLoad`

```
0   MyCoolApp                         0x0000000100a71a88 @objc ViewController.viewDidLoad() (in MyCoolApp) (ViewController.swift:18)
```



### 更改密码

查看回溯中的其他帧，以识别产生错误的确切函数调用，并确定是使用强制拆包还是强制向下转换。强制展开会使用`!`操作员。例如：

```
let image = UIImage(named: "aMissingIcon")!
print("Image size: \(image.size)")
```

`nil`通过使用可选绑定，可以优雅地处理该值在代码中首次出现的位置，而不是强制展开：

```
if let image = UIImage(named: "aMissingIcon") {
    print("Image size: \(image.size)")
}
```

有关[Optionals的](https://developer.apple.com/library/archive/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID330)更多信息，请参见Swift文档。

对于类型转换，强制向下转换使用`as!`运算符。如果`library`包含`Song`类型以外的其他内容，则此示例崩溃：

```
for item in library {
    let song = item as! Song
    print("Song: \(song.name), by \(song.artist)")
}
```

代替强制向下转换，可以使用条件向下转换来优雅地处理对象类型与预期类型不匹配的情况：

```
for item in library {
    if let song = item as? Song {
         print("Song: \(song.name), by \(song.artist)")
    }
}
```

有关[类型转换的](https://developer.apple.com/library/archive/documentation/Swift/Conceptual/Swift_Programming_Language/TypeCasting.html#//apple_ref/doc/uid/TP40014097-CH22)更多信息，请参见Swift文档。
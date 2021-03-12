# 调查僵尸对象的崩溃

[Investigating Crashes for Zombie Objects](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_crashes_for_zombie_objects)

识别僵尸的签名并调查崩溃的原因。

---

## 总览

一旦Objective-C或Swift对象不再具有对它的任何强引用，该对象就会被释放。试图进一步向对象发送消息，就好像它仍然是有效对象一样，是“释放后使用”的问题，被释放对象仍然接收称为*僵尸对象的*消息。

### 确定崩溃报告是否具有僵尸迹象

Objective-C的运行时无法消息对象从存储器释放，所以崩溃常发生在，或功能。例如，Objective-C运行时无法向已释放的对象发送消息的崩溃看起来像这样：[`objc_msgSend`](https://developer.apple.com/documentation/objectivec/1456712-objc_msgsend)`objc_retain``objc_release`

```
Thread 0 Crashed:
0   libobjc.A.dylib                   0x00000001a186d190 objc_msgSend + 16
1   Foundation                        0x00000001a1f31238 __NSThreadPerformPerform + 232
2   CoreFoundation                    0x00000001a1ac67e0 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 24
```

这是另一个示例，其中Objective-C运行时试图释放已经释放的对象：

```
Thread 2 Crashed:
0   libobjc.A.dylib                 0x00007fff7478bd5c objc_release + 28
1   libobjc.A.dylib                 0x00007fff7478cc8c (anonymous namespace)::AutoreleasePoolPage::pop(void*) + 726
2   com.apple.CoreFoundation        0x00007fff485feee6 _CFAutoreleasePoolPop + 22
```

指示僵尸对象的另一种模式是*无法识别的选择器*的堆栈框架，这是对象未实现的方法。通常，这种崩溃看起来像是代码，其中要求非预期类型的对象执行显然无法执行的操作，例如试图播放声音的数字格式化程序类。这是因为操作系统重用了曾经保存已释放对象的内存，而该内存现在包含另一种对象。由无法识别的选择器标识的僵尸具有使用以下方法的调用堆栈：[`doesNotRecognizeSelector(_:)`](https://developer.apple.com/documentation/objectivec/nsobject/1418637-doesnotrecognizeselector)

```
Last Exception Backtrace:
0   CoreFoundation                    0x1bf596a48 __exceptionPreprocess + 220
1   libobjc.A.dylib                   0x1bf2bdfa4 objc_exception_throw + 55
2   CoreFoundation                    0x1bf49a5a8 -[NSObject+ 193960 (NSObject) doesNotRecognizeSelector:] + 139
```

如果您在调试时重现此类崩溃，则控制台会记录其他信息：

```
Terminating app due to uncaught exception 'NSInvalidArgumentException', 
    reason: '-[NSNumberFormatter playSound]: 
    unrecognized selector sent to instance 0x28360dac0'
```

在此示例中，一条消息发送到来执行选择器，但未实现具有该名称的方法，因此该应用程序崩溃了。先前已为对象分配了与实现该方法的当前对象相同的内存地址，但是该对象已被释放，并且不相关的对象现在正在使用相同的内存地址。该选择器可用于调试线索。如果确定实现选择器的类，则可以确定调用选择器的代码路径，并确定为什么预期对象过早地释放。[`NumberFormatter`](https://developer.apple.com/documentation/foundation/numberformatter)`playSound``NumberFormatter``NumberFormatter``playSound``NumberFormatter``playSound``playSound`

### 调查僵尸的来源

如果崩溃是由僵尸对象引起的，则来自应用程序的堆栈帧可能在回溯中，但并非总是如此。即使您的应用程序中没有回溯框架参考代码，您的代码也有助于创建僵尸，所以请使用“僵尸”工具调查僵尸的来源，如“[查找僵尸”中所述](https://help.apple.com/instruments/mac/current/#/dev612e6956)。使用僵尸工具时，请寻找以下问题的答案，以便获得修改代码和删除僵尸所需的信息：

- 释放对象的类型是什么，向它发送了什么消息？
- 对象何时真正释放？
- 对象释放后如何使用？

修改代码时，请注意所涉及对象的预期寿命。考虑哪些对象使用强引用，哪些对象使用弱引用或无主引用，以便仅在不再需要且不会太快时才释放对象。有关Objective-C中的自动引用计数的信息，请参见[ARC概述](https://developer.apple.com/library/archive/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011226-CH1-SW13)；有关[Swift](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)中的信息，请参见[Swift文档](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)。
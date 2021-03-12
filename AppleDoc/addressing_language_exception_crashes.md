# 解决语言异常崩溃

[Addressing Language Exception Crashes](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_language_exception_crashes)

识别语言异常的迹象，并解决未捕获的语言异常导致的崩溃。

---

## 总览

语言异常（例如，来自Objective-C的语言异常）指示在运行时发现的编程错误，例如，访问索引超出范围的数组或未实现协议的必需方法。要确定崩溃是否是由于语言异常引起的，请首先确认崩溃报告包含以下模式：

```
Exception Type:  EXC_CRASH (SIGABRT)
Exception Codes: 0x0000000000000000, 0x0000000000000000
Exception Note:  EXC_CORPSE_NOTIFY
```

由于未捕获的语言异常而导致`Last Exception Backtrace`的崩溃在崩溃报告中具有。验证是否存在此回溯，以确认崩溃是由于语言异常引起的。

> **注意**
> 没有为C ++异常提供引发异常的代码的异常回溯。

### 识别引发异常的API

在中`Last Exception Backtrace`，操作系统记录导致异常的函数调用的完整回溯。此回溯以结束的帧结束，这些帧使您清楚地抛出了语言异常。再往回溯，您将找到有关引发异常的方法以及引发异常的方法的代码的关键信息。例如：

```
Last Exception Backtrace:
0   CoreFoundation                    0x1bf596a48 __exceptionPreprocess + 220
1   libobjc.A.dylib                   0x1bf2bdfa4 objc_exception_throw + 55
2   CoreFoundation                    0x1bf49b0ec -[NSException raise] + 11
3   Foundation                        0x1bf879170 -[NSObject+ 205168 (NSKeyValueCoding) setValue:forKey:] + 311
4   UIKitCore                         0x1c2ffa0b4 -[UIViewController setValue:forKey:] + 99
5   UIKitCore                         0x1c32c1234 -[UIRuntimeOutletConnection connect] + 123
6   CoreFoundation                    0x1bf470f3c -[NSArray makeObjectsPerformSelector:] + 251
7   UIKitCore                         0x1c32be3a4 -[UINib instantiateWithOwner:options:] + 1967
8   UIKitCore                         0x1c3000f18 -[UIViewController _loadViewFromNibNamed:bundle:] + 363
9   UIKitCore                         0x1c30019a4 -[UIViewController loadView] + 175
10  UIKitCore                         0x1c3001c5c -[UIViewController loadViewIfRequired] + 171
11  UIKitCore                         0x1c3002360 -[UIViewController view] + 27
12  UIKitCore                         0x1c3017a98 -[UIViewController _setPresentationController:] + 107
13  UIKitCore                         0x1c30108a4 -[UIViewController _presentViewController:modalSourceViewController:presentationController:animationController:interactionController:completion:] + 1343
14  UIKitCore                         0x1c30122b8 -[UIViewController _presentViewController:withAnimationController:completion:] + 4255
15  UIKitCore                         0x1c3014794 __63-[UIViewController _presentViewController:animated:completion:]_block_invoke + 103
16  UIKitCore                         0x1c3014c90 -[UIViewController _performCoordinatedPresentOrDismiss:animated:] + 507
17  UIKitCore                         0x1c30146e4 -[UIViewController _presentViewController:animated:completion:] + 195
18  UIKitCore                         0x1c301494c -[UIViewController presentViewController:animated:completion:] + 159
19  MyCoolApp                         0x104e8b1ac MasterViewController.viewDidLoad() (in MyCoolApp) (MasterViewController.swift:35)
```

在此示例回溯中，操作系统在帧0-2中引发了异常。第3帧引发了异常，因为它无法完成第`@IBOutlet`4-7帧中加载到内存中的Interface Builder文件中定义的属性的连接。框架8-17显示了UIKit准备呈现在Interface Builder中定义的该视图。帧18示出了这种碰撞从应用程序调用的开始，从称为在框架19框架19是信息调查此崩溃的关键部分; 它告诉您通过检查中第35行附近的源代码来确定哪个Interface Builder文件包含问题。[`present(_:animated:completion:)`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621380-present)[`viewDidLoad()`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621495-viewdidload)`MasterViewController.swift`

> **重要**
> 如果API引发的异常是：，则崩溃可能是由于僵尸对象引起的。有关其他信息，请参见[调查Zombie对象的崩溃](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_crashes_for_zombie_objects)。[`doesNotRecognizeSelector(_:)`](https://developer.apple.com/documentation/objectivec/nsobject/1418637-doesnotrecognizeselector)

### 检查异常消息

操作系统提供的未捕获的异常处理程序在终止进程之前将异常消息记录到控制台。如果您使用附加到应用程序的Xcode调试器重现语言异常导致的崩溃，则可以看到以下消息：

```
Application Specific Information:
*** Terminating app due to uncaught exception 'NSUnknownKeyException', 
    reason: '[<MyCoolApp.MyViewController 0x105510d50> setValue:forUndefinedKey:]: 
    this class is not key value coding-compliant for the key refreshButton.'
```

继续“[识别API引发异常”中](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_language_exception_crashes#3561600)的示例，该异常消息填充了异常回溯中不可见的详细信息-Interface Builder文件的出口名为，但类未使用该名称声明属性。`refreshButton``MyViewController``@IBOutlet`

iOS，iPadOS，watchOS和tvOS崩溃报告不包含异常消息，以防止通过异常消息公开有关用户的私人信息。Mac应用程序在`Application Specific Information`崩溃报告的字段中包含异常消息。

> **注意**
> [AppKit](https://developer.apple.com/documentation/appkit)应用程序具有默认的异常处理程序，该异常处理程序可捕获从其运行循环运行的代码引发的所有语言异常。它记录异常消息，然后允许该应用程序继续运行。

如果您可以重现语言异常崩溃，请设置异常断点以暂停执行并使用Xcode的调试器检查应用的状态，如[事件发生时暂停执行中](https://help.apple.com/xcode/mac/current/#/devfeaa874d0)所述。要在异常断点暂停执行时自动打印异常消息，请向运行调试器命令的异常断点添加操作：

```
po $arg1
```



### 系统语言异常导致的地址崩溃

在确定引发异常的操作系统的API之后，请查阅该API的文档以确定哪些条件触发了该异常。还可以尝试使用附加的Xcode调试器重现崩溃，以将回溯中的帧用作需要测试的特定代码的指南，以获取有关控制台中异常的其他信息。

如果您无法重现崩溃，请使用所有线程回溯（不仅是异常回溯）作为有关您的应用在崩溃时正在做什么的线索，并考虑该信息说明了您的应用状态。使用这些线索作为解决崩溃的起点。

### 处理应用程序代码引发的语言异常

iOS和iPadOS的64位版本使用零成本例外实现，其中每个函数都有其他数据，这些数据描述了如何展开堆栈，或者如果一个函数引发异常，则退出每个堆栈框架。如果抛出的异常遇到没有展开数据的堆栈帧，则异常处理将无法继续，并且进程将停止。可能在堆栈的更上方有一个异常处理程序，但是如果没有展开一帧的数据，就无法从引发异常的堆栈帧到达异常处理程序。

如果发现未捕获到由应用程序在异常处理域内引发的异常，请验证应用程序和库的构建设置是否允许编译器创建展开表：

- 不指定标志。`-no_compact_unwind`
- `-funwind-tables`如果要包含纯C代码，请指定标志。
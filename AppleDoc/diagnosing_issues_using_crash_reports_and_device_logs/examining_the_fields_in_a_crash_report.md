# 检查崩溃报告中的字段

[Examining the Fields in a Crash Report](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report)

了解崩溃报告的结构以及每个字段包含的信息。

---

## 总览

崩溃报告的每个部分均包含有助于您诊断崩溃原因的信息。

![崩溃报告的大纲，显示每个部分的位置。](../imgs/examining_the_fields_in_a_crash_report/3e57a46bfe-original-1591657437.png)


### 标头

崩溃报告的开头部分描述了崩溃发生的环境。

```
Incident Identifier: 6156848E-344E-4D9E-84E0-87AFD0D0AE7B
CrashReporter Key:   76f2fb60060d6a7f814973377cbdc866fffd521f
Hardware Model:      iPhone8,1
Process:             TouchCanvas [1052]
Path:                /private/var/containers/Bundle/Application/51346174-37EF-4F60-B72D-8DE5F01035F5/TouchCanvas.app/TouchCanvas
Identifier:          com.example.apple-samplecode.TouchCanvas
Version:             1 (3.0)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      launchd [1]
Coalition:           com.example.apple-samplecode.TouchCanvas [1806]

Date/Time:           2020-03-27 18:06:51.4969 -0700
Launch Time:         2020-03-27 18:06:31.7593 -0700
OS Version:          iPhone OS 13.3.1 (17D50)
```

标头中的字段可以包含以下信息。没有任何崩溃报告包含所有这些字段。

- `Incident Identifier`：报告的唯一标识符。两个报告永远不会共享同一份报告`Incident Identifier`。
- `CrashReporter Key`：每个设备的匿名标识符。来自同一设备的两个报告包含相同的值。擦除设备后将重置此标识符。
- `Beta Identifier`：设备和崩溃应用程序供应商的组合的唯一标识符。来自同一供应商和同一设备的应用程序的两个报告包含相同的值。该字段仅在应用程序的TestFlight构建中存在，并替换该字段。`CrashReporter Key`
- `Hardware Model`：运行该应用程序的特定设备型号。
- `Process`：崩溃的进程的可执行文件名称。这与应用程序的信息属性列表中的值匹配。括号中的数字是进程ID。[`CFBundleExecutable`](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleexecutable)
- `Path`：可执行文件在磁盘上的位置。macOS用占位符值替换了用户可识别的路径组件，以保护隐私。
- `Identifier`：崩溃的进程的。如果二进制文件没有，则此字段包含进程名称或占位符值。[`CFBundleIdentifier`](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier)`CFBundleIdentifier`
- `Version`：崩溃的进程版本。该值是应用程序和的串联。[`CFBundleVersion`](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleversion)[`CFBundleShortVersionString`](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleshortversionstring)
- `AppStoreTools`：Xcode的版本，用于编译应用程序的位代码并将应用程序精简到特定于设备的变体。
- `AppVariant`：通过应用程序细化产生的应用程序特定变体。该字段包含多个值，本节稍后将进行介绍。
- `Code Type`：崩溃的进程的CPU体系结构。值中的一个`ARM-64`，`ARM`，`X86-64`，或`X86`。
- `Role`：[终止时](https://opensource.apple.com/source/xnu/xnu-3248.60.10/osfmk/mach/task_policy.h)分配给进程的[task_role](https://opensource.apple.com/source/xnu/xnu-3248.60.10/osfmk/mach/task_policy.h)。当您分析崩溃报告时，该字段通常没有帮助。
- `Parent Process`：启动崩溃进程的进程的名称和进程ID（在方括号中）。
- `Coalition`：包含应用程序的流程联盟的名称。进程联盟跟踪相关进程组之间的资源使用情况，例如在应用程序中支持特定API功能的操作系统进程。包括应用程序扩展程序在内的大多数进程都组成了自己的联盟。
- `Date/Time`：崩溃的日期和时间。
- `Launch Time`：应用启动的日期和时间。
- `OS Version`：发生崩溃的操作系统版本，包括内部版本号。

该字段包含三个用冒号分隔的值，例如。这些字段表示：`AppVariant``1:iPhone10,6:12.2`

- 内部系统值。该值对于诊断崩溃没有用。在示例中，此值为`1`。
- 细化变体的名称。该变体表示一类具有类似特征的设备，例如屏幕比例，内存类和Metal GPU系列。细化变体的名称并不表示崩溃报告所来自的确切硬件模型，并且可能与`Hardware Model`字段不同。在示例中，此值为。`iPhone10,6`
- 操作系统版本变体。对于每种类型的设备，应用程序精简会为操作系统的不同版本创建其他变体。在示例中，此值为，表示此变体以运行iOS 12.2或更高版本的iOS设备为目标。`12.2`

### 异常信息

每个崩溃报告均包含异常信息。此信息部分告诉您该过程如何终止，但可能无法完全说明该应用为何终止。此信息很重要，但经常被忽略。

```
Exception Type:  EXC_BREAKPOINT (SIGTRAP)
Exception Codes: 0x0000000000000001, 0x0000000102afb3d0
```

> **注意**
> 此异常信息不涉及由API或Objective-C或C ++中的语言功能引发的语言异常。崩溃报告单独记录语言异常信息。

以下字段提供有关异常的信息。没有任何崩溃报告包含所有这些字段。

- `Exception Type`：终止进程的Mach异常的名称，以及括号中相应的BSD终止信号的名称。请参阅[了解崩溃报告中的异常类型](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/understanding_the_exception_types_in_a_crash_report)。
- `Exception Codes`：关于处理器的特定于异常的信息，编码为一个或多个64位十六进制数字。通常，此字段不存在，因为操作系统在此部分的其他字段中将信息显示为人类可读的信息。
- `Exception Subtype`：人类可读的异常代码描述。
- `Exception Message`：从异常代码中提取的其他人类可读信息。
- `Exception Note`：并非特定于一种异常类型的其他信息。如果包含此字段，则崩溃不是由硬件陷阱引起的，要么是由于进程已由操作系统明确终止，要么是由于进程被称为。如果此字段包含，则进程不会崩溃，但是操作系统随后可能已请求终止进程。如果此字段包含，则该过程不会终止，因为创建崩溃报告的问题不是致命的。`EXC_CORPSE_NOTIFY``abort()``SIMULATED (this is NOT a crash)``NON-FATAL CONDITION (this is NOT a crash)`
- `Termination Reason`：操作系统终止进程时指定的退出原因信息。进程内部和外部的关键操作系统组件在遇到致命错误时都会终止进程，并在此字段中记录原因。您可以在此字段中找到的信息示例包括有关无效代码签名，缺少依赖库或在没有目的字符串的情况下访问隐私敏感信息的消息。
- `Triggered by Thread`或`Crashed Thread`：引发异常的线程。

### 诊断信息

操作系统有时包括其他诊断信息。此信息使用多种格式，具体取决于崩溃的原因，并非在每个崩溃报告中都提供。

刚好在进程终止之前发生的框架错误消息出现在该`Application Specific Information`字段中。在此示例中，[Dispatch](https://developer.apple.com/documentation/dispatch)框架记录了有关不正确使用调度队列的错误：

```
Application Specific Information:
BUG IN CLIENT OF LIBDISPATCH: dispatch_sync called on queue already owned by current thread
```

> **注意**
> `Application Specific Information` 有时会从崩溃报告中删除，以避免在消息中记录对隐私敏感的信息。

由于违反看门狗而导致的终止包含一个`Termination Description`字段，其中包含有关看门狗触发原因的信息。

```
Termination Description: SPRINGBOARD, 
    scene-create watchdog transgression: application<com.example.MyCoolApp>:667
    exhausted real (wall clock) time allowance of 19.97 seconds 
```

[解决看门狗终端](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_watchdog_terminations)将更详细地介绍看门狗终端以及如何解释此信息。

由于内存访问问题而导致的终止包含有关`VM Region Info`字段中虚拟内存区域的信息。

```
VM Region Info: 0 is not in any region.  Bytes before following region: 4307009536
      REGION TYPE                      START - END             [ VSIZE] PRT/MAX SHRMOD  REGION DETAIL
      UNUSED SPACE AT START
--->  
      __TEXT                 0000000100b7c000-0000000100b84000 [   32K] r-x/r-x SM=COW  ...pp/MyGreatApp
```

[调查内存访问崩溃](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes)将详细介绍此信息。

### 回溯

崩溃进程的每个线程都被捕获为回溯，记录了进程终止时线程上运行的代码。回溯与您使用调试器暂停过程时看到的类似。由语言异常引起的崩溃包括一个附加的回溯`Last Exception Backtrace`，位于第一个线程之前。如果您的崩溃报告包含`Last Exception Backtrace`，请参阅“[解决语言异常崩溃”](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_language_exception_crashes)以获取特定于语言异常崩溃的信息。

每个回溯的第一行列出了线程号和线程名称。出于隐私方面的考虑，通过Xcode中的[崩溃管理器](https://help.apple.com/xcode/mac/current/#/dev675635e70)提供的[崩溃](https://help.apple.com/xcode/mac/current/#/dev675635e70)报告不包含线程名称。这个例子显示了三个线程的回溯。`Thread 0`崩溃，并通过其名称标识为应用程序的主线程：

```
Thread 0 name:  Dispatch queue: com.apple.main-thread
Thread 0 Crashed:
0   TouchCanvas                       0x0000000102afb3d0 CanvasView.updateEstimatedPropertiesForTouches(_:) + 62416 (CanvasView.swift:231)
1   TouchCanvas                       0x0000000102afb3d0 CanvasView.updateEstimatedPropertiesForTouches(_:) + 62416 (CanvasView.swift:231)
2   TouchCanvas                       0x0000000102af7d10 ViewController.touchesMoved(_:with:) + 48400 (<compiler-generated>:0)
3   TouchCanvas                       0x0000000102af80b8 @objc ViewController.touchesMoved(_:with:) + 49336 (<compiler-generated>:0)
4   UIKitCore                         0x00000001ba9d8da4 forwardTouchMethod + 328
5   UIKitCore                         0x00000001ba9d8e40 -[UIResponder touchesMoved:withEvent:] + 60
6   UIKitCore                         0x00000001ba9d8da4 forwardTouchMethod + 328
7   UIKitCore                         0x00000001ba9d8e40 -[UIResponder touchesMoved:withEvent:] + 60
8   UIKitCore                         0x00000001ba9e6ea4 -[UIWindow _sendTouchesForEvent:] + 1896
9   UIKitCore                         0x00000001ba9e8390 -[UIWindow sendEvent:] + 3352
10  UIKitCore                         0x00000001ba9c4a9c -[UIApplication sendEvent:] + 344
11  UIKitCore                         0x00000001baa3cc20 __dispatchPreprocessedEventFromEventQueue + 5880
12  UIKitCore                         0x00000001baa3f17c __handleEventQueueInternal + 4924
13  UIKitCore                         0x00000001baa37ff0 __handleHIDEventFetcherDrain + 108
14  CoreFoundation                    0x00000001b68a4a00 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 24
15  CoreFoundation                    0x00000001b68a4958 __CFRunLoopDoSource0 + 80
16  CoreFoundation                    0x00000001b68a40f0 __CFRunLoopDoSources0 + 180
17  CoreFoundation                    0x00000001b689f23c __CFRunLoopRun + 1080
18  CoreFoundation                    0x00000001b689eadc CFRunLoopRunSpecific + 464
19  GraphicsServices                  0x00000001c083f328 GSEventRunModal + 104
20  UIKitCore                         0x00000001ba9ac63c UIApplicationMain + 1936
21  TouchCanvas                       0x0000000102af16dc main + 22236 (AppDelegate.swift:12)
22  libdyld.dylib                     0x00000001b6728360 start + 4

Thread 1:
0   libsystem_pthread.dylib           0x00000001b6645758 start_wqthread + 0

Thread 2:
0   libsystem_pthread.dylib           0x00000001b6645758 start_wqthread + 0
...
```

在线程号之后，回溯的每一行代表回溯中的堆栈帧。

```
0   TouchCanvas                       0x0000000102afb3d0 CanvasView.updateEstimatedPropertiesForTouches(_:) + 62416 (CanvasView.swift:231)
```

堆栈帧的每一列都包含有关崩溃时执行的代码的信息。下表使用上例中的堆栈帧0的组件。

- `0`。堆栈帧号。堆栈帧按调用顺序排列，其中帧0是暂停执行时正在执行的函数。框架1是在框架0中调用该函数的函数，依此类推。
- `TouchCanvas`。包含正在执行的函数的二进制文件的名称。
- `0x0000000102afb3d0`。正在执行的机器指令的地址。对于每个回溯中的帧0，这是进程终止时在线程上执行的机器指令的地址。对于其他堆栈帧，这是在控制权返回到该堆栈帧之后执行的第一条机器指令的地址。
- `CanvasView.updateEstimatedPropertiesForTouches(_:)`。在完全符号化的崩溃报告中，正在执行的函数的名称。出于隐私原因，功能名称有时限制为前100个字符。
- `62416`。后面的数字`+`是从函数入口到函数当前指令的字节偏移量。
- `CanvasView.swift:231`。如果您有二进制文件，则包含代码的文件名和行号。`dSYM`

在某些情况下，文件名或行号信息与原始源代码不对应：

- 如果源文件名为`<compiler-generated>`，则编译器将为该框架创建代码，而该代码不在您的源文件中。如果这是崩溃线程中的最高帧，请查看前面的几个堆栈帧以获取线索。
- 如果源文件的行号为`0`，则表示回溯不会映射到原始代码中的特定代码行。这是因为编译器优化了代码，例如通过内联函数，并且崩溃时执行的代码与原始代码中的确切行不对应。在这种情况下，框架的功能名称仍然是一个线索。

### 线程状态

当应用终止时，崩溃报告的线程状态部分列出了CPU寄存器及其崩溃线程的值。了解线程状态是一个高级主题，需要了解操作系统的应用程序二进制接口（ABI）。请参阅《[OS X ABI函数调用指南》](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html#//apple_ref/doc/uid/TP40002437-SW1)和《[iOS ABI函数调用指南》](https://developer.apple.com/library/archive/documentation/Xcode/Conceptual/iPhoneOSABIReference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009023)。

```
Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000000000001   x1: 0x0000000000000000   x2: 0x0000000000000000   x3: 0x000000000000000f
    x4: 0x00000000000001c2   x5: 0x000000010327f6c0   x6: 0x000000010327f724   x7: 0x0000000000000120
    x8: 0x0000000000000001   x9: 0x0000000000000001  x10: 0x0000000000000001  x11: 0x0000000000000000
   x12: 0x00000001038612b0  x13: 0x000005a102b075a7  x14: 0x0000000000000100  x15: 0x0000010000000000
   x16: 0x00000001c3e6c630  x17: 0x00000001bae4bbf8  x18: 0x0000000000000000  x19: 0x0000000282c14280
   x20: 0x00000001fe64a3e0  x21: 0x4000000281f1df10  x22: 0x0000000000000001  x23: 0x0000000000000000
   x24: 0x0000000000000000  x25: 0x0000000282c14280  x26: 0x0000000103203140  x27: 0x00000001bacf4b7c
   x28: 0x00000001fe5ded08   fp: 0x000000016d311310   lr: 0x0000000102afb3d0
    sp: 0x000000016d311200   pc: 0x0000000102afb3d0 cpsr: 0x60000000
   esr: 0xf2000001  Address size fault
```

寄存器提供了有关内存访问问题引起的崩溃的更多信息。[了解崩溃的线程的寄存器](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/analyzing_a_crash_report#3582422)将进一步讨论该方案。

### 二进制图像

崩溃报告的二进制图像部分列出了终止时在进程中加载的所有代码，例如应用程序可执行文件和系统框架。“二进制图像”部分中的每一行代表一个二进制图像。iOS，watchOS和tvOS使用以下格式：

```
Binary Images:
0x102aec000 - 0x102b03fff TouchCanvas arm64  <fe7745ae12db30fa886c8baa1980437a> /var/containers/Bundle/Application/51346174-37EF-4F60-B72D-8DE5F01035F5/TouchCanvas.app/TouchCanvas
...
```

此列表包含上述示例中的组件：

- `0x102aec000 - 0x102b03fff`。进程中二进制映像的地址范围。第一个地址是二进制文件的加载地址。有关如何使用此值的信息，请参见[用命令行符号化崩溃报告](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/adding_identifiable_symbol_names_to_a_crash_report#3403800)。
- `TouchCanvas`。二进制名称。
- `arm64`。操作系统加载到进程中的二进制映像的CPU体系结构。
- `fe7745ae12db30fa886c8baa1980437a`。唯一标识二进制映像的构建UUID。在象征崩溃报告时，使用此值来找到相应的文件。有关构建UUID的更多信息，请参见[构建应用程序以包含调试信息](https://developer.apple.com/documentation/xcode/building_your_app_to_include_debugging_information)。`dSYM`
- `/var/containers/.../TouchCanvas.app/TouchCanvas`。磁盘上二进制文件的路径。macOS用占位符值替换了用户可识别的路径组件，以保护隐私。

macOS在本节中使用以下格式：

```
Binary Images:
       0x1025e5000 -        0x1025e6ffb +com.example.apple-samplecode.TouchCanvas (1.0 - 1) <5ED9BD63-2A55-3DDD-B3FF-EFCF61382F6F> /Users/USER/*/TouchCanvas.app/Contents/MacOS/TouchCanvas
```

此列表包含上述示例中的组件：

- `0x105f97000 - 0x105f98ffb`。进程中二进制映像的地址范围。第一个地址是二进制文件的加载地址。有关如何使用此值的信息，请参见[用命令行符号化崩溃报告](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/adding_identifiable_symbol_names_to_a_crash_report#3403800)。
- `+com.example.apple-samplecode.TouchCanvas`。的。该前缀表示二进制不是MacOS的部分。[`CFBundleIdentifier`](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier)`+`
- `1.0 - 1`。二进制的和。[`CFBundleShortVersionString`](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleshortversionstring)[`CFBundleVersion`](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleversion)
- `5ED9BD63-2A55-3DDD-B3FF-EFCF61382F6F`。唯一标识二进制映像的构建UUID。在象征崩溃报告时，使用此值来找到相应的文件。有关构建UUID的更多信息，请参见[构建应用程序以包含调试信息](https://developer.apple.com/documentation/xcode/building_your_app_to_include_debugging_information)。`dSYM`
- `/Users/USER/*/TouchCanvas.app/Contents/MacOS/TouchCanvas`。磁盘上二进制文件的路径。macOS用占位符值替换了用户可识别的路径组件，以保护隐私。
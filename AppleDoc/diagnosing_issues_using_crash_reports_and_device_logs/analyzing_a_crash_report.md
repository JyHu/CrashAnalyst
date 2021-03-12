# 分析崩溃报告

[Analyzing a Crash Report](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/analyzing_a_crash_report)

在崩溃报告中找出有助于诊断问题的线索。

---

## 总览

崩溃报告是应用程序崩溃时的详细状态日志，使其成为尝试修复问题之前识别问题的重要资源。如果要调查的故障无法通过[确定常见](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes)故障[的原因中](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes)讨论的技术解决，则需要对完整的故障报告进行仔细的分析。

> **重要**
> 始终分析由操作系统生成的完全符号化的崩溃报告。请参阅[确定崩溃报告是否为符号，](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/adding_identifiable_symbol_names_to_a_crash_report#3403796)以验证崩溃报告是否为完全符号。

分析崩溃报告时，请阅读所有部分中的信息。在制定有关崩溃原因的假设时，请询问有关崩溃报告每个部分中的数据说明了什么，以完善或反驳该假设。某些提示由崩溃报告中的字段显式捕获，但是其他提示很细微，需要您注意一些小细节才能发现它们。对崩溃报告进行彻底的分析并提出假设需要花费时间和实践来开发，但这是使您的应用程序更强大的关键工具。

> **注意**
> 如果您请求Apple分析崩溃报告的帮助（例如通过错误报告），Apple开发者论坛或开发者技术支持，请始终完整地包括操作系统中的崩溃报告。操作系统的部分崩溃报告以及应用程序中包含的第三方分析库生成的崩溃报告并不包含所有必要信息。

### 从用户的角度出发

从崩溃报告的信息中找到一个起点，从用户的角度考虑崩溃以完善假设。例如，回溯中的框架可能表示该应用程序的特定功能正在使用中，您可以考虑崩溃报告中的其他信息与该功能之间的关系。

### 根据相似且唯一的详细信息将多个崩溃报告分组

如果您有很多崩溃报告，请尝试将它们组织成组以阐明崩溃的来源。如果许多崩溃报告包含的信息完全相同，则该问题很可能是可重现的，并且崩溃报告中的常见详细信息可帮助您隔离问题。如果您的崩溃报告看上去都不同，但是您怀疑根本原因是相同的，请注意任何看起来异常的细节。将具有异常详细信息的任何崩溃报告放入自己的组中。通过基于相似和相异的详细信息对崩溃报告进行分组，有时您会发现崩溃原因的见解，而这些见解在单独查看崩溃报告时是不可见的。

### 检查标题以识别崩溃环境

如果您有多个类似的崩溃报告，请使用标题信息来帮助您了解问题的范围，并针对需要重现问题的特定操作系统版本和设备。一些可以帮助您完善关于崩溃的假设的问题是：

- 崩溃是在应用的多个版本中发生还是仅在一个版本中发生？
- 崩溃是否在多个版本的操作系统上发生？
- 是否仅通过一种类型的设备（例如iPad而不是iPhone）崩溃？
- 崩溃是源自您的主应用程序还是源自某个应用程序扩展程序？
- 是因为您的应用程序的TestFlight Beta崩溃了？
- 是否所有崩溃都来自同一应用程序变薄版本？如果您导出特定的应用变体，是否可以重现崩溃？要导出特定的应用变体，请参阅[选择分发方法和选项](https://developer.apple.com/documentation/xcode/distributing_your_app_for_beta_testing_and_releases#3405658)。
- 应用程序崩溃在哪种设备型号上？您在具有类似功能的设备上进行了多少测试？
- 是多个用户经历崩溃，还是只有少数唯一用户经历崩溃？使用或字段来确定。`CrashReporter Key``Beta Identifier`
- 该应用程序崩溃前已运行了多长时间？使用`Date/Time`和`Launch Time`字段来确定。

如果您在崩溃报告的此部分不熟悉特定字段或其值，请查阅[Header](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report#3582427)。

### 识别异常信息

每个崩溃报告都会记录异常信息，这些异常信息显示了终止应用程序进程的确切机制。终止始终是错误处理的最后一步，但它始于应用程序或所使用的框架中出现不可恢复的情况。例如，应用程序可以直接请求终止，例如通过调用`abort()`。作为不同的示例，操作系统可以终止该过程以强制执行系统策略，例如通过确保应用程序响应能力的看门狗。

异常信息可以缩小您正在分析的崩溃的来源，并帮助您识别崩溃报告其他部分中寻找的线索。有关正在分析的崩溃报告中特定异常类型的详细信息，请参阅[了解崩溃报告](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/understanding_the_exception_types_in_a_crash_report)中的异常类型，然后回答以下问题：

- 什么是异常类型？异常定义什么类型的错误？
- 哪个线程触发了崩溃？您看到崩溃线程的回溯中的帧与异常类型传达的信息之间有什么关系？
- 异常类型可以排除哪些类型的潜在问题？例如，该异常排除了崩溃是由于未捕获的语言异常引起的。`EXC_BAD_ACCESS`
- 该`Termination Reason`字段中是否还有其他代码？代码是什么意思？
- 异常类型是否表示特定的诊断工具对于发现问题有用？
- 异常是否与特定类型的系统资源有关？

如果您不熟悉本节中的字段，请参阅[异常信息](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report#3582411)。

### 查找诊断消息

对于某些类型的问题，崩溃报告可能在“异常信息”部分和“回溯”部分之间包含其他诊断信息。此信息与异常类型直接相关。

- 根据异常类型，是否由于未捕获的语言异常而导致崩溃？如果是这样，消息中还包含有关API引发异常的其他信息？有关其他信息，请参见[解决语言异常崩溃](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_language_exception_crashes)。
- 根据异常类型，崩溃是由于内存访问问题引起的吗？有关如何解码所提供的信息，请参阅[调查内存访问崩溃](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes)`VM Region Info`。
- 是否有一个`Termination Description`字段指示操作系统的特定部分参与其中？`Termination Reason`现场是否还有其他代码？消息提示问题的根源是什么？
- 有`Application Specific Information`田野吗？该消息中是否有特定的API命名？您在代码中的哪里使用该API？

如果您不熟悉本节中的字段，请参阅[诊断消息](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report#3582416)。

### 阅读回溯

崩溃报告中的回溯显示崩溃时执行的确切方法，请参阅[回溯](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report#3582410)以获取本节各列含义的细分。首先，查看崩溃的线程以及`Last Exception Backtrace`是否存在崩溃的线程。回答以下有关回溯的问题：

- 此线程在应用程序中提供什么功能？是主线程还是其他具有特定用途的线程？
- 是否引发了语言异常？什么是`Last Exception Backtrace`表演？
- 应用程序的哪些部分使用此线程以及该线程的回溯中显示的功能？
- 您的应用程序和Apple的系统框架中的二进制文件有哪些组合？

即使backtrace中的函数不是您直接调用的函数，它们也包含关键线索。例如，此回溯仅包含应用程序`main`功能以外的系统框架，但崩溃是由于iPadOS应用程序中的无效弹出窗口配置引起的：

```
Last Exception Backtrace:
0   CoreFoundation                    0x1a1801190 __exceptionPreprocess + 228
1   libobjc.A.dylib                   0x1a09d69f8 objc_exception_throw + 55
2   UIKitCore                         0x1cd5d0af0 -[UIPopoverPresentationController presentationTransitionWillBegin] + 2739
3   UIKitCore                         0x1cd5d9358 __71-[UIPresentationController _initViewHierarchyForPresentationSuperview:]_block_invoke + 2175
4   UIKitCore                         0x1cd5d6ea4 __56-[UIPresentationController runTransitionForCurrentState]_block_invoke + 463
5   UIKitCore                         0x1cdc5c0ac _runAfterCACommitDeferredBlocks + 295
6   UIKitCore                         0x1cdc4abfc _cleanUpAfterCAFlushAndRunDeferredBlocks + 351
7   UIKitCore                         0x1cdc77a6c _afterCACommitHandler + 115
8   CoreFoundation                    0x1a179250c __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__ + 31
9   CoreFoundation                    0x1a178d234 __CFRunLoopDoObservers + 411
10  CoreFoundation                    0x1a178d7b0 __CFRunLoopRun + 1227
11  CoreFoundation                    0x1a178cfc4 CFRunLoopRunSpecific + 435
12  GraphicsServices                  0x1a398e79c GSEventRunModal + 103
13  UIKitCore                         0x1cdc50c38 UIApplicationMain + 211
14  MyGreatApp                        0x10079600c main (in MyGreatApp) (AppDelegate.swift:12)
15  libdyld.dylib                     0x1a124d8e0 start + 3
```

框架3和4提供了此崩溃与呈现视图控制器有关的线索，框架2是应用程序呈现弹出窗口的线索。即使回溯中没有应用程序的代码，此信息也可以缩小应用程序代码的哪些部分集中。

您可以根据线程回溯中的底部帧来频繁确定线程的用途。应用程序的主线程在底部框架中具有或。通过[Dispatch](https://developer.apple.com/documentation/dispatch)框架创建的线程位于底部框架中。当您仔细查看崩溃线程的回溯时，请考虑您的应用程序是否以与您对应用程序功能的期望相符的一致状态出现：[`NSApplicationMain(_:_:)`](https://developer.apple.com/documentation/appkit/1428499-nsapplicationmain)[`UIApplicationMain(_:_:_:_:)`](https://developer.apple.com/documentation/uikit/1622933-uiapplicationmain)`start_wqthread`

- 应用程序中的代码是否应在此特定线程上运行？
- 崩溃的线程是后台线程吗？
- 是否有任何回溯在除主线程之外的任何线程上显示应用程序操纵UI元素？您是否已对`Main Thread Checker`启用的应用程序进行了测试？
- 如果您的代码使用带有完成处理程序的API，那么该API是否可以保证完成处理程序使用的特定队列？您的代码是否期望该队列？
- 如果您的代码使用了向API提供的API，崩溃报告是否表明您正在使用所需的队列？[`DispatchQueue`](https://developer.apple.com/documentation/dispatch/dispatchqueue)

除了针对崩溃的线程或语言异常的回溯，其他线程回溯还提供了有关应用程序处于何种状态的其他线索。这些线索很微妙：

- 其他线程是否有助于指示应用程序处于什么状态？例如，如果您看到“[联系人”](https://developer.apple.com/documentation/contacts)框架中带有框架的线程，并且仅访问应用程序某一部分中的联系人，则可以将调查重点放在应用程序那部分的崩溃上。
- 其他线程回溯中是否还包含与崩溃线程回溯中的帧相关的帧？那说明应用程序状态如何？
- 是否有许多线程具有相似的状态，例如在等待系统资源的帧之前，您的应用程序具有相同的功能集？

在某些类型的崩溃中，崩溃的线程的回溯并不能始终包含问题的根源。[“解决看门狗终止”](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_watchdog_terminations)描述了发生看门狗终止的情况，而“[调查内存访问崩溃”](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes)描述了此情况下的内存损坏崩溃。

### 了解崩溃线程的寄存器

分析大多数崩溃报告无需考虑寄存器状态。但是，如果您要调查内存访问困难的问题，寄存器将提供崩溃报告中其他地方未找到的信息。

- 内存访问是通过内存获取还是通过指令获取？
- 程序计数器，链接寄存器和堆栈指针寄存器是否在程序的地址空间中包含有效地址？
- 如果使用`atos`符号表示链接寄存器中的地址，它的作用是什么？该函数是否通过函数指针跳到其他代码？[使用命令行符号化崩溃报告](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/adding_identifiable_symbol_names_to_a_crash_report#3403800)描述了如何使用`atos`。

[确定导致此问题的内存访问类型](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes#3562197)介绍了如何使用这些问题来诊断内存访问崩溃。

### 验证二进制图像中是否存在您的框架

使用当机报告的“二进制图像”部分来评估您的应用程序加载的框架。您可以通过文件路径识别应用程序中的框架。

- 应用程序在崩溃时加载了哪些框架？您的应用提供的框架是否缺失？
- 如果缺少框架，您是否希望系统在应用启动时自动加载框架，还是通过调用手动加载框架？`dlopen(_:_:)`
- 您的应用程序有多少个框架？如果您正在调查看门狗终止，则应用程序内部的大量框架可能会消耗应用程序启动时间预算的很大一部分。

有关本节中每列的含义，请参见[Binary Images](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report#3582434)。
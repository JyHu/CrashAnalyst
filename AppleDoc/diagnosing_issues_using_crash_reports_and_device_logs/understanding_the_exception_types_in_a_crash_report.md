# 了解崩溃报告中的异常类型

[Understanding the Exception Types in a Crash Report](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/understanding_the_exception_types_in_a_crash_report)

了解异常类型告诉您应用程序崩溃的原因。

---

## 总览

崩溃报告中的异常类型描述了应用如何终止。这是指导如何调查问题根源的关键信息。

```
Exception Type: EXC_BAD_ACCESS (SIGSEGV)
```

> **注意**
> 本文中的异常信息不涉及由API或Objective-C或C ++中的语言功能引发的语言异常。崩溃报告单独记录语言异常信息。

这里总结了异常类型。有关更多信息，请参见以下各节。

- [EXC_BREAKPOINT（SIGTRAP）和EXC_BAD_INSTRUCTION（SIGILL）](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/understanding_the_exception_types_in_a_crash_report#3582420)。跟踪陷阱中断了该过程。
- `EXC_BAD_ACCESS`。崩溃是由于内存访问问题。请参阅[调查内存访问崩溃](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes)。
- [EXC_CRASH（SIGABRT）](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/understanding_the_exception_types_in_a_crash_report#3582414)。该进程终止，因为它收到了`SIGABRT`。
- [EXC_CRASH（SIGKILL）](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/understanding_the_exception_types_in_a_crash_report#3582412)。操作系统终止了该过程。
- [EXC_CRASH（SIGQUIT）](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/understanding_the_exception_types_in_a_crash_report#3582424)。该进程在另一个进程的请求下终止。
- [EXC_GUARD](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/understanding_the_exception_types_in_a_crash_report#3582421)。该过程违反了受保护的资源保护。
- [EXC_RESOURCE](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/understanding_the_exception_types_in_a_crash_report#3582415)。该过程超出了资源消耗限制。
- `EXC_ARITHMETIC`。崩溃的线程执行了无效的算术运算，例如被零除或浮点错误。

### EXC_BREAKPOINT（SIGTRAP）和EXC_BAD_INSTRUCTION（SIGILL）

断点异常类型指示跟踪陷阱中断了该过程。跟踪陷阱使附加的调试器有机会在执行的特定点中断该进程。在ARM处理器上，显示为。在处理器上，显示为。`EXC_BREAKPOINT (SIGTRAP). ``x86_64``EXC_BAD_INSTRUCTION (SIGILL)`

Swift运行时将跟踪陷阱用于特定类型的不可恢复的错误-有关这些错误的信息，请参见[解决Swift运行时错误引起的崩溃](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_crashes_from_swift_runtime_errors)。一些较低级别的库，例如[Dispatch](https://developer.apple.com/documentation/dispatch)，在遇到不可恢复的错误时会捕获带有此异常的进程，并`Additional Diagnostic Information`在崩溃报告的部分中记录有关该错误的其他信息。有关这些消息的[信息](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report#3582416)，请参阅[诊断](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report#3582416)消息。

如果您想在自己的代码中使用相同的技术来解决不可恢复的错误，请调用该函数。这使系统可以生成带有线程回溯的崩溃报告，以显示您如何达到不可恢复的错误。`__builtin_trap()`

### EXC_CRASH（SIGABRT）

`EXC_CRASH (SIGABRT)`表示进程由于接收到`SIGABRT`信号而终止。通常，发送此信号是因为过程中的一个函数称为`abort()`，例如，当应用遇到未捕获的Objective-C或C ++语言异常时。[解决语言异常崩溃](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_language_exception_crashes)详细说明了如何处理未捕获的语言异常。

如果没有`Last Exception Backtrace`指示语言异常触发崩溃的提示，请查看崩溃线程的回溯以确定进程中的代码是否称为`abort()`。

当应用扩展程序花费太多时间初始化时，操作系统会向`SIGABRT`应用程序扩展进程发送。这些崩溃包括`Exception Subtype`带有值的字段。由于扩展程序没有功能，因此花在初始化上的任何时间都将在扩展程序和从属库中的静态构造函数和方法中发生。尽管看门狗终端中的异常信息有所不同，但请使用[解决看门狗终端中](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_watchdog_terminations)讨论的相同技术来研究异常信息。`LAUNCH_HANG``main`[`Apple的文档很清楚地说明了initialize和load的区别在于：load是只要类所在文件被引用就会被调用，而initialize是在类或者其子类的第一个方法被调用前调用。所以如果类没有被引用进项目，就不会有load调用；但即使类文件被引用进来，但是没有使用，那么initialize也不会被调用。  它们的相同点在于：方法只会被调用一次。（其实这是相对runtime来说的，后边会做进一步解释）。  文档也明确阐述了方法调用的顺序：父类(Superclass)的方法优先于子类(Subclass)的方法，类中的方法优先于类别(Category)中的方法。()`](https://developer.apple.com/documentation/objectivec/nsobject/1418815-load)`LAUNCH_HANG`

### EXC_CRASH（SIGKILL）

`EXC_CRASH (SIGKILL)`表示操作系统终止了该进程。崩溃报告包含一个`Termination Reason`带有代码的字段，该代码解释了崩溃的原因。在以下示例中，该代码为`0xdead10cc`：

```
Exception Type:  EXC_CRASH (SIGKILL)
Exception Codes: 0x0000000000000000, 0x0000000000000000
Exception Note:  EXC_CORPSE_NOTIFY
Termination Reason: Namespace RUNNINGBOARD, Code 0xdead10cc
```

该代码是以下值之一：

- `0x8badf00d`（发音为“吃不好的食物”）。操作系统的看门狗终止了该应用程序。请参阅[解决看门狗终止问题](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_watchdog_terminations)。
- `0xc00010ff`（发音为“冷静”）。操作系统由于热事件而终止了该应用程序。这可能是发生此崩溃的特定设备或其运行环境的问题。有关使您的应用程序更高效运行的提示，请观看[iOS的“性能和功耗优化与仪器](https://developer.apple.com/videos/play/wwdc2011/312/)WWDC”会话。
- `0xdead10cc`（发音为“死锁”）。操作系统终止了该应用程序，因为在暂停过程中该应用程序保持了文件锁或SQLite数据库锁。使用要求在主线程上额外的后台执行时间。在开始写入文件之前，请先提出此请求，以完成这些操作并在应用程序挂起之前放弃锁。在应用扩展中，用于管理此项工作。[`beginBackgroundTask(withName:expirationHandler:)`](https://developer.apple.com/documentation/uikit/uiapplication/1623051-beginbackgroundtask)[`beginActivity(options:reason:)`](https://developer.apple.com/documentation/foundation/processinfo/1415995-beginactivity)
- `0xbaadca11`（发音为“坏电话”）。操作系统因未能报告[PushKit](https://developer.apple.com/documentation/pushkit)通知而无法报告[CallKit](https://developer.apple.com/documentation/callkit)呼叫而终止了该应用程序。
- `0xbad22222`。操作系统由于恢复太频繁而终止了VoIP应用程序。
- `0xc51bad01`。watchOS终止了该应用程序，因为它在执行后台任务时占用了过多的CPU时间。优化执行后台任务的代码，以提高CPU效率，或者减少应用程序在后台运行时执行的工作量，以解决此崩溃问题。
- `0xc51bad02`。watchOS终止了该应用程序，因为它未能在分配的时间内完成后台任务。减少应用程序在后台运行时执行的工作量，以解决此崩溃问题。
- `0xc51bad03`。watchOS终止了该应用程序，因为它未能在分配的时间内完成后台任务，但是系统总体上非常繁忙，以至于该应用程序可能没有收到太多的CPU时间来执行后台任务。尽管您可以通过减少应用程序在后台任务中执行的工作量来避免该问题，`0xc51bad03`但这并不表示该应用程序做错了什么。该应用更有可能由于整体系统负载而无法完成其工作。



### EXC_CRASH（SIGQUIT）

`EXC_CRASH (SIGQUIT)`表示该进程在另一个进程的请求下终止，并具有管理其生存期的特权。`SIGQUIT`并不意味着该过程崩溃了，但是它可能以可检测的方式被错误地处理了。

使用iOS和iPadOS键盘扩展名，如果加载时间太长，则主机应用会终止键盘扩展名。尽管看门狗终端中的异常信息有所不同，但是请使用[解决看门狗终端中](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_watchdog_terminations)讨论的相同技术进行研究。`EXC_CRASH (SIGQUIT)`

### EXC_GUARD

```
EXC_GUARD`表示进程违反了受保护的资源保护。尽管受保护的系统资源有多种类型，但是大多数受保护的资源崩溃都来自受保护的文件描述符，该描述符在字段中具有值。操作系统将文件描述符标记为受保护，以便普通文件描述符API不能修改它们。例如，如果某个应用程序关闭了用于访问支持[Core Data](https://developer.apple.com/documentation/coredata)存储的SQLite文件的文件描述符，则Core Data可能会在以后很长一段时间内神秘地崩溃。保护文件描述可在发生这些问题时对其进行识别，从而使它们更易于识别和解决。`GUARD_TYPE_FD``Exception Subtype
```

该`Exception Message`字段包含特定的违规：

- `CLOSE`。个`e`过程试图调用`close()`在有人看守的文件描述符。
- `DUP`。Ť`he`过程试图调用`dup()`，`dup2()`或者`fcntl()`与或命令上的防护文件描述符。`F_DUPFD``F_DUPFD_CLOEXEC`
- `NOCLOEXEC`。个`e`过程试图删除从一个守卫文件描述符标志。`FD_CLOEXEC`
- `SOCKET_IPC`。该进程尝试通过套接字发送受保护的文件描述符。
- `FILEPORT`。T`he`进程试图获取受保护文件描述符的马赫发送权。
- `WRITE`。该进程尝试写入受保护的文件描述符。

该`Exception Message`字段还标识该进程尝试修改的特定受保护文件描述符。要了解触发此异常的上下文，请查阅崩溃线程的回溯。

### EXC_RESOURCE

`EXC_RESOURCE`是来自操作系统的通知，通知该进程超出了资源消耗限制。如果该`Exception Note`字段包含`NON-FATAL CONDITION`，则即使操作系统生成了崩溃报告，该过程也不会终止。该`Exception Message`字段描述在特定时间间隔内消耗的资源量。

崩溃报告在`Exception Subtype`字段中列出了特定资源：

- `CPU`和。进程中的线程在短时间内占用了过多的CPU。`CPU_FATAL`
- `MEMORY`。该过程超出了系统施加的内存限制。这可能是终止使用过多内存的先决条件。
- `IO`。该过程在短时间内导致过多的磁盘写入。
- `WAKEUPS`。进程中的线程每秒唤醒太多次，这会消耗电池寿命。线程到线程通信的API，如，或者，这导致在不知不觉叫的次数远远多于预期。由于触发此异常的通信频繁发生，因此通常会有多个后台线程具有非常相似的回溯，这些回溯表明了线程通信的起源。有关如何更有效地管理并发工作负载的信息，请参阅对[Grand Central Dispatch使用](https://developer.apple.com/videos/play/wwdc2017/706/)进行[现代化](https://developer.apple.com/videos/play/wwdc2017/706/)。[`perform(_:on:with:waitUntilDone:)`](https://developer.apple.com/documentation/objectivec/nsobject/1414476-perform)[`async(execute:)`](https://developer.apple.com/documentation/dispatch/dispatchqueue/2016103-async)[`dispatch_async(_:_:)`](https://developer.apple.com/documentation/dispatch/1453057-dispatch_async)
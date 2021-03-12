# 记录中

[Logging](https://developer.apple.com/documentation/os/logging)

使用统一日志记录系统从您的应用程序捕获遥测，以进行调试和性能分析。

---

## 总览

在您的应用中调试问题时，记录发生的事件的确切顺序以及有关这些事件的补充数据会很有帮助。日志消息提供了应用程序运行时行为的连续记录，并使其更容易识别使用其他技术无法轻松发现的问题。具体来说，您可能会使用日志消息：

- 无法将调试器附加到应用程序时，例如，在诊断用户计算机上的问题时。
- 当问题是间歇性的，并且很难在调试器中捕获时。
- 例如，当您想要大致了解应用程序的行为时，您想知道某些任务的开始和结束时间。

统一的日志记录系统提供了一个全面而高性能的API，以捕获整个系统所有级别的遥测。该系统集中了日志数据在内存和磁盘中的存储，而不是将数据写入基于文本的日志文件中。您可以使用控制台应用程序，`log`命令行工具或Xcode调试控制台查看日志消息。您还可以使用[OSLog](https://developer.apple.com/documentation/oslog)框架以编程方式访问日志消息。

重要

统一日志记录系统在iOS 10和更高版本，macOS 10.12和更高版本，tvOS 10.0和更高版本以及watchOS 3.0和更高版本中可用。该系统取代了Apple System Logger（ASL）和Syslog API。



## 主题

### 日志管理

[从您的代码生成日志消息](https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code)

记录有用的调试和分析信息，并在邮件中包含动态内容。

[查看日志消息](https://developer.apple.com/documentation/os/logging/viewing_log_messages)

使用各种工具来检索日志信息。

[在调试时自定义日志记录行为](https://developer.apple.com/documentation/os/logging/customizing_logging_behavior_while_debugging)

控制记录哪些日志事件。

[`struct Logger`](https://developer.apple.com/documentation/os/logger)

将插值字符串添加到统一日志记录系统的数据存储中的对象。

[`class OSLog`](https://developer.apple.com/documentation/os/oslog)

可以传递给日志记录功能的日志对象，以便将消息发送到日志记录系统。

[`struct OSLogType`](https://developer.apple.com/documentation/os/oslogtype)

系统支持的日志记录级别。

### 讯息建立

[`struct OSLogMessage`](https://developer.apple.com/documentation/os/oslogmessage)

系统添加到日志中的消息。

[`func os_log(OSLogType, log: OSLog, OSLogMessage)`](https://developer.apple.com/documentation/os/3580306-os_log)

使用可选的日志对象和日志级别添加新的日志消息。

[`func os_log(OSLogType, dso: UnsafeRawPointer, log: OSLog, StaticString, CVarArg)`](https://developer.apple.com/documentation/os/3019240-os_log)

将消息发送到日志记录系统，可以选择指定自定义日志对象，日志级别和任何消息格式参数。

[`func os_log(StaticString, dso: UnsafeRawPointer?, log: OSLog, type: OSLogType, CVarArg)`](https://developer.apple.com/documentation/os/2320718-os_log)

将消息发送到日志记录系统，可以选择指定自定义日志对象，日志级别和任何消息格式参数。

[`func os_log(OSLogMessage)`](https://developer.apple.com/documentation/os/3580305-os_log)

将新的日志消息添加到默认子系统。

### 值格式

[`struct OSLogStringAlignment`](https://developer.apple.com/documentation/os/oslogstringalignment)

插值字符串的对齐选项。

[`struct OSLogIntegerFormatting`](https://developer.apple.com/documentation/os/oslogintegerformatting)

整数值的格式选项。

[`struct OSLogFloatFormatting`](https://developer.apple.com/documentation/os/oslogfloatformatting)

双精度和浮点数的格式设置选项。

[`enum OSLogBoolFormat`](https://developer.apple.com/documentation/os/oslogboolformat)

布尔值的格式设置选项。

[`enum OSLogInt32ExtendedFormat`](https://developer.apple.com/documentation/os/oslogint32extendedformat)

用于将32位整数显示为特定值的选项。

[`enum OSLogPointerFormat`](https://developer.apple.com/documentation/os/oslogpointerformat)

指针数据的格式化选项。

[`struct OSLogPrivacy`](https://developer.apple.com/documentation/os/oslogprivacy)

隐私选项，确定何时编辑或显示日志消息中的值。

[`struct OSLogInterpolation`](https://developer.apple.com/documentation/os/osloginterpolation)

要包含在日志消息中的参数的表示形式。

### 活动追踪

[在活动中收集日志消息](https://developer.apple.com/documentation/os/logging/collecting_log_messages_in_activities)

查找与特定用户操作或应用程序事件相关的消息。

### 路标事件

捕获关键事件的开始和结束时间，并在Instruments和其他工具中提供该数据。

[记录性能数据](https://developer.apple.com/documentation/os/logging/recording_performance_data)

添加路标以记录有趣的基于时间的事件。

[`func os_signpost(OSSignpostType, dso: UnsafeRawPointer, log: OSLog, name: StaticString, signpostID: OSSignpostID)`](https://developer.apple.com/documentation/os/3019241-os_signpost)

将代码中的兴趣点记录为时间间隔或事件，以记录仪器中的性能。

[`func os_signpost(OSSignpostType, dso: UnsafeRawPointer, log: OSLog, name: StaticString, signpostID: OSSignpostID, StaticString, CVarArg)`](https://developer.apple.com/documentation/os/3019242-os_signpost)

在时间间隔或事件中记录代码中的兴趣点，以作为在Instruments中调试性能的事件，并包括一条详细消息。

[`func os_signpost(OSSignpostAnimationBegin, dso: UnsafeRawPointer, log: OSLog, name: StaticString, signpostID: OSSignpostID)`](https://developer.apple.com/documentation/os/3612096-os_signpost)

将动画的开始记录为代码中的关注点，而不会显示消息。

[`func os_signpost(OSSignpostAnimationBegin, dso: UnsafeRawPointer, log: OSLog, name: StaticString, signpostID: OSSignpostID, AnimationFormatString.OSLogMessage, CVarArg)`](https://developer.apple.com/documentation/os/3612097-os_signpost)

将动画的开始记录为代码中的关注点，并将指定的消息包括在日志中。

[`struct OSSignpostType`](https://developer.apple.com/documentation/os/ossignposttype)

不同种类路标的选项。

[`enum OSSignpostAnimationBegin`](https://developer.apple.com/documentation/os/ossignpostanimationbegin)

动画路标的选项。

[`struct OSSignpostID`](https://developer.apple.com/documentation/os/ossignpostid)

区分具有相同名称和目标日志的路标的标识符。

[`typealias os_signpost_id_t`](https://developer.apple.com/documentation/os/os_signpost_id_t)

用于区分名称和目标日志相同的路标的标识符。

[`enum AnimationFormatString`](https://developer.apple.com/documentation/os/animationformatstring)

特定于与动画相关的路标的实用程序的名称空间。
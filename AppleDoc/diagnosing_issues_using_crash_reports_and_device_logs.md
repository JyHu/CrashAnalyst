# 使用崩溃报告和设备日志诊断问题

[Diagnosing Issues Using Crash Reports and Device Logs](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs)

使用崩溃报告和设备日志来调试应用程序问题。

---

## 总览

客户期望应用程序稳定，没有错误并且可以有效地使用系统资源。操作系统通过收集可用于诊断应用程序中的问题的不同日志类型来帮助您满足这些期望：

- 崩溃报告描述了您的应用如何终止，并记录了崩溃时在每个线程上运行的代码。
- Jetsam事件报告描述了操作系统终止应用程序时的系统内存条件。
- 设备控制台日志包含有关操作系统和应用程序中发生的操作的详细信息。

应用程序的发行版本（例如针对App Store，企业环境或测试团队）需要您使用崩溃报告和设备日志来诊断客户遇到的问题。发行版本不包含在Xcode中进行调试所必需的权利。

### 使用崩溃报告解决稳定性问题

故障报告是诊断问题时最常用的日志类型。收到应用程序的崩溃报告时，请使用它们来了解应用程序存在的稳定性问题。崩溃报告描述了您的应用如何终止，还包含每个线程的完整回溯，显示了崩溃时正在运行的代码。

要使用崩溃报告调试问题，请执行以下操作：

1. [使用符号信息构建应用程序，](https://developer.apple.com/documentation/xcode/building_your_app_to_include_debugging_information#3403353)并在分发应用程序之前保留Xcode存档。
2. 检索崩溃报告中的问题。有关检索崩溃报告的不同方式，请参阅[获取崩溃报告和诊断日志](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/acquiring_crash_reports_and_diagnostic_logs)。
3. 将十六进制地址转换为应用程序的符号名称，如在[向崩溃报告](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/adding_identifiable_symbol_names_to_a_crash_report)中[添加可识别的符号名称中所述](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/adding_identifiable_symbol_names_to_a_crash_report)。
4. 确定崩溃是否符合“[确定常见崩溃原因”中的](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes)任何模式。有关对该问题的更多了解，请参阅[分析崩溃报告](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/analyzing_a_crash_report)并[检查](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report)[崩溃报告中](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/analyzing_a_crash_report)[的字段](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/examining_the_fields_in_a_crash_report)。
5. 更新您的代码以解决此问题。
6. 使用[XCTest](https://developer.apple.com/documentation/xctest)框架添加测试，以确保以后不再发生此问题。

### 使用Jetsam事件报告发现内存不足

确保您的应用有效使用内存。当iOS，iPad OS，watchOS或tvOS上的应用程序低效地使用内存时，其他应用程序可将较少的内存留在后台使用。较低的可用内存限制了用户在应用程序之间切换的速度，因为应用程序无法从内存中恢复，并且必须首先完成完整的应用程序启动。

当操作系统内存不足的情况，并且需要的内存超过当前可用的内存时，设备的操作系统可以终止应用程序以回收他们正在使用的内存。jetsam事件报告描述了操作系统终止应用程序时的系统内存条件。有关如何理解jetsam[事件报告](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_high-memory_use_with_jetsam_event_reports)的信息，请参阅[在设备上找到崩溃报告和内存日志](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/acquiring_crash_reports_and_diagnostic_logs#3403791)以了解如何访问这些日志和[识别Jetsam事件报告](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_high-memory_use_with_jetsam_event_reports)对[高内存的使用](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_high-memory_use_with_jetsam_event_reports)。

Jetsam事件报告不包含应用程序中正在执行的线程的堆栈跟踪，但确实包含有关内存使用的其他系统信息。当您的应用程序由于内存压力而崩溃时，请参阅[收集有关内存使用的信息](https://developer.apple.com/documentation/xcode/improving_your_app_s_performance/reducing_your_app_s_memory_use/gathering_information_about_memory_use)以了解您的应用程序的内存使用模式，以及[响应于](https://developer.apple.com/documentation/xcode/improving_your_app_s_performance/reducing_your_app_s_memory_use/responding_to_low-memory_warnings)内存不足[警告](https://developer.apple.com/documentation/xcode/improving_your_app_s_performance/reducing_your_app_s_memory_use/responding_to_low-memory_warnings)以了解何时降低内存使用量。

### 使用设备控制台日志诊断问题

Apple设备在操作系统和单个应用程序中保持连续的内存中操作记录。发生问题后，可以查看这些日志。可以通过使用macOS上的“控制台”应用程序查看操作系统日志来诊断某些问题，例如安装应用程序时遇到的问题。有关[访问设备的控制台日志](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/acquiring_crash_reports_and_diagnostic_logs#3403790)的说明，请参阅[访问设备](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/acquiring_crash_reports_and_diagnostic_logs#3403790)控制台日志。

使用[Logging](https://developer.apple.com/documentation/os/logging)框架将应用程序的日志消息添加到操作系统的日志中。您提供的日志可以包含其他分组和标签信息，以帮助跟踪原始用户操作中的问题。此信息对于诊断复杂的交互非常有用，例如调试您的应用与其应用扩展之一之间的交互。

> **重要**
> 请勿在日志中包含对隐私敏感的信息。
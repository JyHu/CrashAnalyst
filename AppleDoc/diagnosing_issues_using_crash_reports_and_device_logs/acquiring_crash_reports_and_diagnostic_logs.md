# 获取故障报告和诊断日志

[Acquiring Crash Reports and Diagnostic Logs](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/acquiring_crash_reports_and_diagnostic_logs)

从App Store，TestFlight以及直接从设备收集崩溃报告和设备日志。

---

## 总览

将您的应用分发给客户之后，请学习通过收集崩溃报告和诊断日志来改进它的方法。如果客户报告您的应用程序存在问题，请使用Xcode中的崩溃管理器获取有关该问题的报告，如[报告如何创建中所述。](https://help.apple.com/xcode/mac/current/#/dev675635e70)如果Crashes组织者不包含您需要的诊断信息或您无法使用的诊断信息，则客户可以从其设备收集日志并直接与您共享以解决问题。收到崩溃报告后，可能需要向崩溃报告中添加可识别的符号信息-有关更多信息，请参阅[向](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/adding_identifiable_symbol_names_to_a_crash_report)崩溃报告中[添加可识别的符号名称](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/adding_identifiable_symbol_names_to_a_crash_report)。

对于不是崩溃的问题，请检查操作系统的控制台日志，以找到用于诊断问题根源的重要信息。

### 从TestFlight和App Store收集崩溃报告

TestFlight和App Store会为您提交的每个应用版本收集崩溃报告。如果在将构建提交到App Store时包含符号信息，则崩溃报告将自动包含可识别的符号信息。查看[构建应用程序以包括](https://developer.apple.com/documentation/xcode/building_your_app_to_include_debugging_information)建议设置的[调试信息](https://developer.apple.com/documentation/xcode/building_your_app_to_include_debugging_information)。

发送诊断和使用信息的客户的崩溃报告将在崩溃管理器中显示，如[与开发人员共享崩溃，能耗和指标数据中所述](https://help.apple.com/xcode/mac/current/#/deve2819c518)。无论共享诊断和使用数据的设备设置如何，您应用的TestFlight用户都会自动与您共享崩溃报告。如果“崩溃”组织器中没有崩溃报告，请参阅[如果](https://help.apple.com/xcode/mac/current/#/dev9a80ab71d)组织器中[没有崩溃，能耗或度量报告，则](https://help.apple.com/xcode/mac/current/#/dev9a80ab71d)可以从客户那里收集崩溃报告。

以下崩溃报告类型无法通过崩溃管理器使用，但可以通过其他方式使用。请参阅[将故障报告和设备日志传输到Mac](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/acquiring_crash_reports_and_diagnostic_logs#3403792)，[并在设备上找到故障报告和内存日志](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/acquiring_crash_reports_and_diagnostic_logs#3403791)。

- 看门狗事件，例如应用启动时间慢的事件
- 无效的代码签名崩溃
- 热事件，由于应用使用过多的CPU而导致设备过热
- 应用程序占用大量内存的Jetsam事件

### 将崩溃报告和设备日志传输到Mac

如果您有权访问在其应用程序崩溃的设备，则可以通过将设备连接到Mac来传输诊断日志。您可以使用Xcode中的“设备和模拟器”窗口查看这些日志，如“[关于设备和模拟器”窗口中所述](https://help.apple.com/xcode/mac/current/#/dev7b20475ba)。

如果客户报告崩溃，则可以将崩溃报告传输到Mac或Windows计算机。请参阅[在Mac或Windows计算机上查找设备崩溃和能量日志](https://help.apple.com/xcode/mac/current/#/dev0f3181c2c)。

### 在设备上找到崩溃报告和内存日志

如果客户报告了您的应用程序中的崩溃，而您在崩溃管理器中没有崩溃报告，则请客户通过其设备通过电子邮件向您发送崩溃报告。

> **注意**
> watchOS的崩溃报告在配对的iPhone上可用。

要查找并通过电子邮件发送iOS，iPadOS，watchOS和tvOS应用程序的崩溃报告，请执行以下操作：

1. 打开设备上“设置”的“分析和改进”部分。请参阅[与Apple共享分析，诊断和使用信息](https://support.apple.com/en-us/HT202100)。
2. 点击分析数据。
3. 找到您的应用程序的日志。日志名称以崩溃报告或高内存使用崩溃开头。`<AppBinaryName>_<DateTime>``JetsamEvent_<DateTime>`
4. 选择所需的日志。
5. 点击共享图标，然后选择邮件以将崩溃报告作为邮件附件发送。

要查找并通过电子邮件发送macOS和Mac Catalyst应用程序的崩溃报告：

1. 从Finder中的“应用程序”>“实用程序”打开控制台应用程序。
2. 选择*崩溃报告*。
3. 在列表中找到您的应用的崩溃报告。日志按应用程序的二进制名称列出。
4. 右键单击所需日志的文件名。
5. 选择在查找器中显示。
6. 将Finder中显示的文件拖到Mail，以将崩溃报告作为邮件附件发送。

### 调试时创建崩溃报告

如果在使用Xcode调试应用程序时遇到崩溃，调试器将拦截崩溃，以便您可以检查应用程序的状态。如果您想收集有关该问题的完整崩溃报告，请通过使用Xcode中的“调试”>“分离”菜单项或`detach`在调试控制台中发出命令来分离调试器。这样，应用程序即可完成崩溃，并让操作系统生成崩溃报告。有关如何收集崩溃报告文件的信息，请参阅[在设备上找到崩溃报告和内存日志](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/acquiring_crash_reports_and_diagnostic_logs#3403791)。

### 访问设备控制台日志

如果客户报告您应用中的问题不是崩溃，请查看设备的控制台日志以获取有关该问题的其他信息。

要访问设备的控制台日志：

1. 对于iOS，iPadOS和tvOS问题，请将设备连接到Mac。对于watchOS问题，请将日志记录配置文件安装到配对的iPhone，然后将iPhone连接到Mac。请参阅[配置文件和日志](https://developer.apple.com/bug-reporting/profiles-and-logs/?name=sysdiagnose&platform=watchos)以下载配置文件。对于macOS问题，请继续执行下一步。
2. 在Mac上，从Finder中的“应用程序”>“实用程序”打开“控制台”应用程序。
3. 在控制台侧栏中选择设备。
4. 重现问题，并记下确切的时间。
5. 从再现该问题的时间开始查找与该问题有关的日志。
6. 使用日志中的信息作为线索，以进一步指导您对该问题进行调查。
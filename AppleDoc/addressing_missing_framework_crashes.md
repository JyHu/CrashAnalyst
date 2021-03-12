# 解决缺少的框架崩溃

[Addressing Missing Framework Crashes](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_missing_framework_crashes)

从崩溃报告中识别缺少的框架，并调整应用程序的构建以正确包含框架。

---

## 总览

如果您将应用程序的功能模块化到框架中，则该应用程序必须在构建时将框架链接起来，并且还必须在构建过程中将框架的副本嵌入到应用程序包中。如果某个应用程序链接了框架但未嵌入框架，则该应用程序在启动时会崩溃，因为动态链接器无法找到丢失的框架。

### 确定缺失的框架

动态链接器在崩溃报告的`dyld`输出中输出有关无法找到的框架的详细信息`Termination Description`：

```
Exception Type: EXC_CRASH (SIGABRT)
Exception Codes: 0x0000000000000000, 0x0000000000000000
Exception Note: EXC_CORPSE_NOTIFY
Termination Description: DYLD, 
    dependent dylib '@rpath/MyFramework.framework/MyFramework' not found for '<path>/MyCoolApp.app/MyCoolApp',
    tried but didn't find: 
    '/usr/lib/swift/MyFramework.framework/MyFramework' 
    '<path>/MyCoolApp.app/Frameworks/MyFramework.framework/MyFramework' 
    '@rpath/MyFramework.framework/MyFramework' 
    '/System/Library/Frameworks/MyFramework.framework/MyFramework'
```

确切的消息取决于操作系统和操作系统版本。这是一个不同的示例：

```
Exception Type: EXC_CRASH (SIGABRT)
Exception Codes: 0x0000000000000000, 0x0000000000000000
Exception Note: EXC_CORPSE_NOTIFY
Termination Description: DYLD, Library not loaded: @rpath/MyFramework.framework/MyFramework 
    | Referenced from: <path>/MyCoolApp.app/MyCoolApp 
    | Reason: image not found
```

> **注意**
> 为了提高可读性，此示例中有额外的换行符。在这些示例的原始崩溃报告文件中，`dyld`信息显示在较少的行上。

### 检查框架的配置

确保将框架正确地嵌入到应用程序包中—请参阅[在应用程序中嵌入框架](https://developer.apple.com/library/archive/technotes/tn2435/_index.html#//apple_ref/doc/uid/DTS40017543)。

如果您无法重现崩溃，请按照[“选择分配方法和选项”中的说明](https://developer.apple.com/documentation/xcode/distributing_your_app_for_beta_testing_and_releases#3405658)存档应用程序，将其导出以进行开发分发，然后应用应用程序精简。测试通过应用程序精简生成的不同变体，以查看仅在应用程序精简之后框架是否缺失。如果这重现崩溃，请执行以下操作：

- 确认架构的架构设置（`ARCHS`）为默认值。
- 确认框架的有效设置（）的构建设置为默认值。`VALID_ARCHS`
- 验证框架文件中的密钥正确指定了框架支持的CPU体系结构。[`UIRequiredDeviceCapabilities`](https://developer.apple.com/documentation/bundleresources/information_property_list/uirequireddevicecapabilities)`Info.plist`

> **注意**
> 如果缺少的框架来自第三方框架供应商或使用第三方开发工具将其集成到您的应用程序中，请与供应商联系以寻求帮助以解决问题。
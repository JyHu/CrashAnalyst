# 构建您的应用程序以包含调试信息

[Building Your App to Include Debugging Information](https://developer.apple.com/documentation/xcode/building_your_app_to_include_debugging_information)

配置Xcode以生成用于调试和崩溃报告的符号信息。

---

## 总览

当Xcode将您的源代码编译成机器代码时，它会在您的应用程序中生成一个符号列表-类名，全局变量以及方法和函数名。这些符号与定义它们的文件和行号相对应。这种关联会创建一个*调试符号*，因此您可以在Xcode中使用调试器，也可以引用崩溃报告所报告的行号。应用程序的调试版本默认情况下将调试符号放置在已编译的二进制文件中，而应用程序的发布版本将调试符号放置在配套的*调试符号文件*（）中以减小分布式应用程序的大小。`dSYM`

应用程序中的每个二进制文件（主要的应用程序可执行文件，框架和应用程序扩展名）都有自己的文件。编译的二进制文件及其伴随文件由生成的UUID绑在一起，该UUID既由生成的二进制文件又由文件记录。如果您从相同的源代码构建两个二进制文件，但使用不同的Xcode版本或构建设置，则两个二进制文件的构建UUID将不匹配。二进制文件和文件仅在具有相同的构建UUID时才相互兼容。保留要分发的特定内部版本的文件，并在从崩溃报告诊断问题时使用它们。`dSYM``dSYM``dSYM``dSYM``dSYM`

### 使用符号信息构建您的应用

在构建用于分发的应用程序之前，请[验证您的构建设置是否](https://help.apple.com/xcode/mac/current/#/dev34b59f90c)生成了必要的文件，以便您可以在发布应用程序后诊断崩溃。`dSYM`

这些文件是符号文件的最常见类型，在发布应用程序后对其进行调试。将带有位码的构建提交到App Store的应用具有第二种类型的符号文件，*即位码符号映射*（）。使用位码归档应用程序时，Xcode会将应用程序的dSYM文件中的符号替换为混淆的符号（例如），以保护符号名称的私密性。该文件将文件中这些隐藏的符号名称转换回原始调试符号名称，您可以将其与代码匹配。如果您选择在不提供符号的情况下将应用上传到App Store，则Xcode会排除`dSYM``bcsymbolmap``_hidden#109_``bcsymbolmap``dSYM``bcsymbolmap`文件中的文件，仅将混淆的符号名称发送到App Store。您应用的真实符号名称仍在Mac本地。

注意

位代码不适用于macOS和Mac Catalyst应用。

### 使用符号信息发布您的应用

当[归档您的应用程序](https://help.apple.com/xcode/mac/current/#/devf37a1db04)分发时，Xcode将收集所有二进制文件和您的应用程序并将其存储在Xcode的存档内的文件。`dSYM`

如果您通过App Store分发应用程序或使用TestFlight进行Beta测试，则可以在[将应用程序上载到App Store Connect](https://help.apple.com/xcode/mac/current/#/dev442d7f2ca)时选择[包含符号文件](https://help.apple.com/xcode/mac/current/#/devde46df08a)。您需要在构建中上载符号，以便App Store可以将应用的符号名称添加到崩溃报告中，然后再将其交付给Xcode中的[Crashes组织者](https://help.apple.com/xcode/mac/current/#/dev861f46ea8)。如果您没有在上载到App Store的过程中包含符号，则仍会通过Crashes组织者收到崩溃报告，但没有符号名称。如果Mac上提供了正确的文件，则Xcode会将符号名称添加到这些崩溃报告中。请参阅[使用故障报告和设备日志诊断问题，](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs)以了解如何[使用故障报告和设备日志](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs)`dSYM``dSYM` 文件。

> **重要**
> 您必须为您分发的每个应用程序版本保留Xcode存档。没有该存档，您可能无法从崩溃报告中诊断问题。
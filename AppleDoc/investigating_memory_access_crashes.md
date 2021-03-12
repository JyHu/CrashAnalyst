# 调查内存访问崩溃

[Investigating Memory Access Crashes](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes)

确定由内存访问问题引起的崩溃，并调查崩溃的原因。

---

## 总览

当应用程序以意外方式使用内存时，会由于内存访问问题而导致崩溃。内存访问问题有许多原因，例如，将指针取消引用到无效的内存地址，写入只读存储器或跳转到无效地址处的指令。这些崩溃通常由崩溃报告中的或异常标识：`EXC_BAD_ACCESS (SIGSEGV)``EXC_BAD_ACCESS (SIGBUS)`

```
Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
Exception Subtype: KERN_INVALID_ADDRESS at 0x0000000000000000
```

在MacOS，坏存储器访问崩溃偶尔仅由信号识别，例如`SIGSEGV`，，或：`SEGV_MAPERR``SEGV_NOOP`

```
Exception Type: SIGSEGV
Exception Codes: SEGV_MAPERR at 0x41e0af0c5ab8
```

Xcode提供了多种工具，可以帮助您识别内存访问问题的根源。崩溃报告中每个部分的进一步分析可能会提供进一步的见解和线索，以帮助您诊断问题。

### 使用Xcode调查崩溃

一旦通过异常类型确定崩溃报告是针对内存访问问题的，请使用Xcode继续调查。Xcode包含一套调试工具，可用于在应用运行时识别内存访问问题。当您的测试在应用程序中执行尽可能多的代码分支时，这些工具最有效：

- `Address Sanitizer`
- `Undefined Behavior Sanitizer`
- `Thread Sanitizer`

如果您的应用程序包含Objectice-C，C或C ++中的代码，请运行静态分析器，并修复发现的所有问题。静态分析器在构建时会分析您的应用代码，并识别常见的编程错误，包括某些类型的内存管理问题。请参阅[分析代码中的潜在缺陷](https://help.apple.com/xcode/mac/current/#/devb7babe820)。

除了崩溃报告中的异常类型之外，崩溃报告的其他部分可能还包含其他提示，这些提示建议应用其他调试工具。例如，如果僵尸对象导致了崩溃，则崩溃报告中会显示明显的迹象。有关特定线索的信息，请参阅[检查中断线程的回溯以获取有关内存访问问题来源的](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes#3562205)线索。

对于难以诊断的内存访问崩溃，可以使用malloc调试功能（例如Guard Malloc）来提供帮助。有关这些工具的信息，请参阅[启用Malloc调试功能](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/ManagingMemory/Articles/MallocDebug.html#//apple_ref/doc/uid/20001884)。您可以通过Xcode方案编辑器启用这些工具，如[使用带有消毒剂，API检查和内存管理诊断程序运行应用程序](https://help.apple.com/xcode/mac/current/#/devcef23c572)所述。

### 检查异常子类型，以确定访问无效的原因

```
Exception Subtype`崩溃报告中的字段包含描述错误和错误访问的内存地址的值，例如：`kern_return_t
Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
Exception Subtype: KERN_INVALID_ADDRESS at 0x0000000000000000
```

在macOS上，该`Exception Codes`字段包含异常子类型：

```
Exception Type:        EXC_BAD_ACCESS (SIGBUS)
Exception Codes:       KERN_MEMORY_ERROR at 0x00000001098c1000
```

有几种异常子类型：

- `KERN_INVALID_ADDRESS`。崩溃的线程可以通过访问数据或取指令来访问未映射的内存。[确定引起问题的内存访问类型](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes#3562197)介绍了如何区分差异。
- `KERN_PROTECTION_FAILURE`。崩溃的线程试图使用受保护的有效内存地址。某些类型的受保护内存包括只读内存区域或不可执行的内存区域。有关如何区分受保护内存类型的[信息，](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes#3562203)请参见[使用VM区域信息在应用程序的地址空间中找到](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes#3562203)内存。
- `KERN_MEMORY_ERROR`。崩溃的线程试图访问当时无法返回数据的内存，例如内存映射文件不可用。
- `EXC_ARM_DA_ALIGN`。崩溃的线程试图访问未正确对齐的内存。此异常代码很少见，因为64位ARM CPU可处理未对齐的数据。但是，如果内存地址既未对齐又位于未映射的内存区域中，则可能会看到此异常子类型。您可能还有其他崩溃报告，其中显示了具有不同异常子类型的内存访问问题，这很可能是由相同的基础内存访问问题引起的。

在`arm64e`与加密签名CPU架构采用指针认证码来检测和对内存中的意外变化的指针后卫。由于可能的指针身份验证失败而导致的崩溃使用异常子类型并在末尾附加一条消息：`KERN_INVALID_ADDRESS`

```
Exception Type:  EXC_BAD_ACCESS (SIGBUS)
Exception Subtype: KERN_INVALID_ADDRESS at 0x00006f126c1a9aa0 -> 0x000000126c1a9aa0 (possible pointer authentication failure)
```

无效的内存访问（错误地设置了高位）可能看起来像指针身份验证失败，即使原因是由于应用程序中的内存损坏问题造成的。

有关[指针身份验证](https://developer.apple.com/documentation/security/preparing_your_app_to_work_with_pointer_authentication)的更多信息，请参见[准备应用程序以使用指针身份](https://developer.apple.com/documentation/security/preparing_your_app_to_work_with_pointer_authentication)验证。

### 使用VM区域信息在应用程序的地址空间中找到内存

`VM Region Info`崩溃报告的字段显示相对于应用程序地址空间的其他部分，您的应用程序错误地访问了特定内存的位置。考虑以下示例：

```
Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
Exception Subtype: KERN_INVALID_ADDRESS at 0x0000000000000000
VM Region Info: 0 is not in any region.  Bytes before following region: 4307009536
      REGION TYPE                      START - END             [ VSIZE] PRT/MAX SHRMOD  REGION DETAIL
      UNUSED SPACE AT START
--->  
      __TEXT                 0000000100b7c000-0000000100b84000 [   32K] r-x/r-x SM=COW  ...pp/MyGreatApp
```

在这里，取消引用未映射的内存会导致崩溃，位于`0x0000000000000000`。这是一个无效的地址，特别是一个`NULL`指针，因此异常子类型使用值来指示该地址。该字段显示此无效地址的位置为4,307,009,536字节，位于应用程序地址空间中的有效内存区域之前。`KERN_INVALID_ADDRESS``VM Region Info`

考虑以下示例：`KERN_PROTECTION_FAILURE`

```
Exception Type:  EXC_BAD_ACCESS (SIGBUS)
Exception Subtype: KERN_PROTECTION_FAILURE at 0x000000016c070a30
VM Region Info: 0x16c070a30 is in 0x16c070000-0x16c074000;  bytes after start: 2608  bytes before end: 13775
      REGION TYPE                      START - END             [ VSIZE] PRT/MAX SHRMOD  REGION DETAIL
      Stack                  000000016bfe8000-000000016c070000 [  544K] rw-/rwx SM=COW  thread 12
--->  STACK GUARD            000000016c070000-000000016c074000 [   16K] ---/rwx SM=NUL  ...for thread 11
      Stack                  000000016c074000-000000016c0fc000 [  544K] rw-/rwx SM=COW  thread 11
```

在此示例中，取消引用的内存地址为`0x000000016c070a30`，包含该内存地址的区域由箭头标识。该地址位于称为堆栈保护的特殊内存区域中，该区域是从另一个线程的堆栈中缓冲线程的堆栈的内存区域。该`PRT`列显示了内存区域的当前权限属性，其中`r`指示内存是可读的，`w`指示内存是可写的，并且`x`指示内存是可执行的。

由于堆栈保护区域没有权限，因此对该区域的所有内存访问均无效，并且崩溃报告将此内存访问标识为违反了内存保护属性。堆栈保护只是受保护内存的一个示例，还有其他类型的受保护内存区域，它们具有不同的保护属性组合。

有关该字段的更多信息，请参见[解释vmmap的输出](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/ManagingMemory/Articles/VMPages.html#//apple_ref/doc/uid/20001985-97652)`VM Region Info`。

### 检查损坏的线程的回溯以获取有关内存访问问题来源的线索

请查阅崩溃线程的回溯，以获取有关发生内存访问问题的线索。`NULL`在查看回溯并将其与源代码进行比较时，很容易识别某些类型的内存访问问题，例如取消引用指针。其他内存访问问题由崩溃线程的回溯路径顶部的堆栈框标识：

- 如果，，或位于回溯的顶部，则崩溃是由于僵尸对象引起的。请参阅[调查僵尸对象的崩溃](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_crashes_for_zombie_objects)。[`objc_msgSend`](https://developer.apple.com/documentation/objectivec/1456712-objc_msgsend)`objc_retain``objc_release`
- 如果位于backtrace的顶部，则操作系统终止了该进程，因为它试图在后台使用OpenGL ES进行渲染。要解决在回溯中带有此符号的崩溃，请将您的OpenGL ES代码迁移到Metal。请参阅将[OpenGL代码迁移到Metal](https://developer.apple.com/documentation/metal/migrating_opengl_code_to_metal)。`gpus_ReturnNotPermittedKillClient`

在其他情况下，回溯中不存在导致内存访问问题的原因。当内存位置被意外修改时，就会发生*内存损坏*。进行此修改后，当您尝试使用该内存位置时，应用程序的另一部分可能会崩溃。回溯显示代码访问已修改的内存，但未显示意外修改内存的代码。意外的修改可能是在崩溃之前很长时间进行的，因此问题的根源在回溯中不可见。如果您有大量崩溃报告，表明存在内存访问问题，但回溯不同，则可能存在内存损坏问题。“[使用Xcode调查崩溃](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/investigating_memory_access_crashes#3562199)”中的信息可帮助您识别内存损坏的根源。

### 确定引起问题的内存访问类型

内存访问问题分为两类：无效的内存提取和无效的指令提取。一个*无效的存储器取*当代码取消引用一个无效的指针发生。一个*无效指令取出*时的功能通过一个坏的函数指针跳到另一个函数，或者通过函数调用意外对象时发生。要确定哪种类型的内存访问问题导致崩溃，请关注*程序计数器*，该寄存器包含导致内存访问异常的指令的地址。在ARM CPU架构上，这是`pc`寄存器。在CPU架构上，这是寄存器。`x86_64``rip`

如果程序计数器寄存器与异常地址不同，则崩溃是由于无效的内存提取所致。例如，考虑以下有关CPU的macOS崩溃报告：`x86_64`

```
Exception Type:  SIGSEGV
Exception Codes: SEGV_MAPERR at 0x21474feae2c8
...
Thread 12 crashed with X86-64 Thread State:
   rip: 0x00007fff61f5739d    rbp: 0x00007000026c72c0    rsp: 0x00007000026c7248    rax: 0xe85e2965c85400b4 
   rbx: 0x00006000023ee2b0    rcx: 0x00007f9273022990    rdx: 0x00007000026c6d88    rdi: 0x00006000023ee2b0 
   rsi: 0x00007fff358aae0f     r8: 0x00000000000003ff     r9: 0x00006000023edbc0    r10: 0x000021474feae2b0 
   r11: 0x00007fff358aae0f    r12: 0x000060000237af10    r13: 0x00007fff61f57380    r14: 0x00006000023ee2b0 
   r15: 0x0000000000000006 rflags: 0x0000000000010202     cs: 0x000000000000002b     fs: 0x0000000000000000 
    gs: 0x0000000000000000 
```

程序计数器寄存器为`0x00007fff61f5739d`，与异常的地址不同`0x21474feae2c8`。该崩溃是由于无效的内存提取引起的。

如果程序计数器寄存器与异常地址相同，则崩溃是由于无效的指令提取引起的。例如，考虑以下有关`arm64`CPU的iOS崩溃报告：

```
Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
Exception Subtype: KERN_INVALID_ADDRESS at 0x0000000000000040
...
Thread 0 name:  Dispatch queue: com.apple.main-thread
Thread 0 Crashed:
0   ???                               0x0000000000000040 0 + 64
...
Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000000000002   x1: 0x0000000000000040   x2: 0x0000000000000001   x3: 0x000000016dcfe080
    x4: 0x0000000000000010   x5: 0x000000016dcfdc8f   x6: 0x000000016dcfdd80   x7: 0x0000000000000000
    x8: 0x000000010210d3c8   x9: 0x0000000000000000  x10: 0x0000000000000014  x11: 0x0000000102835948
   x12: 0x0000000000000014  x13: 0x0000000000000000  x14: 0x0000000000000001  x15: 0x0000000000000000
   x16: 0x000000010210c0b8  x17: 0x00000001021063b0  x18: 0x0000000000000000  x19: 0x0000000102402b80
   x20: 0x0000000102402b80  x21: 0x0000000204f6b000  x22: 0x00000001f6e6f984  x23: 0x0000000000000001
   x24: 0x0000000000000001  x25: 0x00000001fc47b690  x26: 0x0000000102304040  x27: 0x0000000204eea000
   x28: 0x00000001f6e78fae   fp: 0x000000016dcfdec0   lr: 0x00000001021063c4
    sp: 0x000000016dcfdec0   pc: 0x0000000000000040 cpsr: 0x40000000
   esr: 0x82000006 (Instruction Abort) Translation fault

Binary Images:
0x102100000 - 0x102107fff MyCoolApp arm64  <87760ecf8573392ca5795f0db63a44e2> /var/containers/Bundle/Application/686CA3F1-6CC5-4F84-8126-EE22D03BC161/MyCoolApp.app/MyCoolApp
```

在此示例中，程序计数器寄存器为`0x0000000000000040`，与Exception子类型中报告的地址匹配，指示此崩溃是由于错误的指令提取引起的。由于这是错误的指令获取，因此回溯中的帧0不包含正在运行的函数，如`???`和内存地址所示，而不是回溯中的符号名称。但是，链接寄存器`lr`包含正常情况下函数调用后代码将返回的位置。链接寄存器中的值使您可以将跳转的起点追溯到错误的指令指针。

> **注意**
> 该CPU架构存储在堆栈上返回地址，而不是在一个链接寄存器，所以无法跟踪就不好了函数指针的起源的CPU。`x86_64``x86_64`

链接寄存器包含`0x00000001021063c4`，这是应用程序进程中加载的二进制文件之一中的指令地址。崩溃报告的“二进制图像”部分显示此地址在二进制文件内部，因为该地址在该二进制文件列出的范围内。通过此信息，您可以将命令行工具与二进制文件一起使用，并标识位于以下位置的相应代码：`MyCoolApp``0x102100000-0x102107fff``atos``dSYM``0x00000001021063c4`

```
% atos -arch arm64 -o MyCoolApp.app.dSYM/Contents/Resources/DWARF/MyCoolApp -l 0x102100000 0x00000001021063c4-[ViewController loadData] (in MyCoolApp) (ViewController.m:38)
```

[用命令行符号化崩溃报告](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/adding_identifiable_symbol_names_to_a_crash_report#3403800)讨论了如何`atos`更详细地使用命令行工具。
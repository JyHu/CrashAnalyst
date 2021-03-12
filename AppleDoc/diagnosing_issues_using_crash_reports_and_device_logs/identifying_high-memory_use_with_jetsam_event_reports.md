# 通过Jetsam事件报告识别高内存使用

[Identifying High-Memory Use with Jetsam Event Reports](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_high-memory_use_with_jetsam_event_reports)

了解为什么可用内存不足时操作系统终止您的应用程序的原因。

---

## 总览

iOS，iPadOS，watchOS和tvOS拥有一个虚拟内存系统，当操作系统遇到*内存压力*（可用内存不足，并且系统无法满足所有正在运行的应用程序的需求）时，它依赖于所有释放内存的应用程序。在内存压力下，应用程序收到内存不足通知后会释放内存。如果所有正在运行的应用释放的总内存足以减轻内存压力，则您的应用将继续运行。但是，如果由于应用程序没有释放足够的内存而导致内存压力持续存在，则系统会通过终止应用程序以回收其内存来释放内存。这是一次*jetsam事件*，系统会创建一个jetsam事件报告，其中包含有关为何选择放弃某个应用程序的信息。

Jetsam事件报告与崩溃报告不同，因为它们包含设备上所有应用程序和系统进程的整体内存使用情况，它们为JSON格式，并且不包含应用程序中任何线程的回溯。如果系统在可见的情况下由于内存压力而放弃了您的应用程序，则看起来您的应用程序已崩溃。使用jetsam事件报告来确定您的应用在jetsam事件中的角色，即使您的应用没有被抛弃也是如此。

### 确定内存页面大小和最大的过程

jetsam事件报告记录了在抛弃应用程序之前每个进程使用了多少内存。虚拟内存系统按块（称为*内存页）*分配和管理内存，并且报告将内存使用情况列为已使用的内存页数。要将内存页面的数量转换为您的应用程序使用的内存字节，您需要知道*页面大小*，即一个内存页面中的字节数。

jetsam事件报告标题中的字段记录每个内存页面中的字节数。除了页面大小之外，jetsam报告的标题还描述了整个设备环境，例如操作系统版本和硬件模型。在此示例中，页面大小为16,384字节或16 KB。`pageSize`

```
"crashReporterKey" : "b9aa251a63bd9e743afbb906f43eb7ea5f206292",
"product" : "iPad8,2",
"incident" : "32B05E3C-CB45-40F8-BA66-5668779740E1",
"date" : "2019-10-10 23:30:39.48 -0700",
"build" : "iPhone OS 13.1.2 (17A860)",
"memoryStatus" : {
   "pageSize" : 16384,
},
"largestProcess" : "OneCoolApp",
```

> **注意**
> 此示例显示了根据jetsam事件报告诊断崩溃所需的标题字段。完整的标头信息包含的字段比本示例中显示的更多。

在检查标题时，请检查该字段-该字段使用系统上内存最大的页面来命名进程。如果定期抛弃除您之外的其他应用程序，并且您的应用程序是最大的过程，则应减少内存使用量，以更好地配合其他应用程序的内存需求。`largestProcess`

### 确定Jetsam原因

jetsam事件报告包含一个`processes`数组，该数组中的每个项目都描述了系统中的单个流程。搜索`reason`关键字以识别被抛弃的过程以及系统为什么要抛弃它。仅放弃的过程具有原因码。

> **重要**
> 如果您的应用程序崩溃了，但抛弃的过程不是您的应用程序，那么崩溃不是由于内存压力引起的。要诊断应用程序的问题，请参阅[获取崩溃报告和诊断日志](https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/acquiring_crash_reports_and_diagnostic_logs)以找到其崩溃报告。

此示例是`processes`数组中的一个流程条目：

```
{
    "uuid" : "a02fb850-9725-4051-817a-8a5dc0950872",
    "states" : [
      "frontmost"
    ],
    "lifetimeMax" : 92802,
    "purgeable" : 0,
    "coalition" : 68,
    "rpages" : 92802,
    "reason" : "per-process-limit",
    "name" : "MyCoolApp"
}
```

> **注意**
> 此示例显示了从jetsam事件报告诊断崩溃所需的过程域。报告中完整的过程信息包含的字段比本示例中显示的更多。

如果抛弃的过程是您的应用程序，则`reason`密钥的值说明导致jetsam事件的条件：

- `per-process-limit`：此过程超出了系统对所有应用程序施加的常驻内存限制。超过此限制将使该过程有资格终止。如果该进程是您应用程序中的应用程序扩展，请注意，扩展程序的每进程内存限制比前台应用程序低得多。在扩展点上使用具有较高基准内存成本的技术（例如[SpriteKit](https://developer.apple.com/documentation/spritekit)或）之前，请仔细考虑您的需求。替代解决方案可能更合适。例如，由创建的映像使用的内存比少，对于许多扩展点方案来说是更好的选择。[`MKMapView`](https://developer.apple.com/documentation/mapkit/mkmapview)[`MKMapSnapshotter`](https://developer.apple.com/documentation/mapkit/mkmapsnapshotter)`MKMapView`
- `vm-pageshortage`：系统遇到内存压力，需要释放当前前台应用程序的后台进程内存。
- `vnode-limit`：在整个系统中打开了太多文件。内核具有有限数量的*vnode*和支持打开文件的内存结构，这些文件几乎用尽了。为了避免在vnode即将用尽时终止最前端的应用程序，即使您的应用程序不是使用vnode过多的来源，系统也会在后台终止您的应用程序以释放vnode。
- `highwater`：系统守护程序超出了其预期的最大内存占用。
- `fc-thrashing`：进程破坏了系统文件缓存。当过于频繁地读取和写入内存映射文件的非顺序部分时，会发生这种情况。为避免终止最前端的应用程序，系统可能会在后台终止您的应用程序，以释放文件缓存中的空间，即使您的应用程序没有破坏文件缓存。
- `jettisoned`：系统由于其他原因放弃了该过程。

要确定您的应用程序正在使用的内存量，请将该`rpages`字段中报告的内存页面数乘以jetsam事件报告标题中该字段的页面大小值。结果是您的应用程序正在使用的内存量（以字节为单位）。例如，值为92,802乘以16,384字节的值的进程正在使用1,520,467,968字节（1.52 GB）的内存。`pageSize``rpages``pageSize`

`processes`阵列中的每个项目还具有以下键，这些键提供了用于诊断问题的其他信息。

- `uuid`：二进制文件的构建UUID。通过将此值与可用的dSYM文件（用于分发给客户的内部版本）进行比较，可以帮助您识别应用的版本。要了解有关构建UUID的更多信息，请参阅[构建应用程序以包含调试信息](https://developer.apple.com/documentation/xcode/building_your_app_to_include_debugging_information)。
- `states`：描述应用程序当前的内存使用状态，例如将内存用作`frontmost`应用程序，或者`suspended`不主动使用内存。
- `lifetimeMax`：在进程的生存期内分配的最大内存页数。
- `coalition`：如果您的应用程序进程是联盟的一部分，而该联盟涉及涉及代表您的应用程序工作的其他系统进程，请使用此信息来识别相关进程及其内存使用情况，因为您的应用程序可能会影响其他联盟进程的内存使用情况。
- `name`：进程名称。查看此名称是否与您的应用程序中的二进制文件匹配，还是属于另一个应用程序或系统进程。

### 更改应用程序的内存使用量

确认您的应用因高内存使用而崩溃后，请通过分析jetsam事件报告，请参阅[收集有关内存使用的信息](https://developer.apple.com/documentation/xcode/improving_your_app_s_performance/reducing_your_app_s_memory_use/gathering_information_about_memory_use)以了解您应用的内存使用模式，并进行[更改以减少内存使用](https://developer.apple.com/documentation/xcode/improving_your_app_s_performance/reducing_your_app_s_memory_use/making_changes_to_reduce_memory_use)以了解[降低内存使用](https://developer.apple.com/documentation/xcode/improving_your_app_s_performance/reducing_your_app_s_memory_use/making_changes_to_reduce_memory_use)的技术。

除了减少应用程序的内存使用量之外，请确保您接收到系统发送的内存不足警告，并根据这些警告采取行动以配合操作系统的需求并降低应用程序的内存使用量-请参阅[响应](https://developer.apple.com/documentation/xcode/improving_your_app_s_performance/reducing_your_app_s_memory_use/responding_to_low-memory_warnings)内存不足[警告](https://developer.apple.com/documentation/xcode/improving_your_app_s_performance/reducing_your_app_s_memory_use/responding_to_low-memory_warnings)系统会以特定方式通知您的应用。
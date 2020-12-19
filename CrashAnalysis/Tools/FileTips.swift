//
//  FileTips.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/19.
//

import Foundation

struct FileTips {
    
    /// 解析崩溃文件的提示
    static var fileTips: NSAttributedString? {
        let html =
"""
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
</head>
<body>
<br>
<h2>解析崩溃日志文件</h2>
<li>1、将崩溃日志原始文件copy到当前输入框内
<li>2、选择 dSYM 按钮，系统会自动筛选出对应的 dSYM 文件
<li>3、如果有有效的文件被选择，会在右边显示出对应的文件地址，如果没有，则会有选择文件的弹窗弹出，提示用户去选择dSYM文件或者归档文件
<li>4、有效的文件被找到后，Analysis按钮会置为可点击状态
<li>5、点击Analysis按钮，系统会自动的解析崩溃日志文件内容

<br><br>

<h2>其他说明</h2>

<li>1、启动app后，系统会自动遍历Xcode在本地的所有归档文件，从中获取对应的dSYM文件
<li>2、command+shift+R 重新刷新本地的dSYM文件
<li>3、解析成功后，被成功解析的结果会在崩溃地址后以红色内容显示
<li>4、底部窗口会显示操作日志

<br><br>

<h2>示例：</h2>

<pre style="color:#708090">
Process:               Tiger Trade [54126]
Path:                  /Applications/Tiger Trade.app/Contents/MacOS/Tiger Trade
Identifier:            com.itiger.TigerTrade-Mac
Version:               6.5.0 (B7905C)
Code Type:             X86-64 (Native)
Parent Process:        ??? [1]
Responsible:           Tiger Trade [54126]
User ID:               501

Date/Time:             2020-12-17 20:08:39.120 +0800
OS Version:            Mac OS X 10.14.6 (18G103)
Report Version:        12
Bridge OS Version:     4.4 (17P4281)
Anonymous UUID:        6777CB29-0CD4-22D4-028F-3A95B8205ED5

Sleep/Wake UUID:       3EC3AE89-5218-4959-A907-CE294094D164

Time Awake Since Boot: 80000 seconds
Time Since Wake:       3100 seconds

System Integrity Protection: enabled

Crashed Thread:        16  Dispatch queue: com.apple.CFNetwork.addPersistCacheToStorageDaemon

Exception Type:        EXC_BAD_INSTRUCTION (SIGILL)
Exception Codes:       0x0000000000000001, 0x0000000000000000
Exception Note:        EXC_CORPSE_NOTIFY

Termination Signal:    Illegal instruction: 4
Termination Reason:    Namespace SIGNAL, Code 0x4
Terminating Process:   exc handler [54126]

Application Specific Information:
Detected over-release of a CFTypeRef

Thread 0:: Dispatch queue: com.apple.main-thread
0   com.apple.Foundation              0x00007fff316d1b36 -[NSNumberFormatter _regenerateFormatter] + 0
1   com.apple.Foundation              0x00007fff316f9121 -[NSNumberFormatter zeroSymbol] + 221
2   com.apple.Foundation              0x00007fff316f8e94 -[NSNumberFormatter stringForObjectValue:] + 319
3   org.cocoapods.Number              0x00000001034f0fa2 __62-[NSDecimalNumber(AUUNumberHandler) numberStringWithFormatter]_block_invoke + 32
4   org.cocoapods.Number              0x00000001034f0ef8 __53-[NSDecimalNumber(AUUNumberHandler) numberStringWith]_block_invoke + 155
5   org.cocoapods.Number              0x00000001034f0d3d __67-[NSDecimalNumber(AUUNumberHandler) numberStringWithFractionDigits]_block_invoke + 49
6   com.itiger.TigerTrade-Mac         0x0000000102b32174 0x102a41000 + 987508
7   com.itiger.TigerTrade-Mac         0x0000000102b31df4 0x102a41000 + 986612
8   com.itiger.TigerTrade-Mac         0x0000000102b31cc4 0x102a41000 + 986308
9   com.itiger.TigerTrade-Mac         0x0000000102e0dc5c 0x102a41000 + 3984476
10  com.itiger.TigerTrade-Mac         0x0000000102accbc1 0x102a41000 + 572353
11  com.itiger.TigerTrade-Mac         0x0000000102d82359 0x102a41000 + 3412825
12  com.itiger.TigerTrade-Mac         0x0000000102b2cae3 0x102a41000 + 965347
13  com.apple.CoreFoundation          0x00007fff2f45b76b -[__NSArrayM enumerateObjectsWithOptions:usingBlock:] + 219
14  com.itiger.TigerTrade-Mac         0x0000000102b2ca61 0x102a41000 + 965217
15  com.itiger.TigerTrade-Mac         0x0000000102b2acb8 0x102a41000 + 957624
16  com.itiger.TigerTrade-Mac         0x0000000102d34c31 0x102a41000 + 3095601
17  libdispatch.dylib                 0x00007fff5b3145f8 _dispatch_call_block_and_release + 12
18  libdispatch.dylib                 0x00007fff5b31563d _dispatch_client_callout + 8
19  libdispatch.dylib                 0x00007fff5b32068d _dispatch_main_queue_callback_4CF + 1135
20  com.apple.CoreFoundation          0x00007fff2f40da37 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__ + 9
21  com.apple.CoreFoundation          0x00007fff2f40d161 __CFRunLoopRun + 2289
22  com.apple.CoreFoundation          0x00007fff2f40c61e CFRunLoopRunSpecific + 455
23  com.apple.HIToolbox               0x00007fff2e66b1ab RunCurrentEventLoopInMode + 292
24  com.apple.HIToolbox               0x00007fff2e66aee5 ReceiveNextEventCommon + 603
25  com.apple.HIToolbox               0x00007fff2e66ac76 _BlockUntilNextEventMatchingListInModeWithFilter + 64
26  com.apple.AppKit                  0x00007fff2ca0377d _DPSNextEvent + 1135
27  com.apple.AppKit                  0x00007fff2ca0246b -[NSApplication(NSEvent) _nextEventMatchingEventMask:untilDate:inMode:dequeue:] + 1361
28  com.apple.AppKit                  0x00007fff2c9fc588 -[NSApplication run] + 699
29  com.apple.AppKit                  0x00007fff2c9ebac8 NSApplicationMain + 777
30  libdyld.dylib                     0x00007fff5b3623d5 start + 1

Thread 1:: com.apple.NSURLConnectionLoader
0   libsystem_kernel.dylib            0x00007fff5b49722a mach_msg_trap + 10
1   libsystem_kernel.dylib            0x00007fff5b49776c mach_msg + 60
2   com.apple.CoreFoundation          0x00007fff2f40d94e __CFRunLoopServiceMachPort + 328
3   com.apple.CoreFoundation          0x00007fff2f40cebc __CFRunLoopRun + 1612
4   com.apple.CoreFoundation          0x00007fff2f40c61e CFRunLoopRunSpecific + 455
5   com.apple.CFNetwork               0x00007fff2e2f2380 -[__CoreSchedulingSetRunnable runForever] + 210
6   com.apple.Foundation              0x00007fff31667112 __NSThread__start__ + 1194
7   libsystem_pthread.dylib           0x00007fff5b5562eb _pthread_body + 126
8   libsystem_pthread.dylib           0x00007fff5b559249 _pthread_start + 66
9   libsystem_pthread.dylib           0x00007fff5b55540d thread_start + 13

Thread 2:
0   libsystem_kernel.dylib            0x00007fff5b49af32 __semwait_signal + 10
1   libsystem_c.dylib                 0x00007fff5b426914 nanosleep + 199
2   libsystem_c.dylib                 0x00007fff5b426776 sleep + 41
3   org.cocoapods.Matrix              0x00000001033c0f5d monitorCachedData + 717
4   libsystem_pthread.dylib           0x00007fff5b5562eb _pthread_body + 126
5   libsystem_pthread.dylib           0x00007fff5b559249 _pthread_start + 66
6   libsystem_pthread.dylib           0x00007fff5b55540d thread_start + 13

Thread 3:: KSCrash Exception Handler (Secondary)
0   libobjc.A.dylib                   0x00007fff59b868df objc_msgSendSuper2 + 31
1   libdispatch.dylib                 0x00007fff5b315330 -[OS_dispatch_source _xref_dispose] + 55
2   com.apple.CoreFoundation          0x00007fff2f42bd04 __CFRunLoopModeDeallocate + 200
3   com.apple.CoreFoundation          0x00007fff2f50e55b _CFRelease + 236
4   com.apple.CoreFoundation          0x00007fff2f3e1363 __CFBasicHashDrain + 346
5   com.apple.CoreFoundation          0x00007fff2f50e55b _CFRelease + 236
6   com.apple.CoreFoundation          0x00007fff2f42b54c __CFRunLoopDeallocate + 308
7   com.apple.CoreFoundation          0x00007fff2f50e55b _CFRelease + 236
8   com.apple.CoreFoundation          0x00007fff2f421f14 __CFTSDFinalize + 108
9   libsystem_pthread.dylib           0x00007fff5b5566ab _pthread_tsd_cleanup + 551
10  libsystem_pthread.dylib           0x00007fff5b559655 _pthread_exit + 70
11  libsystem_pthread.dylib           0x00007fff5b5562f6 _pthread_body + 137
12  libsystem_pthread.dylib           0x00007fff5b559249 _pthread_start + 66
13  libsystem_pthread.dylib           0x00007fff5b55540d thread_start + 13

Thread 4:: com.apple.NSEventThread
0   libsystem_kernel.dylib            0x00007fff5b49722a mach_msg_trap + 10
1   libsystem_kernel.dylib            0x00007fff5b49776c mach_msg + 60
2   com.apple.CoreFoundation          0x00007fff2f40d94e __CFRunLoopServiceMachPort + 328
3   com.apple.CoreFoundation          0x00007fff2f40cebc __CFRunLoopRun + 1612
4   com.apple.CoreFoundation          0x00007fff2f40c61e CFRunLoopRunSpecific + 455
5   com.apple.AppKit                  0x00007fff2ca0b4a2 _NSEventThread + 175
6   libsystem_pthread.dylib           0x00007fff5b5562eb _pthread_body + 126
7   libsystem_pthread.dylib           0x00007fff5b559249 _pthread_start + 66
8   libsystem_pthread.dylib           0x00007fff5b55540d thread_start + 13

Thread 5:: JavaScriptCore bmalloc scavenger
0   libsystem_kernel.dylib            0x00007fff5b49a86a __psynch_cvwait + 10
1   libsystem_pthread.dylib           0x00007fff5b55956e _pthread_cond_wait + 722
2   libc++.1.dylib                    0x00007fff58594a0a std::__1::condition_variable::wait(std::__1::unique_lock<std::__1::mutex>&) + 18
3   com.apple.JavaScriptCore          0x00007fff328ecc42 void std::__1::condition_variable_any::wait<std::__1::unique_lock<bmalloc::Mutex> >(std::__1::unique_lock<bmalloc::Mutex>&) + 82
4   com.apple.JavaScriptCore          0x00007fff328f0d4b bmalloc::Scavenger::threadRunLoop() + 139
5   com.apple.JavaScriptCore          0x00007fff328f0579 bmalloc::Scavenger::threadEntryPoint(bmalloc::Scavenger*) + 9
6   com.apple.JavaScriptCore          0x00007fff328f1ee7 void* std::__1::__thread_proxy<std::__1::tuple<std::__1::unique_ptr<std::__1::__thread_struct, std::__1::default_delete<std::__1::__thread_struct> >, void (*)(bmalloc::Scavenger*), bmalloc::Scavenger*> >(void*) + 39
7   libsystem_pthread.dylib           0x00007fff5b5562eb _pthread_body + 126
8   libsystem_pthread.dylib           0x00007fff5b559249 _pthread_start + 66
9   libsystem_pthread.dylib           0x00007fff5b55540d thread_start + 13

Thread 6:: com.apple.coreanimation.render-server
0   libsystem_kernel.dylib            0x00007fff5b49722a mach_msg_trap + 10
1   libsystem_kernel.dylib            0x00007fff5b49776c mach_msg + 60
2   com.apple.QuartzCore              0x00007fff39ed7b5a CA::Render::Server::server_thread(void*) + 865
3   com.apple.QuartzCore              0x00007fff39ed77e6 thread_fun(void*) + 25
4   libsystem_pthread.dylib           0x00007fff5b5562eb _pthread_body + 126
5   libsystem_pthread.dylib           0x00007fff5b559249 _pthread_start + 66
6   libsystem_pthread.dylib           0x00007fff5b55540d thread_start + 13

Thread 7:: com.apple.CFStream.LegacyThread
0   libsystem_kernel.dylib            0x00007fff5b49722a mach_msg_trap + 10
1   libsystem_kernel.dylib            0x00007fff5b49776c mach_msg + 60
2   com.apple.CoreFoundation          0x00007fff2f40d94e __CFRunLoopServiceMachPort + 328
3   com.apple.CoreFoundation          0x00007fff2f40cebc __CFRunLoopRun + 1612
4   com.apple.CoreFoundation          0x00007fff2f40c61e CFRunLoopRunSpecific + 455
5   com.apple.CoreFoundation          0x00007fff2f4bb4da _legacyStreamRunLoop_workThread + 251
6   libsystem_pthread.dylib           0x00007fff5b5562eb _pthread_body + 126
7   libsystem_pthread.dylib           0x00007fff5b559249 _pthread_start + 66
8   libsystem_pthread.dylib           0x00007fff5b55540d thread_start + 13

Thread 8:: com.apple.CFSocket.private
0   libsystem_kernel.dylib            0x00007fff5b49e61a __select + 10
1   com.apple.CoreFoundation          0x00007fff2f43b2d2 __CFSocketManager + 635
2   libsystem_pthread.dylib           0x00007fff5b5562eb _pthread_body + 126
3   libsystem_pthread.dylib           0x00007fff5b559249 _pthread_start + 66
4   libsystem_pthread.dylib           0x00007fff5b55540d thread_start + 13

Thread 9:
0   libsystem_pthread.dylib           0x00007fff5b5553f0 start_wqthread + 0

Thread 10:
0   libsystem_pthread.dylib           0x00007fff5b5553f0 start_wqthread + 0

Thread 11:
0   libsystem_pthread.dylib           0x00007fff5b5553f0 start_wqthread + 0

Thread 12:
0   libsystem_pthread.dylib           0x00007fff5b5553f0 start_wqthread + 0

Thread 13:
0   libsystem_pthread.dylib           0x00007fff5b5553f0 start_wqthread + 0

Thread 14:
0   libsystem_pthread.dylib           0x00007fff5b5553f0 start_wqthread + 0

Thread 15:
0   libsystem_pthread.dylib           0x00007fff5b5553f0 start_wqthread + 0

Thread 16 Crashed:: Dispatch queue: com.apple.CFNetwork.addPersistCacheToStorageDaemon
0   com.apple.CoreFoundation          0x00007fff2f50e89e _CFRelease + 1071
1   com.apple.CFNetwork               0x00007fff2e2ac37a URLResponse::getMIMEType() + 76
2   com.apple.CFNetwork               0x00007fff2e2abbf9 URLResponse::createArchiveList(__CFAllocator const*, long*, void const***, long*) + 557
3   com.apple.CFNetwork               0x00007fff2e346f3f URLResponse::copyPropertyList(__CFAllocator const*) + 61
4   com.apple.CFNetwork               0x00007fff2e3e24cb invocation function for block in __CFURLCache::CreateAndStoreCacheNode(__CFURLCacheNode*, _CFCachedURLResponse const*, __CFString const*, _CFURLRequest const*, void const*, bool, bool&) + 890
5   libdispatch.dylib                 0x00007fff5b3145f8 _dispatch_call_block_and_release + 12
6   libdispatch.dylib                 0x00007fff5b31563d _dispatch_client_callout + 8
7   libdispatch.dylib                 0x00007fff5b31b8e0 _dispatch_lane_serial_drain + 602
8   libdispatch.dylib                 0x00007fff5b31c396 _dispatch_lane_invoke + 385
9   libdispatch.dylib                 0x00007fff5b3246ed _dispatch_workloop_worker_thread + 598
10  libsystem_pthread.dylib           0x00007fff5b555611 _pthread_wqthread + 421
11  libsystem_pthread.dylib           0x00007fff5b5553fd start_wqthread + 13

Thread 16 crashed with X86 Thread State (64-bit):
  rax: 0x00007fff2f7558cd  rbx: 0x00000000006007ad  rcx: 0x00007fff8a6e7378  rdx: 0x00007fff59baaf18
  rdi: 0x00006000065b3630  rsi: 0x00fffffffffffffe  rbp: 0x000070000c597710  rsp: 0x000070000c5976d0
   r8: 0x00000000000001ff   r9: 0x00000000000007fb  r10: 0x0000000000002cc0  r11: 0x0000000000000020
  r12: 0x0000600007287268  r13: 0x000060000444fd90  r14: 0x0000600007287240  r15: 0x0000000000000000
  rip: 0x00007fff2f50e89e  rfl: 0x0000000000010203  cr2: 0x00007fff8a6f1848
  
Logical CPU:     5
Error Code:      0x00000000
Trap Number:     6


Binary Images:
       0x102a41000 -        0x102f88ff7 +com.itiger.TigerTrade-Mac (6.5.0 - B7905C) <17CC4304-7510-3350-98B3-AE8DCAB8FE14> /Applications/Tiger Trade.app/Contents/MacOS/Tiger Trade
       0x1031a2000 -        0x1031c5ff7 +com.alamofire.AFNetworking (4.0.1 - 1) <11BDCE1B-C94D-37A8-9926-97902A5FB889> /Applications/Tiger Trade.app/Contents/Frameworks/AFNetworking.framework/Versions/A/AFNetworking
       0x10320b000 -        0x103212ff3 +org.cocoapods.AttributedString (0.1.0 - 1) <9095885C-33E8-3940-94F9-79EBB1837D10> /Applications/Tiger Trade.app/Contents/Frameworks/AttributedString.framework/Versions/A/AttributedString
       0x103228000 -        0x103233ffb +org.cocoapods.Chameleon (0.1.0 - 1) <B36851F5-ECF5-3C3D-BD6B-4C7E69EDE15C> /Applications/Tiger Trade.app/Contents/Frameworks/Chameleon.framework/Versions/A/Chameleon
       0x103252000 -        0x103265fff +org.cocoapods.FMDB (2.7.5 - 1) <34592840-C098-33F9-B6AD-2DBC2193DA21> /Applications/Tiger Trade.app/Contents/Frameworks/FMDB.framework/Versions/A/FMDB
       0x10328e000 -        0x10329dff7 +org.cocoapods.Looper (0.1.0 - 1) <4A43777F-A726-347F-98F8-B13F49F17F79> /Applications/Tiger Trade.app/Contents/Frameworks/Looper.framework/Versions/A/Looper
       0x1032bb000 -        0x1032caff7 +org.cocoapods.MJExtension (3.2.2 - 1) <CCD75B15-D255-3CB1-8A63-5F9A22ACAB9E> /Applications/Tiger Trade.app/Contents/Frameworks/MJExtension.framework/Versions/A/MJExtension
       0x1032ed000 -        0x103318ffb +org.cocoapods.MQTTClient (0.15.2 - 1) <B75A409F-A92F-3FE4-903D-73E86BD56918> /Applications/Tiger Trade.app/Contents/Frameworks/MQTTClient.framework/Versions/A/MQTTClient
       0x103367000 -        0x10337afff +org.cocoapods.Masonry (1.1.0 - 1) <78BB80B2-42F1-3EDF-A614-78EC587CEECF> /Applications/Tiger Trade.app/Contents/Frameworks/Masonry.framework/Versions/A/Masonry
       0x10339e000 -        0x103425ffb +org.cocoapods.Matrix (0.6.1 - 1) <E1BD56A6-2AED-378A-93EF-B22537A950B6> /Applications/Tiger Trade.app/Contents/Frameworks/Matrix.framework/Versions/A/Matrix
       0x1034eb000 -        0x1034f2ff7 +org.cocoapods.Number (0.1.1 - 1) <501A4241-8A11-34CC-B95A-E07F1F1BD6AC> /Applications/Tiger Trade.app/Contents/Frameworks/Number.framework/Versions/A/Number
       0x10350e000 -        0x103515ff7 +org.cocoapods.Persistence (0.1.0 - 1) <93AF0248-52EF-3193-8279-6586C6925C95> /Applications/Tiger Trade.app/Contents/Frameworks/Persistence.framework/Versions/A/Persistence
       0x103526000 -        0x103561ff7 +org.cocoapods.ReactiveObjC (3.1.1 - 1) <94A30D0C-6392-358E-A857-83C8E3867DAF> /Applications/Tiger Trade.app/Contents/Frameworks/ReactiveObjC.framework/Versions/A/ReactiveObjC
       0x1035dd000 -        0x103624ff7 +org.cocoapods.SDWebImage (5.10.0 - 1) <44A3FDA6-FF7A-33ED-A60D-829EFD65D4E3> /Applications/Tiger Trade.app/Contents/Frameworks/SDWebImage.framework/Versions/A/SDWebImage
       0x1036c4000 -        0x1036e3fff +org.cocoapods.SSZipArchive (2.2.3 - 1) <12EC3507-5B53-3262-9805-72D839F29F77> /Applications/Tiger Trade.app/Contents/Frameworks/SSZipArchive.framework/Versions/A/SSZipArchive
       0x10370c000 -        0x103723ff7 +org.cocoapods.SensorsAnalyticsSDK (1.0.3 - 1) <89F5E0FB-5B4B-3FD3-98CA-FF1D043A9BA7> /Applications/Tiger Trade.app/Contents/Frameworks/SensorsAnalyticsSDK.framework/Versions/A/SensorsAnalyticsSDK
       0x10374d000 -        0x103760fff +org.cocoapods.SnapKit (5.0.1 - 1) <81A6CD59-400B-344A-8368-9BDE08CA0504> /Applications/Tiger Trade.app/Contents/Frameworks/SnapKit.framework/Versions/A/SnapKit
       0x1037b1000 -        0x1038b0fff +org.cocoapods.TBCharts (0.1.0 - 1) <0FDB9776-6AC9-3BC8-BEB9-1A642871C4B7> /Applications/Tiger Trade.app/Contents/Frameworks/TBCharts.framework/Versions/A/TBCharts
       0x103c12000 -        0x103c29ff7 +com.itiger.TBXBasic (1.0 - 1) <339CBDCE-8B31-32FF-BCD8-01E6815FE9B1> /Applications/Tiger Trade.app/Contents/Frameworks/TBXBasic.framework/Versions/A/TBXBasic
       0x105b2a000 -        0x105b2d047  libobjc-trampolines.dylib (756.2) <5795A048-3940-3801-90CE-33D1B1AF81F4> /usr/lib/libobjc-trampolines.dylib
       0x107b76000 -        0x107b8cfff  com.apple.security.csparser (3.0 - 58286.270.3.0.1) <215095F3-2B6A-3F8D-A8AB-5E29C3A861F6> /System/Library/Frameworks/Security.framework/PlugIns/csparser.bundle/Contents/MacOS/csparser
       0x10864e000 -        0x1086b870f  dyld (655.1.1) <DFC3C4AF-6F97-3B34-B18D-7DCB23F2A83A> /usr/lib/dyld
    0x7fff23af8000 -     0x7fff23b07ff7  libSimplifiedChineseConverter.dylib (73) <1D43794E-BEB8-359B-A27D-A8C623C925B1> /System/Library/CoreServices/Encodings/libSimplifiedChineseConverter.dylib
    0x7fff23b33000 -     0x7fff23e8cfff  com.apple.RawCamera.bundle (8.15.0 - 1031.4.4) <AB6E8A8F-0BFE-37EE-A135-44ABA4FCB559> /System/Library/CoreServices/RawCamera.bundle/Contents/MacOS/RawCamera
    0x7fff27ba1000 -     0x7fff28975ff7  com.apple.driver.AppleIntelKBLGraphicsGLDriver (12.10.12 - 12.1.0) <F966EA02-0252-3B4F-888B-C0FCCA888A76> /System/Library/Extensions/AppleIntelKBLGraphicsGLDriver.bundle/Contents/MacOS/AppleIntelKBLGraphicsGLDriver
    0x7fff28976000 -     0x7fff28ca8fff  com.apple.driver.AppleIntelKBLGraphicsMTLDriver (12.10.12 - 12.1.0) <F44A2087-008C-30CB-9E33-A94DFF197E68> /System/Library/Extensions/AppleIntelKBLGraphicsMTLDriver.bundle/Contents/MacOS/AppleIntelKBLGraphicsMTLDriver
    0x7fff2b40b000 -     0x7fff2b5e7ffb  com.apple.avfoundation (2.0 - 1550.4) <5854207B-6106-3DA4-80B6-36C42D042F26> /System/Library/Frameworks/AVFoundation.framework/Versions/A/AVFoundation
    0x7fff2b5e8000 -     0x7fff2b6adfff  com.apple.audio.AVFAudio (1.0 - ???) <D454A339-2FC6-3EF6-992F-D676046612DB> /System/Library/Frameworks/AVFoundation.framework/Versions/A/Frameworks/AVFAudio.framework/Versions/A/AVFAudio
    0x7fff2b7b5000 -     0x7fff2b7b5fff  com.apple.Accelerate (1.11 - Accelerate 1.11) <762942CB-CFC9-3A0C-9645-A56523A06426> /System/Library/Frameworks/Accelerate.framework/Versions/A/Accelerate
    0x7fff2b7b6000 -     0x7fff2b7ccff7  libCGInterfaces.dylib (506.22) <1B6C92D9-F4B8-37BA-9635-94C4A56098CE> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vImage.framework/Versions/A/Libraries/libCGInterfaces.dylib
    0x7fff2b7cd000 -     0x7fff2be66fef  com.apple.vImage (8.1 - ???) <53FA3611-894E-3158-A654-FBD2F70998FE> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vImage.framework/Versions/A/vImage
    0x7fff2be67000 -     0x7fff2c0e0ff3  libBLAS.dylib (1243.200.4) <417CA0FC-B6CB-3FB3-ACBC-8914E3F62D20> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
    0x7fff2c0e1000 -     0x7fff2c153ffb  libBNNS.dylib (38.250.1) <538D12A2-9B9D-3E22-9896-F90F6E69C06E> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBNNS.dylib
    0x7fff2c154000 -     0x7fff2c4fdff3  libLAPACK.dylib (1243.200.4) <92175DF4-863A-3780-909A-A3E5C410F2E9> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libLAPACK.dylib
    0x7fff2c4fe000 -     0x7fff2c513feb  libLinearAlgebra.dylib (1243.200.4) <CB671EE6-DEA1-391C-9B2B-AA09A46B4D7A> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libLinearAlgebra.dylib
    0x7fff2c514000 -     0x7fff2c519ff3  libQuadrature.dylib (3.200.2) <1BAE7E22-2862-379F-B334-A3756067730F> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libQuadrature.dylib
    0x7fff2c51a000 -     0x7fff2c596ff3  libSparse.dylib (79.200.5) <E78B33D3-672A-3C53-B512-D3DDB2E9AC8D> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libSparse.dylib
    0x7fff2c597000 -     0x7fff2c5aafe3  libSparseBLAS.dylib (1243.200.4) <E9243341-DB77-37C1-97C5-3DFA00DD70FA> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libSparseBLAS.dylib
    0x7fff2c5ab000 -     0x7fff2c792ff7  libvDSP.dylib (671.250.4) <7B110627-A9C1-3FB7-A077-0C7741BA25D8> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libvDSP.dylib
    0x7fff2c793000 -     0x7fff2c846ff7  libvMisc.dylib (671.250.4) <D5BA4812-BFFC-3CD0-B382-905CD8555DA6> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libvMisc.dylib
    0x7fff2c847000 -     0x7fff2c847fff  com.apple.Accelerate.vecLib (3.11 - vecLib 3.11) <74288115-EF61-30B6-843F-0593B31D4929> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/vecLib
    0x7fff2c848000 -     0x7fff2c8a2fff  com.apple.Accounts (113 - 113) <251A1CB1-F972-3F60-8662-85459EAD6318> /System/Library/Frameworks/Accounts.framework/Versions/A/Accounts
    0x7fff2c8a5000 -     0x7fff2c9e8fff  com.apple.AddressBook.framework (11.0 - 1894) <3FFCAE6B-4CD2-3B8D-AE27-0A3693C9470F> /System/Library/Frameworks/AddressBook.framework/Versions/A/AddressBook
    0x7fff2c9e9000 -     0x7fff2d79effb  com.apple.AppKit (6.9 - 1671.60.109) <EFB74848-E23F-3FC3-B167-BA1F960996CC> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
    0x7fff2d7f0000 -     0x7fff2d7f0fff  com.apple.ApplicationServices (50.1 - 50.1) <84097DEB-E2FC-3901-8DD7-A670EA2274E0> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices
    0x7fff2d7f1000 -     0x7fff2d85cfff  com.apple.ApplicationServices.ATS (377 - 453.11.2.2) <A258DA73-114B-3102-A056-4AAAD3CEB9DD> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/ATS
    0x7fff2d8f5000 -     0x7fff2da0cfff  libFontParser.dylib (228.6.2.3) <3602D55B-3B9E-3B3A-A814-08C1244A8AE4> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Resources/libFontParser.dylib
    0x7fff2da0d000 -     0x7fff2da4ffff  libFontRegistry.dylib (228.12.2.3) <2A56347B-2809-3407-A8B4-2AB88E484062> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Resources/libFontRegistry.dylib
    0x7fff2daa9000 -     0x7fff2dadbfff  libTrueTypeScaler.dylib (228.6.2.3) <7E4C5D9C-51AF-3EC1-8FA5-11CD4BEE477A> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Resources/libTrueTypeScaler.dylib
    0x7fff2db40000 -     0x7fff2db44ff3  com.apple.ColorSyncLegacy (4.13.0 - 1) <C0D9E23C-ABA0-39DE-A4EB-5A41C5499056> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ColorSyncLegacy.framework/Versions/A/ColorSyncLegacy
    0x7fff2dbdf000 -     0x7fff2dc31ff7  com.apple.HIServices (1.22 - 628) <2BE461FF-80B9-30D3-A574-AED5724B1C1B> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/HIServices.framework/Versions/A/HIServices
    0x7fff2dc32000 -     0x7fff2dc41fff  com.apple.LangAnalysis (1.7.0 - 1.7.0) <F5617A2A-FEA6-3832-B5BA-C2111B98786F> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/LangAnalysis.framework/Versions/A/LangAnalysis
    0x7fff2dc42000 -     0x7fff2dc8bff7  com.apple.print.framework.PrintCore (14.2 - 503.8) <57C2FE32-0E74-3079-B626-C2D52F2D2717> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/PrintCore
    0x7fff2dc8c000 -     0x7fff2dcc5ff7  com.apple.QD (3.12 - 407.2) <28C7D39F-59C9-3314-BECC-67045487229C> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/QD.framework/Versions/A/QD
    0x7fff2dcc6000 -     0x7fff2dcd2fff  com.apple.speech.synthesis.framework (8.1.3 - 8.1.3) <5E7B9BD4-122B-3012-A044-3259C97E7509> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/SpeechSynthesis.framework/Versions/A/SpeechSynthesis
    0x7fff2dcd3000 -     0x7fff2df4aff7  com.apple.audio.toolbox.AudioToolbox (1.14 - 1.14) <04F482F1-E1C1-3955-8A6C-8AA152AA06F3> /System/Library/Frameworks/AudioToolbox.framework/Versions/A/AudioToolbox
    0x7fff2df4c000 -     0x7fff2df4cfff  com.apple.audio.units.AudioUnit (1.14 - 1.14) <ABC54269-002D-310D-9654-46CF960F863E> /System/Library/Frameworks/AudioUnit.framework/Versions/A/AudioUnit
    0x7fff2e2a5000 -     0x7fff2e646fff  com.apple.CFNetwork (978.0.7 - 978.0.7) <B2133D0D-1399-3F17-80F0-313E3A241C89> /System/Library/Frameworks/CFNetwork.framework/Versions/A/CFNetwork
    0x7fff2e65b000 -     0x7fff2e65bfff  com.apple.Carbon (158 - 158) <56AD06AA-7BB4-3F0B-AEF7-9768D0BC1C98> /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon
    0x7fff2e65c000 -     0x7fff2e65fffb  com.apple.CommonPanels (1.2.6 - 98) <1CD6D56D-8EC7-3528-8CBC-FC69533519B5> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/CommonPanels.framework/Versions/A/CommonPanels
    0x7fff2e660000 -     0x7fff2e957fff  com.apple.HIToolbox (2.1.1 - 918.7) <13F69D4C-D19F-3E09-9231-1978D783A556> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/HIToolbox
    0x7fff2e958000 -     0x7fff2e95bff3  com.apple.help (1.3.8 - 66) <A08517EB-8958-36C9-AEE0-1A8FEEACBE3F> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Help.framework/Versions/A/Help
    0x7fff2e95c000 -     0x7fff2e961ff7  com.apple.ImageCapture (9.0 - 1534.2) <DB063E87-ED8F-3E4E-A7E2-A6B45FA73EF7> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/ImageCapture.framework/Versions/A/ImageCapture
    0x7fff2e962000 -     0x7fff2e9f7ff3  com.apple.ink.framework (10.9 - 225) <7C7E9483-2E91-3DD3-B1E0-C238F42CA0DD> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Ink.framework/Versions/A/Ink
    0x7fff2e9f8000 -     0x7fff2ea10ff7  com.apple.openscripting (1.7 - 179.1) <9B8C1ECC-5864-3E21-9149-863E884EA25C> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/OpenScripting.framework/Versions/A/OpenScripting
    0x7fff2ea30000 -     0x7fff2ea31ff7  com.apple.print.framework.Print (14.2 - 267.4) <A7A9D2A0-D4E0-35EF-A0F7-50521F707C33> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Print.framework/Versions/A/Print
    0x7fff2ea32000 -     0x7fff2ea34ff7  com.apple.securityhi (9.0 - 55006) <05717F77-7A7B-37E6-AB3E-03F063E9095B> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/SecurityHI.framework/Versions/A/SecurityHI
    0x7fff2ea35000 -     0x7fff2ea3bff7  com.apple.speech.recognition.framework (6.0.3 - 6.0.3) <3CC050FB-EBCB-3087-8EA5-F378C8F99217> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/SpeechRecognition.framework/Versions/A/SpeechRecognition
    0x7fff2ea3c000 -     0x7fff2eb5cfff  com.apple.cloudkit.CloudKit (736.232 - 736.232) <F643F4D4-7F23-32C3-84E1-7981BD45F64C> /System/Library/Frameworks/CloudKit.framework/Versions/A/CloudKit
    0x7fff2eb5d000 -     0x7fff2eb5dfff  com.apple.Cocoa (6.11 - 23) <C930D6CD-930B-3D1E-9F15-4AE6AFC13F26> /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa
    0x7fff2eb6b000 -     0x7fff2ecbaff7  com.apple.ColorSync (4.13.0 - 3345.6) <31648BB6-7239-3D0E-81B1-BCF51FEF557F> /System/Library/Frameworks/ColorSync.framework/Versions/A/ColorSync
    0x7fff2ecbb000 -     0x7fff2eda3ff7  com.apple.contacts (1.0 - 2901) <A6734AF0-D8E6-32C7-B283-DF1E7627F0D3> /System/Library/Frameworks/Contacts.framework/Versions/A/Contacts
    0x7fff2ee46000 -     0x7fff2eeccfff  com.apple.audio.CoreAudio (4.3.0 - 4.3.0) <1E8E64E6-0E58-375A-97F7-07CB4EE181AC> /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio
    0x7fff2ef30000 -     0x7fff2ef5affb  com.apple.CoreBluetooth (1.0 - 1) <A73F1709-DD18-3052-9F22-C0015278834B> /System/Library/Frameworks/CoreBluetooth.framework/Versions/A/CoreBluetooth
    0x7fff2ef5b000 -     0x7fff2f2e0fef  com.apple.CoreData (120 - 866.6) <132CB39B-8D58-30FA-B8AD-49BFFF34B293> /System/Library/Frameworks/CoreData.framework/Versions/A/CoreData
    0x7fff2f2e1000 -     0x7fff2f3d1ff7  com.apple.CoreDisplay (101.3 - 110.18) <0EB2A997-FCAD-3D17-B140-9829961E5327> /System/Library/Frameworks/CoreDisplay.framework/Versions/A/CoreDisplay
    0x7fff2f3d2000 -     0x7fff2f817ff7  com.apple.CoreFoundation (6.9 - 1575.22) <51040EEE-7C5D-3433-A271-86B47B0562BF> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
    0x7fff2f819000 -     0x7fff2fea8fff  com.apple.CoreGraphics (2.0 - 1265.9) <BC95B558-EF77-3A57-A0BC-11606C778991> /System/Library/Frameworks/CoreGraphics.framework/Versions/A/CoreGraphics
    0x7fff2feaa000 -     0x7fff301cafff  com.apple.CoreImage (14.4.0 - 750.0.140) <11026E39-D2FF-3CF6-8ACE-7BA293F9853E> /System/Library/Frameworks/CoreImage.framework/Versions/A/CoreImage
    0x7fff301cb000 -     0x7fff30243fff  com.apple.corelocation (2245.16.14) <0F59F59B-AC14-3116-83C5-CF7BC57D9EB1> /System/Library/Frameworks/CoreLocation.framework/Versions/A/CoreLocation
    0x7fff3029d000 -     0x7fff304c6fff  com.apple.CoreML (1.0 - 1) <9EC1FED2-BA47-307B-A326-43C4D05166E7> /System/Library/Frameworks/CoreML.framework/Versions/A/CoreML
    0x7fff304c7000 -     0x7fff305cbfff  com.apple.CoreMedia (1.0 - 2290.13) <A739B93D-23C2-3A34-8D61-6AC924B9634F> /System/Library/Frameworks/CoreMedia.framework/Versions/A/CoreMedia
    0x7fff305cc000 -     0x7fff30627fff  com.apple.CoreMediaIO (900.0 - 5050.1) <63944D63-D138-3774-BAB4-A95679469A43> /System/Library/Frameworks/CoreMediaIO.framework/Versions/A/CoreMediaIO
    0x7fff30628000 -     0x7fff30628fff  com.apple.CoreServices (946 - 946) <2EB6117A-6389-311B-95A0-7DE32C5FCFE2> /System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices
    0x7fff30629000 -     0x7fff306a5ff7  com.apple.AE (773 - 773) <55AE7C9E-27C3-30E9-A047-3B92A6FD53B4> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/AE.framework/Versions/A/AE
    0x7fff306a6000 -     0x7fff3097dfff  com.apple.CoreServices.CarbonCore (1178.33 - 1178.33) <CB87F0C7-2CD6-3983-8E32-B6A2EC925352> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/CarbonCore
    0x7fff3097e000 -     0x7fff309c6ff7  com.apple.DictionaryServices (1.2 - 284.16.4) <746EB200-DC51-30AE-9CBC-608A7B4CC8DA> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/DictionaryServices.framework/Versions/A/DictionaryServices
    0x7fff309c7000 -     0x7fff309cfffb  com.apple.CoreServices.FSEvents (1239.200.12 - 1239.200.12) <8406D379-8D33-3611-861B-7ABD26DB50D2> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/FSEvents.framework/Versions/A/FSEvents
    0x7fff309d0000 -     0x7fff30b81ff7  com.apple.LaunchServices (946 - 946) <A0C91634-9410-38E8-BC11-7A5A369E6BA5> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/LaunchServices
    0x7fff30b82000 -     0x7fff30c20ff7  com.apple.Metadata (10.7.0 - 1191.57) <BFFAED00-2560-318A-BB8F-4E7E5123EC61> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework/Versions/A/Metadata
    0x7fff30c21000 -     0x7fff30c6bff7  com.apple.CoreServices.OSServices (946 - 946) <20C4EEF8-D5AC-39A0-9B4A-78F88E3EFBCC> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/OSServices.framework/Versions/A/OSServices
    0x7fff30c6c000 -     0x7fff30cd3ff7  com.apple.SearchKit (1.4.0 - 1.4.0) <DA08AA6F-A6F1-36C0-87F4-E26294E51A3A> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/SearchKit.framework/Versions/A/SearchKit
    0x7fff30cd4000 -     0x7fff30cf5ff3  com.apple.coreservices.SharedFileList (71.28 - 71.28) <487A8464-729E-305A-B5D1-E3FE8EB9CFC5> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/SharedFileList.framework/Versions/A/SharedFileList
    0x7fff31000000 -     0x7fff31162ff3  com.apple.CoreText (352.0 - 584.26.3.2) <59919B0C-CBD5-3877-8D6F-D6048F1E5F42> /System/Library/Frameworks/CoreText.framework/Versions/A/CoreText
    0x7fff31163000 -     0x7fff311a3ff3  com.apple.CoreVideo (1.8 - 281.4) <10CF8E52-07E3-382B-8091-2CEEEFFA69B4> /System/Library/Frameworks/CoreVideo.framework/Versions/A/CoreVideo
    0x7fff311a4000 -     0x7fff31233fff  com.apple.framework.CoreWLAN (13.0 - 1375.2) <BF4B29F7-FBC8-3299-98E8-C3F8C04B7C92> /System/Library/Frameworks/CoreWLAN.framework/Versions/A/CoreWLAN
    0x7fff313aa000 -     0x7fff313b5ffb  com.apple.DirectoryService.Framework (10.14 - 207.200.4) <49B086F4-AFA2-3ABB-8D2E-CE253044C1C0> /System/Library/Frameworks/DirectoryService.framework/Versions/A/DirectoryService
    0x7fff313b6000 -     0x7fff31464fff  com.apple.DiscRecording (9.0.3 - 9030.4.5) <D7A28B57-C025-3D44-BB17-82243B7B91BC> /System/Library/Frameworks/DiscRecording.framework/Versions/A/DiscRecording
    0x7fff3148a000 -     0x7fff3148fffb  com.apple.DiskArbitration (2.7 - 2.7) <F481F2C0-884E-3265-8111-ABBEC93F0920> /System/Library/Frameworks/DiskArbitration.framework/Versions/A/DiskArbitration
    0x7fff31655000 -     0x7fff31a02ffb  com.apple.Foundation (6.9 - 1575.22) <CDB9A3E1-41A5-36EC-A24E-94FBCC752D6A> /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
    0x7fff31a71000 -     0x7fff31aa0ffb  com.apple.GSS (4.0 - 2.0) <E2B90D08-3857-3155-9FCC-07D778988EC9> /System/Library/Frameworks/GSS.framework/Versions/A/GSS
    0x7fff31ba0000 -     0x7fff31caafff  com.apple.Bluetooth (6.0.14 - 6.0.14d3) <C2D1A774-2390-363D-8215-BF51FFCB6CCA> /System/Library/Frameworks/IOBluetooth.framework/Versions/A/IOBluetooth
    0x7fff31d0d000 -     0x7fff31d9cfff  com.apple.framework.IOKit (2.0.2 - 1483.260.4) <8A90F547-86EF-3DFB-92FE-0E2C0376DD84> /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit
    0x7fff31d9e000 -     0x7fff31dadffb  com.apple.IOSurface (255.6.1 - 255.6.1) <85F85EBB-EA59-3A8B-B3EB-7C20F3CC77AE> /System/Library/Frameworks/IOSurface.framework/Versions/A/IOSurface
    0x7fff31dae000 -     0x7fff31e00ff3  com.apple.ImageCaptureCore (1.0 - 1534.2) <27942C51-8108-3ED9-B37E-7C365A31EC2D> /System/Library/Frameworks/ImageCaptureCore.framework/Versions/A/ImageCaptureCore
    0x7fff31e01000 -     0x7fff31f8cfef  com.apple.ImageIO.framework (3.3.0 - 1850.2) <75E46A31-D87D-35CE-86A4-96A50971FDB2> /System/Library/Frameworks/ImageIO.framework/Versions/A/ImageIO
    0x7fff31f8d000 -     0x7fff31f91ffb  libGIF.dylib (1850.2) <4774EBDF-583B-3DDD-A0E1-9F427CB6A074> /System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/libGIF.dylib
    0x7fff31f92000 -     0x7fff3206efef  libJP2.dylib (1850.2) <697BB77F-A682-339F-8659-35432962432D> /System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/libJP2.dylib
    0x7fff3206f000 -     0x7fff32094feb  libJPEG.dylib (1850.2) <171A8AC4-AADA-376F-9F2C-B9C978DB1007> /System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/libJPEG.dylib
    0x7fff32357000 -     0x7fff3237dfeb  libPng.dylib (1850.2) <FBCEE909-F573-3AD6-A45F-AF32612BF8A2> /System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/libPng.dylib
    0x7fff3237e000 -     0x7fff32380ffb  libRadiance.dylib (1850.2) <56907025-D5CE-3A9E-ACCB-A376C2599853> /System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/libRadiance.dylib
    0x7fff32381000 -     0x7fff323cefe7  libTIFF.dylib (1850.2) <F59557C9-C761-3E6F-85D1-0FBFFD53ED5C> /System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/libTIFF.dylib
    0x7fff326c9000 -     0x7fff33529fff  com.apple.JavaScriptCore (14607 - 14607.3.9) <9B7D9E8B-619D-34A1-8FA9-E23C0EA3CD02> /System/Library/Frameworks/JavaScriptCore.framework/Versions/A/JavaScriptCore
    0x7fff33541000 -     0x7fff3355afff  com.apple.Kerberos (3.0 - 1) <DB1E0679-37E1-3B93-9789-32F63D660C3B> /System/Library/Frameworks/Kerberos.framework/Versions/A/Kerberos
    0x7fff3355b000 -     0x7fff33590ff3  com.apple.LDAPFramework (2.4.28 - 194.5) <95DAD9EE-9B6F-3FF5-A5EF-F6672AD3CC55> /System/Library/Frameworks/LDAP.framework/Versions/A/LDAP
    0x7fff33814000 -     0x7fff3381efff  com.apple.MediaAccessibility (1.0 - 114.4) <76C449C5-DB45-3D7F-BFAD-3DACEF15DA21> /System/Library/Frameworks/MediaAccessibility.framework/Versions/A/MediaAccessibility
    0x7fff338ce000 -     0x7fff33f74fff  com.apple.MediaToolbox (1.0 - 2290.13) <71BB5D76-34CA-3A30-AECF-24BE29FCC275> /System/Library/Frameworks/MediaToolbox.framework/Versions/A/MediaToolbox
    0x7fff33f76000 -     0x7fff3401eff7  com.apple.Metal (162.2 - 162.2) <FFF7DFF3-7C4E-32C6-A0B5-C356079D3B7C> /System/Library/Frameworks/Metal.framework/Versions/A/Metal
    0x7fff34020000 -     0x7fff34039ff3  com.apple.MetalKit (1.0 - 113) <51CDE966-54A7-3556-971B-1173E9986BB8> /System/Library/Frameworks/MetalKit.framework/Versions/A/MetalKit
    0x7fff3403a000 -     0x7fff34059ff7  com.apple.MetalPerformanceShaders.MPSCore (1.0 - 1) <44CE8362-E972-3697-AD6F-15BC863BAEB8> /System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSCore.framework/Versions/A/MPSCore
    0x7fff3405a000 -     0x7fff340d6fe7  com.apple.MetalPerformanceShaders.MPSImage (1.0 - 1) <EE8440DA-66DF-3923-ABBC-E0543211C069> /System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSImage.framework/Versions/A/MPSImage
    0x7fff340d7000 -     0x7fff340fefff  com.apple.MetalPerformanceShaders.MPSMatrix (1.0 - 1) <E64450DF-2B96-331E-B7F4-666E00571C70> /System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSMatrix.framework/Versions/A/MPSMatrix
    0x7fff340ff000 -     0x7fff3422aff7  com.apple.MetalPerformanceShaders.MPSNeuralNetwork (1.0 - 1) <F2CF26B6-73F1-3644-8FE9-CDB9B2C4501F> /System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSNeuralNetwork.framework/Versions/A/MPSNeuralNetwork
    0x7fff3422b000 -     0x7fff34245fff  com.apple.MetalPerformanceShaders.MPSRayIntersector (1.0 - 1) <B33A35C3-0393-366B-ACFB-F4BB6A5F7B4A> /System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSRayIntersector.framework/Versions/A/MPSRayIntersector
    0x7fff34246000 -     0x7fff34247ff7  com.apple.MetalPerformanceShaders.MetalPerformanceShaders (1.0 - 1) <69F14BCF-C5C5-3BF8-9C31-8F87D2D6130A> /System/Library/Frameworks/MetalPerformanceShaders.framework/Versions/A/MetalPerformanceShaders
    0x7fff3503e000 -     0x7fff3504aff7  com.apple.NetFS (6.0 - 4.0) <E917806F-0607-3292-B2D6-A15404D61B99> /System/Library/Frameworks/NetFS.framework/Versions/A/NetFS
    0x7fff3504b000 -     0x7fff35188ffb  com.apple.Network (1.0 - 1) <F46AFEE5-A56E-3BD9-AC07-C5D6334B3572> /System/Library/Frameworks/Network.framework/Versions/A/Network
    0x7fff37adf000 -     0x7fff37ae7fe3  libcldcpuengine.dylib (2.11) <AAE49359-EB53-3FD4-ADBF-C60498BD0B34> /System/Library/Frameworks/OpenCL.framework/Versions/A/Libraries/libcldcpuengine.dylib
    0x7fff37ae8000 -     0x7fff37b3fff7  com.apple.opencl (2.15.3 - 2.15.3) <056BAD8A-23BC-3F74-9E2C-3AC81E7DEA5A> /System/Library/Frameworks/OpenCL.framework/Versions/A/OpenCL
    0x7fff37b40000 -     0x7fff37b5bff7  com.apple.CFOpenDirectory (10.14 - 207.200.4) <F03D84EB-49B2-3A00-9127-B9A269824026> /System/Library/Frameworks/OpenDirectory.framework/Versions/A/Frameworks/CFOpenDirectory.framework/Versions/A/CFOpenDirectory
    0x7fff37b5c000 -     0x7fff37b67ffb  com.apple.OpenDirectory (10.14 - 207.200.4) <A8020CEE-5B78-3581-A735-EA2833683F31> /System/Library/Frameworks/OpenDirectory.framework/Versions/A/OpenDirectory
    0x7fff384b7000 -     0x7fff384b9fff  libCVMSPluginSupport.dylib (17.7.3) <8E051EA7-55B6-3DF1-9821-72C391DE953B> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libCVMSPluginSupport.dylib
    0x7fff384ba000 -     0x7fff384bfff3  libCoreFSCache.dylib (166.2) <222C2A4F-7E32-30F6-8459-2FAB98073A3D> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libCoreFSCache.dylib
    0x7fff384c0000 -     0x7fff384c4fff  libCoreVMClient.dylib (166.2) <6789ECD4-91DD-32EF-A1FD-F27D2344CD8B> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libCoreVMClient.dylib
    0x7fff384c5000 -     0x7fff384cdff7  libGFXShared.dylib (17.7.3) <8C50BF27-B525-3B23-B86C-F444ADF97851> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGFXShared.dylib
    0x7fff384ce000 -     0x7fff384d9fff  libGL.dylib (17.7.3) <2AC457EA-1BD3-3C8E-AFAB-7EA6234EB749> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib
    0x7fff384da000 -     0x7fff38514fef  libGLImage.dylib (17.7.3) <AA027AFA-C115-3861-89B2-0AE946838952> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGLImage.dylib
    0x7fff38515000 -     0x7fff38687ff7  libGLProgrammability.dylib (17.7.3) <5BB795C6-97AB-37AC-954C-145E3216AC3B> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGLProgrammability.dylib
    0x7fff38688000 -     0x7fff386c6fff  libGLU.dylib (17.7.3) <CB3B0579-D9A2-3CA5-8942-0C8344FAD054> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGLU.dylib
    0x7fff39063000 -     0x7fff39072ffb  com.apple.opengl (17.7.3 - 17.7.3) <94B5CF34-5BD6-3652-9A8C-E9C56E0A9FB4> /System/Library/Frameworks/OpenGL.framework/Versions/A/OpenGL
    0x7fff39073000 -     0x7fff3920aff7  GLEngine (17.7.3) <B2CB8E1E-4AD3-3CE4-ACB0-89A6749603D1> /System/Library/Frameworks/OpenGL.framework/Versions/A/Resources/GLEngine.bundle/GLEngine
    0x7fff3920b000 -     0x7fff39234ff3  GLRendererFloat (17.7.3) <A656F9C6-AB06-33C6-842A-600CB8B060C6> /System/Library/Frameworks/OpenGL.framework/Versions/A/Resources/GLRendererFloat.bundle/GLRendererFloat
    0x7fff393ef000 -     0x7fff39538ff7  com.apple.QTKit (7.7.3 - 3040) <D42BB4BE-B347-3113-ACA4-3257A5E45F52> /System/Library/Frameworks/QTKit.framework/Versions/A/QTKit
    0x7fff39539000 -     0x7fff3978dfff  com.apple.imageKit (3.0 - 1067) <4F398AF4-828E-3FC2-9E3D-4EE3F36F7619> /System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/ImageKit.framework/Versions/A/ImageKit
    0x7fff3978e000 -     0x7fff3987afff  com.apple.PDFKit (1.0 - 745.3) <EF7A5FC1-017A-329E-BDAE-3D136CE28E64> /System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/PDFKit.framework/Versions/A/PDFKit
    0x7fff3987b000 -     0x7fff39d4aff7  com.apple.QuartzComposer (5.1 - 370) <9C59494E-8D09-359E-B457-AA893520984C> /System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/QuartzComposer.framework/Versions/A/QuartzComposer
    0x7fff39d4b000 -     0x7fff39d71ff7  com.apple.quartzfilters (1.10.0 - 83.1) <1CABB0FA-A6DB-3DD5-A598-F298F081E04E> /System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/QuartzFilters.framework/Versions/A/QuartzFilters
    0x7fff39d72000 -     0x7fff39e73ff7  com.apple.QuickLookUIFramework (5.0 - 775.6) <5660DDBA-2BE4-310A-9E81-370106EDB21D> /System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/QuickLookUI.framework/Versions/A/QuickLookUI
    0x7fff39e74000 -     0x7fff39e74fff  com.apple.quartzframework (1.5 - 23) <31783652-5E36-3773-8847-9FECFE2487F0> /System/Library/Frameworks/Quartz.framework/Versions/A/Quartz
    0x7fff39e75000 -     0x7fff3a0ccff7  com.apple.QuartzCore (1.11 - 701.14) <33E846BE-1794-3186-9BF2-6ADF62C782A3> /System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore
    0x7fff3a0cd000 -     0x7fff3a124fff  com.apple.QuickLookFramework (5.0 - 775.6) <CB74C63F-E223-3783-9021-8E28091BCDA6> /System/Library/Frameworks/QuickLook.framework/Versions/A/QuickLook
    0x7fff3a2eb000 -     0x7fff3a302ff7  com.apple.SafariServices.framework (14607 - 14607.3.9) <96DFC381-5242-3D06-B115-9367C79801C9> /System/Library/Frameworks/SafariServices.framework/Versions/A/SafariServices
    0x7fff3a901000 -     0x7fff3ac01fff  com.apple.security (7.0 - 58286.270.3.0.1) <DF7677A7-9765-3B6A-9D1C-3589145E4B65> /System/Library/Frameworks/Security.framework/Versions/A/Security
    0x7fff3ac02000 -     0x7fff3ac8efff  com.apple.securityfoundation (6.0 - 55185.260.1) <1EE899E6-222A-3526-B505-B0D0B6FA042A> /System/Library/Frameworks/SecurityFoundation.framework/Versions/A/SecurityFoundation
    0x7fff3ac8f000 -     0x7fff3acbfffb  com.apple.securityinterface (10.0 - 55109.200.8) <02B83641-2D21-3DB8-AAB8-6F8AAD0F6264> /System/Library/Frameworks/SecurityInterface.framework/Versions/A/SecurityInterface
    0x7fff3acc0000 -     0x7fff3acc4fff  com.apple.xpc.ServiceManagement (1.0 - 1) <FCF7BABA-DDDD-3770-8DAC-7069850203C2> /System/Library/Frameworks/ServiceManagement.framework/Versions/A/ServiceManagement
    0x7fff3acc5000 -     0x7fff3ad15ff3  com.apple.sociald.Social (???) <72EA4265-4024-3143-80D2-A0074698A376> /System/Library/Frameworks/Social.framework/Versions/A/Social
    0x7fff3b05d000 -     0x7fff3b0cafff  com.apple.SystemConfiguration (1.17 - 1.17) <30C8327F-3EFF-3520-9C50-016F8B6B954F> /System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration
    0x7fff3b27b000 -     0x7fff3b2acff7  com.apple.UserNotifications (1.0 - ???) <0E1968F2-CE32-327A-9434-E3B128B4ACBA> /System/Library/Frameworks/UserNotifications.framework/Versions/A/UserNotifications
    0x7fff3b329000 -     0x7fff3b68afff  com.apple.VideoToolbox (1.0 - 2290.13) <7FCB2FC0-EFB8-37C2-B0D3-60AE9FDFE230> /System/Library/Frameworks/VideoToolbox.framework/Versions/A/VideoToolbox
    0x7fff3b95f000 -     0x7fff3bf6bff7  libwebrtc.dylib (7607.3.9) <4D2A43AD-B95E-3CF7-8822-553411D3EF15> /System/Library/Frameworks/WebKit.framework/Versions/A/Frameworks/WebCore.framework/Versions/A/Frameworks/libwebrtc.dylib
    0x7fff3bf6c000 -     0x7fff3d8f2ff7  com.apple.WebCore (14607 - 14607.3.9) <F50B7FC8-60F1-3FC4-83E1-0065463B27E6> /System/Library/Frameworks/WebKit.framework/Versions/A/Frameworks/WebCore.framework/Versions/A/WebCore
    0x7fff3d8f3000 -     0x7fff3dae4ffb  com.apple.WebKitLegacy (14607 - 14607.3.9) <59707811-F21F-388C-A801-C51D32E99392> /System/Library/Frameworks/WebKit.framework/Versions/A/Frameworks/WebKitLegacy.framework/Versions/A/WebKitLegacy
    0x7fff3dae5000 -     0x7fff3e035ff7  com.apple.WebKit (14607 - 14607.3.9) <AE6029DD-0CED-3FEF-92D5-DB8D4F9757F9> /System/Library/Frameworks/WebKit.framework/Versions/A/WebKit
    0x7fff3e306000 -     0x7fff3e3abfeb  com.apple.APFS (1.0 - 1) <2D22485D-552D-3CB6-9FE1-38547597918F> /System/Library/PrivateFrameworks/APFS.framework/Versions/A/APFS
    0x7fff3e938000 -     0x7fff3e942fff  com.apple.accessibility.AXCoreUtilities (1.0 - 1) <C97597AF-865F-3A33-A6EB-807EE9881521> /System/Library/PrivateFrameworks/AXCoreUtilities.framework/Versions/A/AXCoreUtilities
    0x7fff3eb10000 -     0x7fff3ebabffb  com.apple.accounts.AccountsDaemon (113 - 113) <0B9AA187-F2DE-320C-BBB0-E038E5C1991D> /System/Library/PrivateFrameworks/AccountsDaemon.framework/Versions/A/AccountsDaemon
    0x7fff3ebac000 -     0x7fff3ebdfffb  com.apple.framework.accountsui (1.0 - 63.6) <C5041BDA-0464-3CEC-B23E-0EA551D57532> /System/Library/PrivateFrameworks/AccountsUI.framework/Versions/A/AccountsUI
    0x7fff3ec5a000 -     0x7fff3eda4ff7  com.apple.AddressBook.core (1.0 - 1) <BAA3419D-2C62-3277-980D-11A9C51B1084> /System/Library/PrivateFrameworks/AddressBookCore.framework/Versions/A/AddressBookCore
    0x7fff3edc0000 -     0x7fff3edc1ff7  com.apple.AggregateDictionary (1.0 - 1) <A6AF8AC4-1F25-37C4-9157-A02E9C200926> /System/Library/PrivateFrameworks/AggregateDictionary.framework/Versions/A/AggregateDictionary
    0x7fff3f17f000 -     0x7fff3f2c2fff  com.apple.AnnotationKit (1.0 - 232.3.30) <A35C5450-FBA1-3E76-9F27-4ED0179AE6A6> /System/Library/PrivateFrameworks/AnnotationKit.framework/Versions/A/AnnotationKit
    0x7fff3f2c3000 -     0x7fff3f2deff7  com.apple.AppContainer (4.0 - 360.270.2) <644409D7-6C7A-336F-BF4F-80E82FB48BE9> /System/Library/PrivateFrameworks/AppContainer.framework/Versions/A/AppContainer
    0x7fff3f2df000 -     0x7fff3f2ecfff  com.apple.AppSandbox (4.0 - 360.270.2) <175BF1C6-8CB1-3AAA-A752-781E09DE3D8E> /System/Library/PrivateFrameworks/AppSandbox.framework/Versions/A/AppSandbox
    0x7fff3f3c2000 -     0x7fff3f3eeff7  com.apple.framework.Apple80211 (13.0 - 1380.2) <16F093EF-370B-3B90-8DB4-E94624431D15> /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Apple80211
    0x7fff3f516000 -     0x7fff3f525fc7  com.apple.AppleFSCompression (96.200.3 - 1.0) <3CF60CE8-976E-3CB8-959D-DD0948C1C2DE> /System/Library/PrivateFrameworks/AppleFSCompression.framework/Versions/A/AppleFSCompression
    0x7fff3f621000 -     0x7fff3f62cfff  com.apple.AppleIDAuthSupport (1.0 - 1) <2E9D1398-DBE6-328B-ADDA-20FA5FAD7405> /System/Library/PrivateFrameworks/AppleIDAuthSupport.framework/Versions/A/AppleIDAuthSupport
    0x7fff3f66d000 -     0x7fff3f6b6ff3  com.apple.AppleJPEG (1.0 - 1) <4C1F426B-7D77-3980-9633-7DBD8C666B9A> /System/Library/PrivateFrameworks/AppleJPEG.framework/Versions/A/AppleJPEG
    0x7fff3f6b7000 -     0x7fff3f6c7fff  com.apple.AppleLDAP (10.14 - 46.200.2) <DA9C0E8E-86D6-3CE8-8A12-B9C2254920A8> /System/Library/PrivateFrameworks/AppleLDAP.framework/Versions/A/AppleLDAP
    0x7fff3f8e7000 -     0x7fff3f904fff  com.apple.aps.framework (4.0 - 4.0) <83FB4BD1-0C45-3CEF-8640-567DA5A300A7> /System/Library/PrivateFrameworks/ApplePushService.framework/Versions/A/ApplePushService
    0x7fff3f905000 -     0x7fff3f909ff7  com.apple.AppleSRP (5.0 - 1) <EDD16B2E-4F35-3E13-B389-CF77B3CAD4EB> /System/Library/PrivateFrameworks/AppleSRP.framework/Versions/A/AppleSRP
    0x7fff3f90a000 -     0x7fff3f92cfff  com.apple.applesauce (1.0 - ???) <F49107C7-3C51-3024-8EF1-C57643BE4F3B> /System/Library/PrivateFrameworks/AppleSauce.framework/Versions/A/AppleSauce
    0x7fff3f9ec000 -     0x7fff3f9efff7  com.apple.AppleSystemInfo (3.1.5 - 3.1.5) <A48BC6D4-224C-3A25-846B-4D06C53568AE> /System/Library/PrivateFrameworks/AppleSystemInfo.framework/Versions/A/AppleSystemInfo
    0x7fff3f9f0000 -     0x7fff3fa40ff7  com.apple.AppleVAFramework (5.1.4 - 5.1.4) <3399D678-8741-3B70-B8D0-7C63C8ACF7DF> /System/Library/PrivateFrameworks/AppleVA.framework/Versions/A/AppleVA
    0x7fff3fa8b000 -     0x7fff3fa9fffb  com.apple.AssertionServices (1.0 - 1) <456E507A-4561-3628-9FBE-173ACE7429D8> /System/Library/PrivateFrameworks/AssertionServices.framework/Versions/A/AssertionServices
    0x7fff3fe6e000 -     0x7fff3ff5aff7  com.apple.AuthKit (1.0 - 1) <2765ABE9-54F2-3E45-8A93-1261E251B90D> /System/Library/PrivateFrameworks/AuthKit.framework/Versions/A/AuthKit
    0x7fff3ffc4000 -     0x7fff3ffc8ffb  com.apple.AuthenticationServices (12.0 - 1.0) <F33C914E-F815-39BB-89BB-D1A5D3B3EF84> /System/Library/PrivateFrameworks/AuthenticationServices.framework/Versions/A/AuthenticationServices
    0x7fff4011c000 -     0x7fff40124fff  com.apple.coreservices.BackgroundTaskManagement (1.0 - 57.1) <2A396FC0-7B79-3088-9A82-FB93C1181A57> /System/Library/PrivateFrameworks/BackgroundTaskManagement.framework/Versions/A/BackgroundTaskManagement
    0x7fff40125000 -     0x7fff401bafff  com.apple.backup.framework (1.10.5 - ???) <4EEC51E2-AE4C-340A-B686-901810152C12> /System/Library/PrivateFrameworks/Backup.framework/Versions/A/Backup
    0x7fff401bb000 -     0x7fff40228ff3  com.apple.BaseBoard (360.28 - 360.28) <68FA8044-F3CD-3BC6-9DAB-27DACF52BFC0> /System/Library/PrivateFrameworks/BaseBoard.framework/Versions/A/BaseBoard
    0x7fff40231000 -     0x7fff40237ffb  com.apple.BezelServicesFW (317.5 - 317.5) <25807B30-117A-33D9-93E6-48E8AE90BD63> /System/Library/PrivateFrameworks/BezelServices.framework/Versions/A/BezelServices
    0x7fff402ae000 -     0x7fff402eaff3  com.apple.bom (14.0 - 197.6) <A99A6F9A-AFDE-3BC6-95CE-AA90B268B805> /System/Library/PrivateFrameworks/Bom.framework/Versions/A/Bom
    0x7fff40999000 -     0x7fff409c5ffb  com.apple.CalendarAgentLink (8.0 - 250) <4702E078-86DF-373F-BF2F-AB6230E19010> /System/Library/PrivateFrameworks/CalendarAgentLink.framework/Versions/A/CalendarAgentLink
    0x7fff41086000 -     0x7fff410d5ff7  com.apple.ChunkingLibrary (201 - 201) <DFE16C42-24E6-386F-AC50-0058F61980A2> /System/Library/PrivateFrameworks/ChunkingLibrary.framework/Versions/A/ChunkingLibrary
    0x7fff41e86000 -     0x7fff41e92ff7  com.apple.CommerceCore (1.0 - 708.5) <B5939A65-745F-3AB7-A212-EF140E148F42> /System/Library/PrivateFrameworks/CommerceKit.framework/Versions/A/Frameworks/CommerceCore.framework/Versions/A/CommerceCore
    0x7fff41e93000 -     0x7fff41e9cffb  com.apple.CommonAuth (4.0 - 2.0) <93335CB6-ABEB-3EC7-A040-8A667F40D5F3> /System/Library/PrivateFrameworks/CommonAuth.framework/Versions/A/CommonAuth
    0x7fff41eb0000 -     0x7fff41ec5ffb  com.apple.commonutilities (8.0 - 900) <080E168B-21B7-3CCA-AB84-BB9911D18DAC> /System/Library/PrivateFrameworks/CommonUtilities.framework/Versions/A/CommonUtilities
    0x7fff4216d000 -     0x7fff421cfff3  com.apple.AddressBook.ContactsFoundation (8.0 - ???) <F5136318-4F71-37D7-A909-5005C698A354> /System/Library/PrivateFrameworks/ContactsFoundation.framework/Versions/A/ContactsFoundation
    0x7fff421d0000 -     0x7fff421f3ff3  com.apple.contacts.ContactsPersistence (1.0 - ???) <4082E8CF-5C89-3DE1-97BF-6434F3E03C16> /System/Library/PrivateFrameworks/ContactsPersistence.framework/Versions/A/ContactsPersistence
    0x7fff42335000 -     0x7fff42718fef  com.apple.CoreAUC (274.0.0 - 274.0.0) <C71F1581-E73B-3DA0-958B-E912C3FB3F23> /System/Library/PrivateFrameworks/CoreAUC.framework/Versions/A/CoreAUC
    0x7fff42719000 -     0x7fff42747ff7  com.apple.CoreAVCHD (6.0.0 - 6000.4.1) <A04A99B8-DAC5-36FC-BAC7-7431600C1F89> /System/Library/PrivateFrameworks/CoreAVCHD.framework/Versions/A/CoreAVCHD
    0x7fff427dd000 -     0x7fff4283bffb  com.apple.corebrightness (1.0 - 1) <61040CCD-0AFD-389F-87E8-0FD9D8C3BAE1> /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
    0x7fff42972000 -     0x7fff4297bfff  com.apple.frameworks.CoreDaemon (1.3 - 1.3) <89BDACE6-32AA-3933-BD8C-A44650488873> /System/Library/PrivateFrameworks/CoreDaemon.framework/Versions/B/CoreDaemon
    0x7fff42b75000 -     0x7fff42b86ff7  com.apple.CoreEmoji (1.0 - 69.19.9) <228457B3-E191-356E-9A5B-3C0438D05FBA> /System/Library/PrivateFrameworks/CoreEmoji.framework/Versions/A/CoreEmoji
    0x7fff42d2f000 -     0x7fff42e1efff  com.apple.CoreHandwriting (161 - 1.2) <7CBB18C3-FE95-3352-9D67-B441E89AD10F> /System/Library/PrivateFrameworks/CoreHandwriting.framework/Versions/A/CoreHandwriting
    0x7fff42ff0000 -     0x7fff43006ffb  com.apple.CoreMediaAuthoring (2.2 - 959) <86089759-E920-37DB-A3BB-F5621C351E4A> /System/Library/PrivateFrameworks/CoreMediaAuthoring.framework/Versions/A/CoreMediaAuthoring
    0x7fff43130000 -     0x7fff43196ff7  com.apple.CoreNLP (1.0 - 130.15.22) <27877820-17D0-3B02-8557-4014E876CCC7> /System/Library/PrivateFrameworks/CoreNLP.framework/Versions/A/CoreNLP
    0x7fff432fd000 -     0x7fff43301ff7  com.apple.CoreOptimization (1.0 - 1) <1C724E01-E9FA-3AEE-BE4B-C4DB8EC0C812> /System/Library/PrivateFrameworks/CoreOptimization.framework/Versions/A/CoreOptimization
    0x7fff43302000 -     0x7fff4338efff  com.apple.CorePDF (4.0 - 414) <E4ECDD15-34C0-30C2-AFA9-27C8EDAC3DB0> /System/Library/PrivateFrameworks/CorePDF.framework/Versions/A/CorePDF
    0x7fff43443000 -     0x7fff4344bff7  com.apple.CorePhoneNumbers (1.0 - 1) <11F97C7E-C183-305F-8E6C-9B374F50E26B> /System/Library/PrivateFrameworks/CorePhoneNumbers.framework/Versions/A/CorePhoneNumbers
    0x7fff4344c000 -     0x7fff434a2ff7  com.apple.CorePrediction (1.0 - 1) <A66C8A6F-C3B2-3547-985D-C62C62F9FA48> /System/Library/PrivateFrameworks/CorePrediction.framework/Versions/A/CorePrediction
    0x7fff435c7000 -     0x7fff435f8ff3  com.apple.CoreServicesInternal (358 - 358) <DD6EF60D-048F-3186-83DA-EB191EDF48AE> /System/Library/PrivateFrameworks/CoreServicesInternal.framework/Versions/A/CoreServicesInternal
    0x7fff439bf000 -     0x7fff43a43fff  com.apple.CoreSymbolication (10.2 - 64490.25.1) <28B2FF2D-3FDE-3A20-B343-341E5BD4E22F> /System/Library/PrivateFrameworks/CoreSymbolication.framework/Versions/A/CoreSymbolication
    0x7fff43ad3000 -     0x7fff43bfeff7  com.apple.coreui (2.1 - 499.10) <A80F4B09-F940-346F-A9DF-4EFADD9220A8> /System/Library/PrivateFrameworks/CoreUI.framework/Versions/A/CoreUI
    0x7fff43bff000 -     0x7fff43d9ffff  com.apple.CoreUtils (5.9 - 590.16) <66CC50F7-766D-33E2-A388-4DE22840ADFB> /System/Library/PrivateFrameworks/CoreUtils.framework/Versions/A/CoreUtils
    0x7fff43df3000 -     0x7fff43e56ff7  com.apple.framework.CoreWiFi (13.0 - 1375.2) <CA4B835A-27AC-3FAB-9F44-E48548EA2442> /System/Library/PrivateFrameworks/CoreWiFi.framework/Versions/A/CoreWiFi
    0x7fff43e57000 -     0x7fff43e68ff7  com.apple.CrashReporterSupport (10.13 - 938.26) <E93D84A6-891D-38EE-BB4F-E9CD681189B7> /System/Library/PrivateFrameworks/CrashReporterSupport.framework/Versions/A/CrashReporterSupport
    0x7fff43ef8000 -     0x7fff43f07fff  com.apple.framework.DFRFoundation (1.0 - 211.1) <E3F02F2A-2059-39CC-85DA-969676EB88EB> /System/Library/PrivateFrameworks/DFRFoundation.framework/Versions/A/DFRFoundation
    0x7fff43f08000 -     0x7fff43f0cff7  com.apple.DSExternalDisplay (3.1 - 380) <787B9748-B120-3453-B8FE-61D9E363A9E0> /System/Library/PrivateFrameworks/DSExternalDisplay.framework/Versions/A/DSExternalDisplay
    0x7fff43f4e000 -     0x7fff43f8cff7  com.apple.datadetectors (5.0 - 390.2) <B6DEDE81-832C-3078-ACAF-767F01E9615D> /System/Library/PrivateFrameworks/DataDetectors.framework/Versions/A/DataDetectors
    0x7fff43f8d000 -     0x7fff44002ffb  com.apple.datadetectorscore (7.0 - 590.27) <06FB1A07-7AE6-3ADD-8E7E-41955FAB38E8> /System/Library/PrivateFrameworks/DataDetectorsCore.framework/Versions/A/DataDetectorsCore
    0x7fff4404e000 -     0x7fff4408bff7  com.apple.DebugSymbols (190 - 190) <6F4FAACA-E06B-38AD-A0C2-14EA5408A231> /System/Library/PrivateFrameworks/DebugSymbols.framework/Versions/A/DebugSymbols
    0x7fff4408c000 -     0x7fff441c7ff7  com.apple.desktopservices (1.13.5 - ???) <265C0E94-B8BF-3F58-8D68-EA001EEA0B15> /System/Library/PrivateFrameworks/DesktopServicesPriv.framework/Versions/A/DesktopServicesPriv
    0x7fff44271000 -     0x7fff44272ff7  com.apple.diagnosticlogcollection (10.0 - 1000) <3C6F41B0-DD03-373C-B423-63C1FA6174EC> /System/Library/PrivateFrameworks/DiagnosticLogCollection.framework/Versions/A/DiagnosticLogCollection
    0x7fff443d3000 -     0x7fff44499fff  com.apple.DiskManagement (12.1 - 1555.270.2) <EB207683-FBD6-3B74-A606-3FE22234372C> /System/Library/PrivateFrameworks/DiskManagement.framework/Versions/A/DiskManagement
    0x7fff4449a000 -     0x7fff4449effb  com.apple.DisplayServicesFW (3.1 - 380) <62041594-2A4C-3362-87EE-F8E8C8E5BEEC> /System/Library/PrivateFrameworks/DisplayServices.framework/Versions/A/DisplayServices
    0x7fff44547000 -     0x7fff4454aff3  com.apple.EFILogin (2.0 - 2) <210948F9-FD39-392D-8349-34985B3C751C> /System/Library/PrivateFrameworks/EFILogin.framework/Versions/A/EFILogin
    0x7fff44c6a000 -     0x7fff44c7ffff  com.apple.Engram (1.0 - 1) <F4A93313-F507-3F9A-AB1C-C18F2779B7CF> /System/Library/PrivateFrameworks/Engram.framework/Versions/A/Engram
    0x7fff44c80000 -     0x7fff44f62ff7  com.apple.vision.EspressoFramework (1.0 - 120) <8B56D943-F87B-3A01-B7A4-19DE3312B61C> /System/Library/PrivateFrameworks/Espresso.framework/Versions/A/Espresso
    0x7fff4510e000 -     0x7fff45529fff  com.apple.vision.FaceCore (3.3.4 - 3.3.4) <A576E2DA-BF6F-3B18-8FEB-324E5C5FA9BD> /System/Library/PrivateFrameworks/FaceCore.framework/Versions/A/FaceCore
    0x7fff48ddd000 -     0x7fff48ddefff  libmetal_timestamp.dylib (902.3.2) <05389463-AF2E-33E2-A14F-1416E4A30835> /System/Library/PrivateFrameworks/GPUCompiler.framework/Versions/3902/Libraries/libmetal_timestamp.dylib
    0x7fff4a472000 -     0x7fff4a47dff7  libGPUSupportMercury.dylib (17.7.3) <36E3C5B1-15EB-3713-BC3A-31A3B074DD24> /System/Library/PrivateFrameworks/GPUSupport.framework/Versions/A/Libraries/libGPUSupportMercury.dylib
    0x7fff4a47e000 -     0x7fff4a483fff  com.apple.GPUWrangler (3.50.12 - 3.50.12) <6C820ED9-F306-3978-B5B8-432AD97BBDAF> /System/Library/PrivateFrameworks/GPUWrangler.framework/Versions/A/GPUWrangler
    0x7fff4a811000 -     0x7fff4a835ff3  com.apple.GenerationalStorage (2.0 - 285.101) <84C2E52C-F2C6-3FF8-87E5-3C88A40D3881> /System/Library/PrivateFrameworks/GenerationalStorage.framework/Versions/A/GenerationalStorage
    0x7fff4a84e000 -     0x7fff4b24dfff  com.apple.GeoServices (1.0 - 1364.26.4.19.6) <041715B5-D82F-31F6-9133-955A7A66025F> /System/Library/PrivateFrameworks/GeoServices.framework/Versions/A/GeoServices
    0x7fff4b28f000 -     0x7fff4b29efff  com.apple.GraphVisualizer (1.0 - 5) <48D020B7-5938-3FAE-B468-E291AEE2C06F> /System/Library/PrivateFrameworks/GraphVisualizer.framework/Versions/A/GraphVisualizer
    0x7fff4b29f000 -     0x7fff4b2acff7  com.apple.GraphicsServices (1.0 - 1.0) <56646B62-B331-31DC-80EB-7996DCAB6944> /System/Library/PrivateFrameworks/GraphicsServices.framework/Versions/A/GraphicsServices
    0x7fff4b404000 -     0x7fff4b478ffb  com.apple.Heimdal (4.0 - 2.0) <D97FCF19-EAD6-3E2F-BE88-F817E45CAE96> /System/Library/PrivateFrameworks/Heimdal.framework/Versions/A/Heimdal
    0x7fff4b479000 -     0x7fff4b4a7fff  com.apple.HelpData (2.3 - 184.4) <22850610-29F8-3902-93A3-BBF403440185> /System/Library/PrivateFrameworks/HelpData.framework/Versions/A/HelpData
    0x7fff4bec6000 -     0x7fff4bfbfff7  com.apple.ids (10.0 - 1000) <4F434376-4C61-337C-94DA-A7DD812AD04A> /System/Library/PrivateFrameworks/IDS.framework/Versions/A/IDS
    0x7fff4bfc0000 -     0x7fff4c0c3fff  com.apple.idsfoundation (10.0 - 1000) <2B598376-0B24-3AB5-8C0C-D5528C334295> /System/Library/PrivateFrameworks/IDSFoundation.framework/Versions/A/IDSFoundation
    0x7fff4c642000 -     0x7fff4c6a3fff  com.apple.imfoundation (10.0 - 1000) <098F3A98-2184-32EF-8EC9-87B892CD85CA> /System/Library/PrivateFrameworks/IMFoundation.framework/Versions/A/IMFoundation
    0x7fff4c77e000 -     0x7fff4c785ffb  com.apple.IOAccelerator (404.14 - 404.14) <11A50171-C8AE-3BBC-9FB9-2A3313FFBD31> /System/Library/PrivateFrameworks/IOAccelerator.framework/Versions/A/IOAccelerator
    0x7fff4c789000 -     0x7fff4c7a1fff  com.apple.IOPresentment (1.0 - 42.6) <6DFD9A6E-BF95-3A27-89E7-ACAA9E30D90A> /System/Library/PrivateFrameworks/IOPresentment.framework/Versions/A/IOPresentment
    0x7fff4cb49000 -     0x7fff4cb76ff7  com.apple.IconServices (379 - 379) <7BAD562D-4FA3-3E11-863C-1EEBE2406D2C> /System/Library/PrivateFrameworks/IconServices.framework/Versions/A/IconServices
    0x7fff4cca0000 -     0x7fff4cca4ffb  com.apple.InternationalSupport (1.0 - 10.15.6) <6226A905-D055-321D-B665-5B0CC4798A74> /System/Library/PrivateFrameworks/InternationalSupport.framework/Versions/A/InternationalSupport
    0x7fff4cd0e000 -     0x7fff4cd1bffb  com.apple.IntlPreferences (2.0 - 227.18) <1B5AFE5D-4D6F-3471-8F4D-256F5068093F> /System/Library/PrivateFrameworks/IntlPreferences.framework/Versions/A/IntlPreferences
    0x7fff4ce09000 -     0x7fff4ce1bff3  com.apple.security.KeychainCircle.KeychainCircle (1.0 - 1) <30CFE05C-4108-3879-AFAA-5BB02CBE190B> /System/Library/PrivateFrameworks/KeychainCircle.framework/Versions/A/KeychainCircle
    0x7fff4ce36000 -     0x7fff4cf11ff7  com.apple.LanguageModeling (1.0 - 159.15.15) <3DE3CE61-542B-37B7-883E-4B9717CAC65F> /System/Library/PrivateFrameworks/LanguageModeling.framework/Versions/A/LanguageModeling
    0x7fff4cf12000 -     0x7fff4cf4eff7  com.apple.Lexicon-framework (1.0 - 33.15.10) <4B5E843E-2809-3E70-9560-9254E2656419> /System/Library/PrivateFrameworks/Lexicon.framework/Versions/A/Lexicon
    0x7fff4cf55000 -     0x7fff4cf5afff  com.apple.LinguisticData (1.0 - 238.25) <F529B961-098C-3E4C-A3E9-9DA9BFA1B3F0> /System/Library/PrivateFrameworks/LinguisticData.framework/Versions/A/LinguisticData
    0x7fff4d0ac000 -     0x7fff4d0c5ff3  com.apple.LookupFramework (1.2 - 251) <50031B5A-F3D5-39CC-954A-B3AEAF52FB89> /System/Library/PrivateFrameworks/Lookup.framework/Versions/A/Lookup
    0x7fff4d778000 -     0x7fff4d77bfff  com.apple.Mangrove (1.0 - 25) <537A5B2E-4C30-3CFD-8BDC-79F9A04AC327> /System/Library/PrivateFrameworks/Mangrove.framework/Versions/A/Mangrove
    0x7fff4d7ff000 -     0x7fff4d801ff3  com.apple.marco (10.0 - 1000) <608B1000-1427-34B3-96B4-5B6079964E7F> /System/Library/PrivateFrameworks/Marco.framework/Versions/A/Marco
    0x7fff4d802000 -     0x7fff4d828ff3  com.apple.MarkupUI (1.0 - 232.3.30) <C6A452D8-CA97-3044-A025-8ED4B7264FE2> /System/Library/PrivateFrameworks/MarkupUI.framework/Versions/A/MarkupUI
    0x7fff4d890000 -     0x7fff4d8c3ff7  com.apple.MediaKit (16 - 907) <5EE0E7DA-5ACC-33F3-9BF0-47A448C011A1> /System/Library/PrivateFrameworks/MediaKit.framework/Versions/A/MediaKit
    0x7fff4dc4f000 -     0x7fff4dc77ff7  com.apple.spotlight.metadata.utilities (1.0 - 1191.57) <38BB1FB7-3336-384C-B71F-4D0D402EB606> /System/Library/PrivateFrameworks/MetadataUtilities.framework/Versions/A/MetadataUtilities
    0x7fff4dc78000 -     0x7fff4dd05ff7  com.apple.gpusw.MetalTools (1.0 - 1) <CBE2176A-8048-3A9C-AFE4-13973D44C704> /System/Library/PrivateFrameworks/MetalTools.framework/Versions/A/MetalTools
    0x7fff4dd1c000 -     0x7fff4dd35ffb  com.apple.MobileAssets (1.0 - 437.250.3) <8BE5B3A0-8F3A-3FAE-9AFF-32836300183C> /System/Library/PrivateFrameworks/MobileAsset.framework/Versions/A/MobileAsset
    0x7fff4deb0000 -     0x7fff4decbffb  com.apple.MobileKeyBag (2.0 - 1.0) <C7C5DD21-66DE-31D1-92D9-BBEEAAE156FB> /System/Library/PrivateFrameworks/MobileKeyBag.framework/Versions/A/MobileKeyBag
    0x7fff4dede000 -     0x7fff4df53fff  com.apple.Montreal (1.0 - 42.15.9) <17BFD046-4362-3A76-A496-648D00FF3743> /System/Library/PrivateFrameworks/Montreal.framework/Versions/A/Montreal
    0x7fff4df54000 -     0x7fff4df7effb  com.apple.MultitouchSupport.framework (2450.1 - 2450.1) <42A23EC9-64A7-31C7-BF33-DF4412ED8A3F> /System/Library/PrivateFrameworks/MultitouchSupport.framework/Versions/A/MultitouchSupport
    0x7fff4e1ba000 -     0x7fff4e1c4fff  com.apple.NetAuth (6.2 - 6.2) <0D01BBE5-0269-310D-B148-D19DAE143DEB> /System/Library/PrivateFrameworks/NetAuth.framework/Versions/A/NetAuth
    0x7fff4e8e4000 -     0x7fff4e8e6fff  com.apple.OAuth (25 - 25) <64DB58E3-25A4-3C8B-91FB-FACBA01C29B6> /System/Library/PrivateFrameworks/OAuth.framework/Versions/A/OAuth
    0x7fff4ea25000 -     0x7fff4ea76ff3  com.apple.OTSVG (1.0 - ???) <5BF1A9EB-2694-3267-9514-A4EB3BEF4081> /System/Library/PrivateFrameworks/OTSVG.framework/Versions/A/OTSVG
    0x7fff4fb1a000 -     0x7fff4fc0dfff  com.apple.PencilKit (1.0 - 1) <79225726-6980-3680-AC0B-D8C5C5DB2224> /System/Library/PrivateFrameworks/PencilKit.framework/Versions/A/PencilKit
    0x7fff4fc0e000 -     0x7fff4fc1dff7  com.apple.PerformanceAnalysis (1.218.2 - 218.2) <65F3DB3E-6D4E-33A0-B510-EF768D323DAB> /System/Library/PrivateFrameworks/PerformanceAnalysis.framework/Versions/A/PerformanceAnalysis
    0x7fff4fe44000 -     0x7fff4fe44fff  com.apple.PhoneNumbers (1.0 - 1) <DBCEDE3B-B681-3F6C-89EC-36E4827A2AF9> /System/Library/PrivateFrameworks/PhoneNumbers.framework/Versions/A/PhoneNumbers
    0x7fff51600000 -     0x7fff51623ffb  com.apple.pluginkit.framework (1.0 - 1) <910C3AFE-7C46-3C34-B000-4ED92336B9FD> /System/Library/PrivateFrameworks/PlugInKit.framework/Versions/A/PlugInKit
    0x7fff51a5a000 -     0x7fff51aaeffb  com.apple.ProtectedCloudStorage (1.0 - 1) <53B3C1F3-BB97-379F-8CBA-8FDCDF085793> /System/Library/PrivateFrameworks/ProtectedCloudStorage.framework/Versions/A/ProtectedCloudStorage
    0x7fff51aaf000 -     0x7fff51acdff7  com.apple.ProtocolBuffer (1 - 263.2) <907D6C95-D050-31DE-99CA-16A5135BC6F9> /System/Library/PrivateFrameworks/ProtocolBuffer.framework/Versions/A/ProtocolBuffer
    0x7fff51c4b000 -     0x7fff51c4eff3  com.apple.QuickLookNonBaseSystem (1.0 - 1) <69D0DD00-A3D2-3835-91F0-F33BD9D7D740> /System/Library/PrivateFrameworks/QuickLookNonBaseSystem.framework/Versions/A/QuickLookNonBaseSystem
    0x7fff51c4f000 -     0x7fff51c64ff3  com.apple.QuickLookThumbnailing (1.0 - 1) <B5E746AE-1DCB-3299-8626-10CCCBC2D5EE> /System/Library/PrivateFrameworks/QuickLookThumbnailing.framework/Versions/A/QuickLookThumbnailing
    0x7fff51c65000 -     0x7fff51cb5fff  com.apple.ROCKit (27.6 - 27.6) <756C2253-E8B1-3C48-9945-DE8D6AD24DE2> /System/Library/PrivateFrameworks/ROCKit.framework/Versions/A/ROCKit
    0x7fff51df1000 -     0x7fff51dfcfff  com.apple.xpc.RemoteServiceDiscovery (1.0 - 1336.261.2) <651F994E-21E1-359B-8FEA-6909CE9AAD56> /System/Library/PrivateFrameworks/RemoteServiceDiscovery.framework/Versions/A/RemoteServiceDiscovery
    0x7fff51e0f000 -     0x7fff51e31fff  com.apple.RemoteViewServices (2.0 - 128) <8FB0E4EB-DCBB-32E6-94C6-AA9BA9EE4CAC> /System/Library/PrivateFrameworks/RemoteViewServices.framework/Versions/A/RemoteViewServices
    0x7fff51e32000 -     0x7fff51e45ff3  com.apple.xpc.RemoteXPC (1.0 - 1336.261.2) <E7B66B18-F5DF-3819-BA47-E35122BA09E8> /System/Library/PrivateFrameworks/RemoteXPC.framework/Versions/A/RemoteXPC
    0x7fff52b70000 -     0x7fff52bb9fff  com.apple.Safari.SafeBrowsing (14607 - 14607.3.9) <F4DA3E55-28AF-3406-8120-9B797197ABED> /System/Library/PrivateFrameworks/SafariSafeBrowsing.framework/Versions/A/SafariSafeBrowsing
    0x7fff534dc000 -     0x7fff534dfff7  com.apple.SecCodeWrapper (4.0 - 360.270.2) <6B331C0A-1A9D-3039-9FF6-89A49B04F846> /System/Library/PrivateFrameworks/SecCodeWrapper.framework/Versions/A/SecCodeWrapper
    0x7fff535b8000 -     0x7fff5362eff7  com.apple.ShareKit (577.5 - 577.5) <6563A611-6FA7-34E5-BCB2-3E7ECABBD48B> /System/Library/PrivateFrameworks/ShareKit.framework/Versions/A/ShareKit
    0x7fff5363b000 -     0x7fff53759fff  com.apple.Sharing (1288.62 - 1288.62) <48B1F247-7910-3C16-814C-B99DE231F7F0> /System/Library/PrivateFrameworks/Sharing.framework/Versions/A/Sharing
    0x7fff5375a000 -     0x7fff53779ffb  com.apple.shortcut (2.16 - 101) <FA635B3A-8B45-3132-BB06-BD0398F03E12> /System/Library/PrivateFrameworks/Shortcut.framework/Versions/A/Shortcut
    0x7fff5456d000 -     0x7fff5481cfff  com.apple.SkyLight (1.600.0 - 340.54) <90EB1C2E-B264-3EC4-AF7F-CDE7E7585746> /System/Library/PrivateFrameworks/SkyLight.framework/Versions/A/SkyLight
    0x7fff54cc9000 -     0x7fff54ccffff  com.apple.sociald.SocialServices (87 - 87) <ED5770CB-2251-3AD2-B52A-7B19B8753F54> /System/Library/PrivateFrameworks/SocialServices.framework/Versions/A/SocialServices
    0x7fff54fbf000 -     0x7fff54fcbfff  com.apple.SpeechRecognitionCore (5.0.21 - 5.0.21) <7A6A67DB-C813-328E-AAFB-D267A5B50B3D> /System/Library/PrivateFrameworks/SpeechRecognitionCore.framework/Versions/A/SpeechRecognitionCore
    0x7fff5566a000 -     0x7fff556a6ff3  com.apple.StreamingZip (1.0 - 1) <046FAD5C-E0C5-3013-B1FE-24C018A0DDCF> /System/Library/PrivateFrameworks/StreamingZip.framework/Versions/A/StreamingZip
    0x7fff5571c000 -     0x7fff557a7fc7  com.apple.Symbolication (10.2 - 64490.38.1) <9FDCC98D-5B32-35AD-A9BF-94DF2B78507F> /System/Library/PrivateFrameworks/Symbolication.framework/Versions/A/Symbolication
    0x7fff557a8000 -     0x7fff557b0ffb  com.apple.SymptomDiagnosticReporter (1.0 - 820.267.1) <DB68EC08-EC2D-35DC-8D34-B4A2C36A9DE9> /System/Library/PrivateFrameworks/SymptomDiagnosticReporter.framework/Versions/A/SymptomDiagnosticReporter
    0x7fff55c7e000 -     0x7fff55c8afff  com.apple.private.SystemPolicy (1.0 - 1) <9CDA85A3-875C-3615-8818-2DC73E9FFE8B> /System/Library/PrivateFrameworks/SystemPolicy.framework/Versions/A/SystemPolicy
    0x7fff55c8f000 -     0x7fff55c9bffb  com.apple.TCC (1.0 - 1) <73CF6FA9-44CE-30C9-887F-235940976585> /System/Library/PrivateFrameworks/TCC.framework/Versions/A/TCC
    0x7fff55f01000 -     0x7fff55fc9ff3  com.apple.TextureIO (3.8.4 - 3.8.1) <7CEAC05A-D283-3D5A-B1E3-C849285FA0BF> /System/Library/PrivateFrameworks/TextureIO.framework/Versions/A/TextureIO
    0x7fff56026000 -     0x7fff56041fff  com.apple.ToneKit (1.0 - 1) <84911F2C-394F-3FFF-8220-B51F581BB8E6> /System/Library/PrivateFrameworks/ToneKit.framework/Versions/A/ToneKit
    0x7fff56042000 -     0x7fff56067ff7  com.apple.ToneLibrary (1.0 - 1) <4D7D03EB-744F-3402-8C3E-B483A74BEF1E> /System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/ToneLibrary
    0x7fff5607f000 -     0x7fff56080fff  com.apple.TrustEvaluationAgent (2.0 - 31.200.1) <15DF9C73-54E4-3C41-BCF4-378338C55FB4> /System/Library/PrivateFrameworks/TrustEvaluationAgent.framework/Versions/A/TrustEvaluationAgent
    0x7fff56086000 -     0x7fff5623dffb  com.apple.UIFoundation (1.0 - 551.2) <917480B5-14BE-30E0-ABE6-9702336CC35A> /System/Library/PrivateFrameworks/UIFoundation.framework/Versions/A/UIFoundation
    0x7fff5628b000 -     0x7fff56291ffb  com.apple.URLFormatting (59 - 59.46) <8FA3A00C-7BFF-33B9-95EA-A7FC04091D4D> /System/Library/PrivateFrameworks/URLFormatting.framework/Versions/A/URLFormatting
    0x7fff56eb9000 -     0x7fff56f92fff  com.apple.ViewBridge (401.1 - 401.1) <18144EC1-5DEF-369C-8EBA-2826E7142784> /System/Library/PrivateFrameworks/ViewBridge.framework/Versions/A/ViewBridge
    0x7fff573d5000 -     0x7fff57647ffb  libAWDSupportFramework.dylib (2131) <AC78D095-4D47-37DF-AE0D-8EEC7C2553F0> /System/Library/PrivateFrameworks/WirelessDiagnostics.framework/Versions/A/Libraries/libAWDSupportFramework.dylib
    0x7fff57648000 -     0x7fff57659fff  libprotobuf-lite.dylib (2131) <297886A7-F889-38AA-B6F6-162598345EC4> /System/Library/PrivateFrameworks/WirelessDiagnostics.framework/Versions/A/Libraries/libprotobuf-lite.dylib
    0x7fff5765a000 -     0x7fff576b4fff  libprotobuf.dylib (2131) <05141A5F-1870-3AA7-B339-6EB13E375BA4> /System/Library/PrivateFrameworks/WirelessDiagnostics.framework/Versions/A/Libraries/libprotobuf.dylib
    0x7fff576b5000 -     0x7fff576f6ff7  com.apple.awd (1.0 - 930.11) <652A1F08-52A3-36CC-8055-EF57143BED76> /System/Library/PrivateFrameworks/WirelessDiagnostics.framework/Versions/A/WirelessDiagnostics
    0x7fff5776a000 -     0x7fff5776dfff  com.apple.dt.XCTTargetBootstrap (1.0 - 14490.66) <7AE3457F-AF40-3508-93FB-1D9E31EB1C9D> /System/Library/PrivateFrameworks/XCTTargetBootstrap.framework/Versions/A/XCTTargetBootstrap
    0x7fff57b6e000 -     0x7fff57b70ffb  com.apple.loginsupport (1.0 - 1) <3F8D6334-BCD6-36C1-BA20-CC8503A84375> /System/Library/PrivateFrameworks/login.framework/Versions/A/Frameworks/loginsupport.framework/Versions/A/loginsupport
    0x7fff57b71000 -     0x7fff57b86fff  com.apple.login (3.0 - 3.0) <E168F05D-A5DF-3848-8686-DF5015EA4BA4> /System/Library/PrivateFrameworks/login.framework/Versions/A/login
    0x7fff57bbd000 -     0x7fff57beeffb  com.apple.contacts.vCard (1.0 - ???) <651AD944-66CA-3408-818F-484E0F53A1DE> /System/Library/PrivateFrameworks/vCard.framework/Versions/A/vCard
    0x7fff57daa000 -     0x7fff57dbeffb  libAccessibility.dylib (2402.95) <6BC07631-25B1-3C31-A2CB-E5E477836A5E> /usr/lib/libAccessibility.dylib
    0x7fff57e3a000 -     0x7fff57e6efff  libCRFSuite.dylib (41.15.4) <406DAC06-0C77-3F90-878B-4D38F11F0256> /usr/lib/libCRFSuite.dylib
    0x7fff57e71000 -     0x7fff57e7bff7  libChineseTokenizer.dylib (28.15.3) <9B7F6109-3A5D-3641-9A7E-31D2239D73EE> /usr/lib/libChineseTokenizer.dylib
    0x7fff57e7c000 -     0x7fff57f05fff  libCoreStorage.dylib (546.50.1) <8E643B27-7986-3351-B37E-038FB6794BF9> /usr/lib/libCoreStorage.dylib
    0x7fff57f09000 -     0x7fff57f0affb  libDiagnosticMessagesClient.dylib (107) <A14D0819-0970-34CD-8680-80E4D7FE8C2C> /usr/lib/libDiagnosticMessagesClient.dylib
    0x7fff57f41000 -     0x7fff58198ff3  libFosl_dynamic.dylib (18.3.4) <1B5DD4E2-8AE0-315E-829E-D5BFCD264EA8> /usr/lib/libFosl_dynamic.dylib
    0x7fff581b8000 -     0x7fff581bffff  libMatch.1.dylib (31.200.1) <EF8164CB-B599-39D9-9E73-4958A372DC0B> /usr/lib/libMatch.1.dylib
    0x7fff581e9000 -     0x7fff58208fff  libMobileGestalt.dylib (645.270.1) <99A06C8A-97D6-383D-862C-F453BABB48A4> /usr/lib/libMobileGestalt.dylib
    0x7fff58209000 -     0x7fff58209fff  libOpenScriptingUtil.dylib (179.1) <4D603146-EDA5-3A74-9FF8-4F75D8BB9BC6> /usr/lib/libOpenScriptingUtil.dylib
    0x7fff58349000 -     0x7fff5834affb  libSystem.B.dylib (1252.250.1) <B1006948-7AD0-3CA9-81E0-833F4DD6BFB4> /usr/lib/libSystem.B.dylib
    0x7fff5834b000 -     0x7fff583c5ff7  libTelephonyUtilDynamic.dylib (3705) <155194D3-2B24-3A5F-9C04-364E0D583C60> /usr/lib/libTelephonyUtilDynamic.dylib
    0x7fff583c6000 -     0x7fff583c7fff  libThaiTokenizer.dylib (2.15.1) <ADB37DC3-7D9B-3E73-A72A-BCC3433C937A> /usr/lib/libThaiTokenizer.dylib
    0x7fff583d9000 -     0x7fff583efffb  libapple_nghttp2.dylib (1.24.1) <6F04250A-6686-3FDC-9A8D-290C64B06502> /usr/lib/libapple_nghttp2.dylib
    0x7fff583f0000 -     0x7fff58419ffb  libarchive.2.dylib (54.250.1) <47289946-8504-3966-9127-6CE39993DC2C> /usr/lib/libarchive.2.dylib
    0x7fff5841a000 -     0x7fff58499fff  libate.dylib (1.13.8) <92B44EDB-369D-3EE8-AEC5-61F8B9313DBF> /usr/lib/libate.dylib
    0x7fff5849d000 -     0x7fff5849dff3  libauto.dylib (187) <3E3780E1-96F3-3A22-91C5-92F9A5805518> /usr/lib/libauto.dylib
    0x7fff5849e000 -     0x7fff5856cfff  libboringssl.dylib (109.250.2) <8044BBB7-F6E0-36C1-95D1-9C2AB19CF94A> /usr/lib/libboringssl.dylib
    0x7fff5856d000 -     0x7fff5857dffb  libbsm.0.dylib (39.200.18) <CF381E0B-025B-364F-A83D-2527E03F1AA3> /usr/lib/libbsm.0.dylib
    0x7fff5857e000 -     0x7fff5858bfff  libbz2.1.0.dylib (38.200.3) <272953A1-8D36-329B-BDDB-E887B347710F> /usr/lib/libbz2.1.0.dylib
    0x7fff5858c000 -     0x7fff585dfff7  libc++.1.dylib (400.9.4) <9A60A190-6C34-339F-BB3D-AACE942009A4> /usr/lib/libc++.1.dylib
    0x7fff585e0000 -     0x7fff585f5ff7  libc++abi.dylib (400.17) <38C09CED-9090-3719-90F3-04A2749F5428> /usr/lib/libc++abi.dylib
    0x7fff585f6000 -     0x7fff585f6ff3  libcharset.1.dylib (51.200.6) <2A27E064-314C-359C-93FC-8A9B06206174> /usr/lib/libcharset.1.dylib
    0x7fff585f7000 -     0x7fff58607ffb  libcmph.dylib (6.15.1) <9C52B2FE-179F-32AC-B87E-2AFC49ABF817> /usr/lib/libcmph.dylib
    0x7fff58608000 -     0x7fff58620ffb  libcompression.dylib (52.250.2) <7F4BB18C-1FB4-3825-8D8B-6E6B168774C6> /usr/lib/libcompression.dylib
    0x7fff58895000 -     0x7fff588abfff  libcoretls.dylib (155.220.1) <4C64BE3E-41E3-3020-8BB7-07E90C0C861C> /usr/lib/libcoretls.dylib
    0x7fff588ac000 -     0x7fff588adff3  libcoretls_cfhelpers.dylib (155.220.1) <0959B3E9-6643-3589-8BB3-21D52CDF0EF1> /usr/lib/libcoretls_cfhelpers.dylib
    0x7fff58a4b000 -     0x7fff58b43ff7  libcrypto.35.dylib (22.260.1) <91C3D71A-4D1D-331D-89CC-67863DF10574> /usr/lib/libcrypto.35.dylib
    0x7fff58d46000 -     0x7fff58d51ff7  libcsfde.dylib (546.50.1) <7BAF8FCF-33A1-3C7C-8FEB-2020C8ED6063> /usr/lib/libcsfde.dylib
    0x7fff58d59000 -     0x7fff58dafff3  libcups.2.dylib (462.12) <095619DC-9233-3937-9E50-5F10D917A40D> /usr/lib/libcups.2.dylib
    0x7fff58ee3000 -     0x7fff58ee3fff  libenergytrace.dylib (17.200.1) <80BB567A-FD18-3497-BF97-353F57D98CDD> /usr/lib/libenergytrace.dylib
    0x7fff58f15000 -     0x7fff58f1aff7  libgermantok.dylib (17.15.2) <E5F0F794-FF27-3D64-AE52-C78C6A84DD67> /usr/lib/libgermantok.dylib
    0x7fff58f1b000 -     0x7fff58f20ff7  libheimdal-asn1.dylib (520.270.1) <73F60D6F-76F8-35EF-9C86-9A81225EE4BE> /usr/lib/libheimdal-asn1.dylib
    0x7fff58f4b000 -     0x7fff5903bfff  libiconv.2.dylib (51.200.6) <2047C9B7-3F74-3A95-810D-2ED8F0475A99> /usr/lib/libiconv.2.dylib
    0x7fff5903c000 -     0x7fff5929dffb  libicucore.A.dylib (62141.0.1) <A0D63918-76E9-3C1B-B255-46F4C1DA7FE8> /usr/lib/libicucore.A.dylib
    0x7fff592ea000 -     0x7fff592ebfff  liblangid.dylib (128.15.1) <22D05C4F-769B-3075-ABCF-44A0EBACE028> /usr/lib/liblangid.dylib
    0x7fff592ec000 -     0x7fff59304ff3  liblzma.5.dylib (10.200.3) <E1F4FD60-1CE4-37B9-AD95-29D348AF1AC0> /usr/lib/liblzma.5.dylib
    0x7fff5931c000 -     0x7fff593c0ff7  libmecab.1.0.0.dylib (779.24.1) <A8D0379B-85FA-3B3D-89ED-5CF2C3826AB2> /usr/lib/libmecab.1.0.0.dylib
    0x7fff593c1000 -     0x7fff595c5fff  libmecabra.dylib (779.24.1) <D71F71E0-30E2-3DB3-B636-7DE13D51FB4B> /usr/lib/libmecabra.dylib
    0x7fff5979d000 -     0x7fff59aeeff7  libnetwork.dylib (1229.250.15) <72C7E9E3-B2BE-3300-BE1B-64606222022C> /usr/lib/libnetwork.dylib
    0x7fff59b80000 -     0x7fff5a305fdf  libobjc.A.dylib (756.2) <7C312627-43CB-3234-9324-4DEA92D59F50> /usr/lib/libobjc.A.dylib
    0x7fff5a317000 -     0x7fff5a31bffb  libpam.2.dylib (22.200.1) <586CF87F-349C-393D-AEEB-FB75F94A5EB7> /usr/lib/libpam.2.dylib
    0x7fff5a31e000 -     0x7fff5a353fff  libpcap.A.dylib (79.250.1) <C0893641-7DFF-3A33-BDAE-190FF54837E8> /usr/lib/libpcap.A.dylib
    0x7fff5a46c000 -     0x7fff5a484ffb  libresolv.9.dylib (65.200.2) <893142A5-F153-3437-A22D-407EE542B5C5> /usr/lib/libresolv.9.dylib
    0x7fff5a486000 -     0x7fff5a4c1ff3  libsandbox.1.dylib (851.270.1) <04B924EF-2385-34DF-807E-93AAD9EF3AAB> /usr/lib/libsandbox.1.dylib
    0x7fff5a4c2000 -     0x7fff5a4d4ff7  libsasl2.2.dylib (211) <10987614-6763-3B5D-9F28-91D121BB4924> /usr/lib/libsasl2.2.dylib
    0x7fff5a4d5000 -     0x7fff5a4d6ff7  libspindump.dylib (267.3) <A584E403-8C95-3841-9C16-E22664A5A63F> /usr/lib/libspindump.dylib
    0x7fff5a4d7000 -     0x7fff5a6b4fff  libsqlite3.dylib (274.26) <6404BA3B-BCA4-301F-B2FE-8776105A2AA3> /usr/lib/libsqlite3.dylib
    0x7fff5a823000 -     0x7fff5a853ffb  libtidy.A.dylib (16.4) <6BDC3816-F222-33B6-848C-D8D5924E8959> /usr/lib/libtidy.A.dylib
    0x7fff5a86d000 -     0x7fff5a8ccffb  libusrtcp.dylib (1229.250.15) <36BBD474-FAE5-366F-946D-16C5C4B4A792> /usr/lib/libusrtcp.dylib
    0x7fff5a8cd000 -     0x7fff5a8d0ff7  libutil.dylib (51.200.4) <CE9B18C9-66ED-32D4-9D29-01F8FCB467B0> /usr/lib/libutil.dylib
    0x7fff5a8d1000 -     0x7fff5a8defff  libxar.1.dylib (417.1) <39CCF46B-C81A-34B1-92A1-58C4E5DA846E> /usr/lib/libxar.1.dylib
    0x7fff5a8e3000 -     0x7fff5a9c5ff3  libxml2.2.dylib (32.10) <AA4E1B1F-0FDE-3274-9FA5-75446298D1AC> /usr/lib/libxml2.2.dylib
    0x7fff5a9c6000 -     0x7fff5a9eeff3  libxslt.1.dylib (16.5) <E330D3A2-E32B-378A-973E-A8D245C0F712> /usr/lib/libxslt.1.dylib
    0x7fff5a9ef000 -     0x7fff5aa01ff7  libz.1.dylib (70.200.4) <B048FC1F-058F-3A08-A1FE-81D5308CB3E6> /usr/lib/libz.1.dylib
    0x7fff5aa2f000 -     0x7fff5aa30ffb  liblog_network.dylib (1229.250.15) <C9C042D5-C018-3FB6-AC50-F11F44F3D815> /usr/lib/log/liblog_network.dylib
    0x7fff5aa84000 -     0x7fff5aa97ff3  libswiftAppKit.dylib (??? - ???) <390B2331-342E-367F-9308-01447A4442E6> /usr/lib/swift/libswiftAppKit.dylib
    0x7fff5aa98000 -     0x7fff5aaa9ff7  libswiftCloudKit.dylib (??? - ???) <B18B0254-A732-3CB1-ACEF-4A7D6401CE9E> /usr/lib/swift/libswiftCloudKit.dylib
    0x7fff5aaaa000 -     0x7fff5aaafff3  libswiftContacts.dylib (??? - ???) <276B94CF-7FE0-37C2-B1E4-A2F7047CF7B9> /usr/lib/swift/libswiftContacts.dylib
    0x7fff5aab0000 -     0x7fff5ae21ff7  libswiftCore.dylib (5.0 - 1001.8.63.13) <4FE40B7B-1413-3A25-959B-D78B78682D12> /usr/lib/swift/libswiftCore.dylib
    0x7fff5ae28000 -     0x7fff5ae2fffb  libswiftCoreData.dylib (??? - ???) <7D7D21CE-8F68-390F-BE47-2AB1DC0439ED> /usr/lib/swift/libswiftCoreData.dylib
    0x7fff5ae30000 -     0x7fff5ae32ff3  libswiftCoreFoundation.dylib (??? - ???) <3192FF82-E322-3B09-805F-6AEB48C00478> /usr/lib/swift/libswiftCoreFoundation.dylib
    0x7fff5ae33000 -     0x7fff5ae41ff3  libswiftCoreGraphics.dylib (??? - ???) <FEFE340D-865B-3C8C-AF13-AB1DE8866C01> /usr/lib/swift/libswiftCoreGraphics.dylib
    0x7fff5ae42000 -     0x7fff5ae45ffb  libswiftCoreImage.dylib (??? - ???) <4AC0B024-190B-31F8-8EC5-C9E2761C580E> /usr/lib/swift/libswiftCoreImage.dylib
    0x7fff5ae46000 -     0x7fff5ae4afff  libswiftCoreLocation.dylib (??? - ???) <601B6BF4-B840-3D74-8C9D-143A12076164> /usr/lib/swift/libswiftCoreLocation.dylib
    0x7fff5ae58000 -     0x7fff5ae5effb  libswiftDarwin.dylib (??? - ???) <FD515CE3-A057-36EC-A787-E78F773973F3> /usr/lib/swift/libswiftDarwin.dylib
    0x7fff5ae5f000 -     0x7fff5ae75fff  libswiftDispatch.dylib (??? - ???) <40AA9542-FE66-37F0-B0BE-70C8D057488C> /usr/lib/swift/libswiftDispatch.dylib
    0x7fff5ae76000 -     0x7fff5b007ff7  libswiftFoundation.dylib (??? - ???) <A24C3092-3B6D-3680-945E-292A0D31436F> /usr/lib/swift/libswiftFoundation.dylib
    0x7fff5b016000 -     0x7fff5b018ff3  libswiftIOKit.dylib (??? - ???) <C7E2E0F9-D04C-348E-A5B6-DD59A9F40BDD> /usr/lib/swift/libswiftIOKit.dylib
    0x7fff5b026000 -     0x7fff5b02dfff  libswiftMetal.dylib (??? - ???) <03736BFF-B1E4-32FB-B3C3-12FFF7681854> /usr/lib/swift/libswiftMetal.dylib
    0x7fff5b06f000 -     0x7fff5b072ff7  libswiftObjectiveC.dylib (??? - ???) <A4201F26-A2B3-3F2A-8B0F-D17F166C26BC> /usr/lib/swift/libswiftObjectiveC.dylib
    0x7fff5b07d000 -     0x7fff5b082ffb  libswiftQuartzCore.dylib (??? - ???) <FB83F05B-766E-3211-8CC7-E8B634B34BA0> /usr/lib/swift/libswiftQuartzCore.dylib
    0x7fff5b1ba000 -     0x7fff5b1bcffb  libswiftXPC.dylib (??? - ???) <61CDCF0E-FFD3-31FD-A6B1-175B06EA6659> /usr/lib/swift/libswiftXPC.dylib
    0x7fff5b1e5000 -     0x7fff5b1e9ff3  libcache.dylib (81) <1987D1E1-DB11-3291-B12A-EBD55848E02D> /usr/lib/system/libcache.dylib
    0x7fff5b1ea000 -     0x7fff5b1f4ff3  libcommonCrypto.dylib (60118.250.2) <1765BB6E-6784-3653-B16B-CB839721DC9A> /usr/lib/system/libcommonCrypto.dylib
    0x7fff5b1f5000 -     0x7fff5b1fcff7  libcompiler_rt.dylib (63.4) <5212BA7B-B7EA-37B4-AF6E-AC4F507EDFB8> /usr/lib/system/libcompiler_rt.dylib
    0x7fff5b1fd000 -     0x7fff5b206ff7  libcopyfile.dylib (146.250.1) <98CD00CD-9B91-3B5C-A9DB-842638050FA8> /usr/lib/system/libcopyfile.dylib
    0x7fff5b207000 -     0x7fff5b28bfc3  libcorecrypto.dylib (602.260.2) <01464D24-570C-3B83-9D18-467769E0FCDD> /usr/lib/system/libcorecrypto.dylib
    0x7fff5b312000 -     0x7fff5b34bff7  libdispatch.dylib (1008.270.1) <97273678-E94C-3C8C-89F6-2E2020F4B43B> /usr/lib/system/libdispatch.dylib
    0x7fff5b34c000 -     0x7fff5b378ff7  libdyld.dylib (655.1.1) <002418CC-AD11-3D10-865B-015591D24E6C> /usr/lib/system/libdyld.dylib
    0x7fff5b379000 -     0x7fff5b379ffb  libkeymgr.dylib (30) <0D0F9CA2-8D5A-3273-8723-59987B5827F2> /usr/lib/system/libkeymgr.dylib
    0x7fff5b37a000 -     0x7fff5b386ff3  libkxld.dylib (4903.271.2) <FBF128C8-D3F0-36B6-983A-A63B8A3E0E52> /usr/lib/system/libkxld.dylib
    0x7fff5b387000 -     0x7fff5b387ff7  liblaunch.dylib (1336.261.2) <2B07E27E-D404-3E98-9D28-BCA641E5C479> /usr/lib/system/liblaunch.dylib
    0x7fff5b388000 -     0x7fff5b38dfff  libmacho.dylib (927.0.3) <A377D608-77AB-3F6E-90F0-B4F251A5C12F> /usr/lib/system/libmacho.dylib
    0x7fff5b38e000 -     0x7fff5b390ffb  libquarantine.dylib (86.220.1) <6D0BC770-7348-3608-9254-F7FFBD347634> /usr/lib/system/libquarantine.dylib
    0x7fff5b391000 -     0x7fff5b392ff7  libremovefile.dylib (45.200.2) <9FBEB2FF-EEBE-31BC-BCFC-C71F8D0E99B6> /usr/lib/system/libremovefile.dylib
    0x7fff5b393000 -     0x7fff5b3aaff3  libsystem_asl.dylib (356.200.4) <A62A7249-38B8-33FA-9875-F1852590796C> /usr/lib/system/libsystem_asl.dylib
    0x7fff5b3ab000 -     0x7fff5b3abff7  libsystem_blocks.dylib (73) <A453E8EE-860D-3CED-B5DC-BE54E9DB4348> /usr/lib/system/libsystem_blocks.dylib
    0x7fff5b3ac000 -     0x7fff5b433fff  libsystem_c.dylib (1272.250.1) <7EDACF78-2FA3-35B8-B051-D70475A35117> /usr/lib/system/libsystem_c.dylib
    0x7fff5b434000 -     0x7fff5b437ffb  libsystem_configuration.dylib (963.270.3) <2B4A836D-68A4-33E6-8D48-CD4486B03387> /usr/lib/system/libsystem_configuration.dylib
    0x7fff5b438000 -     0x7fff5b43bff7  libsystem_coreservices.dylib (66) <719F75A4-74C5-3BA6-A09E-0C5A3E5889D7> /usr/lib/system/libsystem_coreservices.dylib
    0x7fff5b43c000 -     0x7fff5b442fff  libsystem_darwin.dylib (1272.250.1) <EC9B39A5-9592-3577-8997-7DC721D20D8C> /usr/lib/system/libsystem_darwin.dylib
    0x7fff5b443000 -     0x7fff5b449ff7  libsystem_dnssd.dylib (878.270.2) <E9A5ACCF-E35F-3909-AF0A-2A37CD217276> /usr/lib/system/libsystem_dnssd.dylib
    0x7fff5b44a000 -     0x7fff5b495ffb  libsystem_info.dylib (517.200.9) <D09D5AE0-2FDC-3A6D-93EC-729F931B1457> /usr/lib/system/libsystem_info.dylib
    0x7fff5b496000 -     0x7fff5b4beff7  libsystem_kernel.dylib (4903.271.2) <EA204E3C-870B-30DD-B4AF-D1BB66420D14> /usr/lib/system/libsystem_kernel.dylib
    0x7fff5b4bf000 -     0x7fff5b50aff7  libsystem_m.dylib (3158.200.7) <F19B6DB7-014F-3820-831F-389CCDA06EF6> /usr/lib/system/libsystem_m.dylib
    0x7fff5b50b000 -     0x7fff5b535fff  libsystem_malloc.dylib (166.270.1) <011F3AD0-8E6A-3A89-AE64-6E5F6840F30A> /usr/lib/system/libsystem_malloc.dylib
    0x7fff5b536000 -     0x7fff5b540ff7  libsystem_networkextension.dylib (767.250.2) <FF06F13A-AEFE-3A27-A073-910EF78AEA36> /usr/lib/system/libsystem_networkextension.dylib
    0x7fff5b541000 -     0x7fff5b548fff  libsystem_notify.dylib (172.200.21) <145B5CFC-CF73-33CE-BD3D-E8DDE268FFDE> /usr/lib/system/libsystem_notify.dylib
    0x7fff5b549000 -     0x7fff5b552fef  libsystem_platform.dylib (177.270.1) <9D1FE5E4-EB7D-3B3F-A8D1-A96D9CF1348C> /usr/lib/system/libsystem_platform.dylib
    0x7fff5b553000 -     0x7fff5b55dff7  libsystem_pthread.dylib (330.250.2) <2D5C08FF-484F-3D59-9132-CE1DCB3F76D7> /usr/lib/system/libsystem_pthread.dylib
    0x7fff5b55e000 -     0x7fff5b561ff7  libsystem_sandbox.dylib (851.270.1) <9494594B-5199-3186-82AB-5FF8BED6EE16> /usr/lib/system/libsystem_sandbox.dylib
    0x7fff5b562000 -     0x7fff5b564ff3  libsystem_secinit.dylib (30.260.2) <EF1EA47B-7B22-35E8-BD9B-F7003DCB96AE> /usr/lib/system/libsystem_secinit.dylib
    0x7fff5b565000 -     0x7fff5b56cff3  libsystem_symptoms.dylib (820.267.1) <03F1C2DD-0F5A-3D9D-88F6-B26C0F94EB52> /usr/lib/system/libsystem_symptoms.dylib
    0x7fff5b56d000 -     0x7fff5b582fff  libsystem_trace.dylib (906.260.1) <FC761C3B-5434-3A52-912D-F1B15FAA8EB2> /usr/lib/system/libsystem_trace.dylib
    0x7fff5b584000 -     0x7fff5b589ffb  libunwind.dylib (35.4) <24A97A67-F017-3CFC-B0D0-6BD0224B1336> /usr/lib/system/libunwind.dylib
    0x7fff5b58a000 -     0x7fff5b5b9fff  libxpc.dylib (1336.261.2) <7DEE2300-6D8E-3C00-9C63-E3E80D56B0C4> /usr/lib/system/libxpc.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 395
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 152203
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=541.1M resident=0K(0%) swapped_out_or_unallocated=541.1M(100%)
Writable regions: Total=1.8G written=0K(0%) resident=0K(0%) swapped_out=0K(0%) unallocated=1.8G(100%)
 
                                VIRTUAL   REGION
REGION TYPE                        SIZE    COUNT (non-coalesced)
===========                     =======  =======
Accelerate framework              1024K        7
Activity Tracing                   256K        1
CG backing stores                 3632K        6
CG image                          5324K      106
CG raster data                      80K        2
CoreAnimation                      1.0G      838
CoreGraphics                         8K        1
CoreImage                          272K       42
CoreUI image data                 6888K       57
CoreUI image file                  304K        9
Foundation                          28K        2
IOKit                             15.5M        2
Image IO                            68K       11
Kernel Alloc Once                    8K        1
MALLOC                           453.2M      200
MALLOC guard page                   80K       17
MALLOC_LARGE (reserved)            128K        1         reserved VM address space (unallocated)
MALLOC_NANO (reserved)           256.0M        1         reserved VM address space (unallocated)
Memory Tag 242                      12K        1
Memory Tag 251                      12K        1
SQLite page cache                  320K        5
STACK GUARD                       56.1M       17
Stack                             16.6M       18
Stack Guard                          4K        1
VM_ALLOCATE                        224K       36
WebKit Malloc                     12.5M       21
__DATA                            47.4M      409
__FONT_DATA                          4K        1
__GLSLBUILTINS                    5176K        1
__LINKEDIT                       228.9M       38
__TEXT                           312.3M      410
__UNICODE                          564K        1
libnetwork                        1664K        6
mapped file                      183.1M       57
shared memory                      704K       19
===========                     =======  =======
TOTAL                              2.6G     2346
TOTAL, minus reserved VM space     2.4G     2346

Model: MacBookPro15,4, BootROM 1037.100.362.0.0 (iBridge: 17.16.14281.0.0,0), 4 processors, Intel Core i5, 1.4 GHz, 8 GB, SMC
Graphics: kHW_IntelIrisGraphics645Item, Intel Iris Plus Graphics 645, spdisplays_builtin
Memory Module: BANK 0/ChannelA-DIMM0, 4 GB, LPDDR3, 2133 MHz, Samsung, K4E6E304EC-EGCG
Memory Module: BANK 2/ChannelB-DIMM0, 4 GB, LPDDR3, 2133 MHz, Samsung, K4E6E304EC-EGCG
AirPort: AirPort Extreme, wl0: Apr 30 2019 18:57:15 version 16.30.198.0.3.6.64 FWID 01-ca8f39b2
Bluetooth: Version 6.0.14d3, 3 services, 27 devices, 1 incoming serial ports
Network Service: Wi-Fi, AirPort, en0
USB Device: USB 3.1 Bus
USB Device: iBridge Bus
USB Device: Touch Bar Backlight
USB Device: Touch Bar Display
USB Device: Apple Internal Keyboard / Trackpad
USB Device: Headset
USB Device: Ambient Light Sensor
USB Device: FaceTime HD Camera (Built-in)
USB Device: Apple T2 Controller
Thunderbolt Bus: MacBook Pro, Apple Inc., 41.12
</pre>
</body>
</html>
"""
        
        guard let data = html.data(using: .utf8) else {
            return nil
        }
        
        return NSAttributedString(html: data, documentAttributes: nil)
    }
}

//
//  CrashContent.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/19.
//

import Cocoa

/// 崩溃分析的每行内容
class CrashContent {
    /// 显示标题，只能是 string 或者 attributedString
    fileprivate(set) var title: Any = ""
    /// 显示的崩溃内容
    fileprivate(set) var content: String = ""
    /// 对应的原始数据
    fileprivate(set) var original: Any?
    /// 子列表
    fileprivate(set) var children: [CrashContent] = []

    /// 根据给定的参数初始化当前对象
    /// - Parameters:
    ///   - title: 显示标题名
    ///   - content: 显示的内容
    ///   - children: 子列表
    ///   - original: 原始数据
    fileprivate init(_ title: Any, content: String = "", children: [CrashContent] = [], original: Any? = nil) {
        self.title = title
        self.content = content
        self.children = children
        self.original = original
    }

    fileprivate init(_ name: String, json: Any, camelCase: Bool = false) {
        title = camelCase ? name.replacing(string: "_", target: " ").capitalized : name
        original = json

        if let json = json as? Dictionary<String, Any> {
            children = json.map({ CrashContent($0, json: $1, camelCase: camelCase) })
        } else if let json = json as? Array<Any> {
            children = json.enumerated().map({ CrashContent("\($0.offset)", json: $0.element, camelCase: camelCase) })
        } else {
            content = "\(json)"
            original = "\(json)"
        }
    }
}

/// 崩溃信息类，包含当前崩溃信息的基本信息和大包信息
class CrashAna {
    var content: CrashContent!
    var identifier: String!
    var version: String!
    var build: String!

    init(_ json: [String: Any], title: String, content: String) {
        let crash = CrashContent(title, content: content)
        crash.children = analysis(json: json)
        crash.original = json
        self.content = CrashContent("Analysis", content: "", children: [crash])
    }
}

private extension CrashAna {
    func analysis(json: [String: Any]) -> [CrashContent] {
        var items = [CrashContent]()

        if let lagType = json["lagType"] as? String {
            items.append(CrashContent("Lag Type", content: lagType))
        }

        if let user = json["user"] as? [String: Any] {
            items.append(CrashContent("User", json: user))
        }

        if let system = analysis(system: json["system"]) {
            items.append(system)
        }

        if let crash = analysis(crash: json["crash"]) {
            items.append(crash)
        }

        if let recrash = json["recrash_report"] as? [String: Any] {
            items.append(CrashContent("Recrash Report", content: "", children: analysis(json: recrash), original: recrash))
        }

        /// 对于卡顿，其内容是崩溃信息的列表
        if let lagContents = json["content"] as? [[String: Any]] {
            let children = lagContents.enumerated().map { (ind, lag) -> CrashContent in
                let child = CrashContent("\(ind)")
                child.children = analysis(json: lag)
                return child
            }
            items.append(CrashContent("Content", children: children))
        }

        if let binaries = analysis(binary_images: json["binary_images"]) {
            items.append(binaries)
        }

        return items
    }

    func analysis(system: Any?) -> CrashContent? {
        /// {
        ///     "binary_cpu_type": 16777223,
        ///     "app_uuid": "EE396B01-3C64-33E6-BFD1-26C2C41C0ED2",
        ///     "CFBundleName": "Tiger Trade",
        ///     "device_app_hash": "1faa2d1d01ba9ac8982a7a910bbd4e932079c0db",
        ///     "storage": 500068036608,
        ///     "memory": {
        ///         "free": 1605828608,
        ///         "size": 17179869184,
        ///         "usable": 15891288064
        ///     },
        ///     "cpu_type": 7,
        ///     "binary_cpu_subtype": 3,
        ///     "CFBundleExecutable": "Tiger Trade",
        ///     "cpu_subtype": 8,
        ///     "cpu_arch": "x86",
        ///     "jailbroken": false,
        ///     "build_type": "unknown",
        /// }

        guard let system = system as? [String: Any] else {
            return nil
        }

        var items = [CrashContent]()

        /// Process:               Tiger Trade [4338]
        /// "process_name": "Tiger Trade"
        /// "process_id": 22633
        if let process = system["process_name"],
            let pid = system["process_id"] {
            items.append(CrashContent("Process name", content: "\(process) [\(pid)]"))
        }

        /// "parent_process_id": 1
        if let parent = system["parent_process_id"] {
            items.append(CrashContent("Parent process", content: "??? \(parent)"))
        }

        /// Path:                  /Volumes/VOLUME/*/Tiger Trade.app/Contents/MacOS/Tiger Trade
        /// "CFBundleExecutablePath": "/Applications/Tiger Trade.app/Tiger Trade"
        if let path = system["CFBundleExecutablePath"] as? String {
            items.append(CrashContent("Path", content: path))
        }

        /// Identifier:            com.itiger.TigerTrade-Mac
        /// "CFBundleIdentifier": "com.itiger.TigerTrade-Mac",
        if let identifier = system["CFBundleIdentifier"] as? String {
            items.append(CrashContent("Identifier", content: identifier))
            self.identifier = identifier
        }

        /// Version:               5.10.0 (6B4D4C)
        /// "CFBundleShortVersionString": "5.10.0"
        /// "CFBundleVersion": "6B4D4C"
        if let version = system["CFBundleShortVersionString"] as? String,
            let build = system["CFBundleVersion"] as? String {
            items.append(CrashContent("Version", content: "\(version) (\(build)) (\(build.count > 6 ? "AppStore" : "官网"))"))
            self.version = version
            self.build = build
        }

        /// "boot_time": "2020-07-07T07:58:37Z",
        if let bootTime = system["boot_time"] as? String {
            items.append(CrashContent("Boot Time", content: bootTime))
        }

        /// "app_start_time": "2020-07-10T05:19:25Z"
        if let startTime = system["app_start_time"] as? String {
            items.append(CrashContent("App Start Time", content: startTime))
        }

        /// OS Version:            Mac OS X 10.15.1 (19B88)
        /// "system_version": "10.14.3"
        /// "system_name": "macOS",
        /// "os_version": "18D109"
        if let sysVersion = system["system_version"] as? String,
            let sysName = system["system_name"] as? String,
            let osVersion = system["os_version"] as? String {
            items.append(CrashContent("System Version", content: "\(sysName) \(sysVersion) (\(osVersion))"))
        }

        /// "machine": "MacBookPro11,5"
        if let machine = system["machine"] as? String {
            items.append(CrashContent("Machine", content: "\(machine)"))
        }

        /// "kernel_version": "Darwin Kernel Version 18.2.0: Thu Dec 20 20:46:53 PST 2018; root:xnu-4903.241.1~1/RELEASE_X86_64",
        if let kernel = system["kernel_version"] as? String {
            items.append(CrashContent("Kernel Version", content: kernel))
        }

        /// "time_zone": "GMT-7",
        if let timeZone = system["time_zone"] as? String {
            items.append(CrashContent("Time Zone", content: timeZone))
        }

        if let appstat = analysis(appStat: system["application_stats"]) {
            items.append(appstat)
        }

        if items.count == 0 {
            return nil
        }

        return CrashContent("System", children: items, original: system)
    }

    func analysis(appStat: Any?) -> CrashContent? {
        /// "application_stats": {
        ///     "background_time_since_last_crash": 0,
        ///     "active_time_since_launch": 9639.38,
        ///     "app_launch_time": 1594358365,
        ///     "sessions_since_last_crash": 50,
        ///     "launches_since_last_crash": 50,
        ///     "active_time_since_last_crash": 9639.38,
        ///     "sessions_since_launch": 1,
        ///     "application_active": true,
        ///     "application_in_foreground": true,
        ///     "background_time_since_launch": 0
        /// }

        guard let appStat = appStat as? [String: Any] else {
            return nil
        }

        return CrashContent("Application stats", json: appStat, camelCase: true)
    }

    func analysis(binary_images: Any?) -> CrashContent? {
        /// {
        ///     "major_version": 0,
        ///     "revision_version": 0,
        ///     "cpu_subtype": 3,
        ///     "uuid": "EE396B01-3C64-33E6-BFD1-26C2C41C0ED2",
        ///     "image_vmaddr": 4294967296,
        ///     "image_addr": 4515446784,
        ///     "image_size": 4370432,
        ///     "minor_version": 0,
        ///     "name": "/Applications/Tiger Trade.app/Contents/MacOS/Tiger Trade",
        ///     "cpu_type": 16777223
        /// }

        guard let binary_images = binary_images as? [[String: Any]] else {
            return nil
        }

        var items = [CrashContent]()

        for image in binary_images {
            guard
                let major = image["major_version"],
                let uuid = image["uuid"] as? String,
                let minor = image["minor_version"],
                let name = image["name"] as? String
            else {
                continue
            }

            guard let frameName = name.lastPathComponent else {
                continue
            }

            let iname = "\(frameName) (\(minor) - \(major))"
            items.append(CrashContent(iname, content: "\(name) <\(uuid)>", original: image))
        }

        if items.count == 0 {
            return nil
        }

        return CrashContent("Binary images", children: items, original: binary_images)
    }

    func analysis(crash: Any?) -> CrashContent? {
        guard let crash = crash as? [String: Any] else {
            return nil
        }

        let item = CrashContent("Crash", original: crash)

        if let diagnosis = crash["diagnosis"] as? String {
            item.children.append(CrashContent("Diagnosis", content: diagnosis.replacing(string: "\n", target: " ")))
        }

        if let error = analysis(error: crash["error"]) {
            item.children.append(error)
        }

        if let threads = analysis(threads: crash["threads"]) {
            item.children.append(threads)
        }

        return item
    }

    func analysis(error: Any?) -> CrashContent? {
        /// {
        ///     "mach": {
        ///         "code": 8,
        ///         "exception_name": "EXC_BAD_ACCESS",
        ///         "subcode": 8,
        ///         "exception": 1,
        ///         "code_name": "KERN_NO_ACCESS"
        ///     },
        ///     "signal": {
        ///         "code": 0,
        ///         "name": "SIGBUS",
        ///         "signal": 10,
        ///         "code_name": "BUS_NOOP"
        ///     },
        ///     "type": "mach",
        ///     "address": 8
        /// }

        guard let error = error as? [String: Any] else {
            return nil
        }

        return CrashContent("Error", json: error)
//        Exception Type:        EXC_CRASH (SIGABRT)
//        Exception Codes:       0x0000000000000000, 0x0000000000000000
//        Exception Note:        EXC_CORPSE_NOTIFY
    }

    func analysis(threads: Any?) -> CrashContent? {
        guard let threads = threads as? [[String: Any]] else {
            return nil
        }

        return CrashContent("Threads", children: threads.map({ analysis(thread: $0) }), original: threads)
    }

    func analysis(thread: [String: Any]) -> CrashContent {
        var title = "Thread".colored()

        if let index = thread["index"] {
            title = title ++ " \(index)"
        }

        if let crashed = thread["crashed"] as? Bool {
            if crashed {
                title = title ++ " Crashed".attributed(with: [.foregroundColor: NSColor.red, .font: NSFont.boldSystemFont(ofSize: 15)])
            }
        }

        if let current = thread["current"] as? Bool {
            if current {
                title = title ++ " (Current)".highlighted
            }
        }

        let item = CrashContent(title, original: thread)

        if let name = thread["name"] as? String {
            item.content = name
        }

        if let backtrace = thread["backtrace"] as? [String: Any] {
            if let contents = backtrace["contents"] as? [[String: Any]] {
                for content in contents {
                    if let bc = analysis(backtrace: content) {
                        item.children.append(bc)
                    }
                }
            }
        }

        if let notableAddress = thread["notable_addresses"] as? [String: Any] {
            item.children.append(CrashContent("notable_addresses", json: notableAddress))
        }

        return item
    }

    func analysis(backtrace: [String: Any]) -> CrashContent? {
        /// {
        ///     "symbol_name": "__semwait_signal",
        ///     "symbol_addr": 140735014149796,
        ///     "instruction_addr": 140735014149806,
        ///     "object_name": "libsystem_kernel.dylib",
        ///     "object_addr": 140735014129664
        /// }

        guard
            let object = backtrace["object_name"] as? String,
            let symbolAddr = backtrace["symbol_addr"] as? uint64,
            let instructionAddr = backtrace["instruction_addr"] as? uint64 else {
            return nil
        }

        let symbolHex = symbolAddr.hexString(prefix: "0x")
        let instructionHex = instructionAddr.hexString(prefix: "0x")

        let content = "\(instructionHex) \(symbolHex) \(backtrace["symbol_name"] ?? "")"

        /// 0x00007FFF60CC6220
        /// 0x00007fff90420ebc
        return CrashContent(object, content: content, original: backtrace)
    }
}

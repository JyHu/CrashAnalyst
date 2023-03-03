//
//  dSYMModel.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/9/15.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Foundation

private let dsymPattern = "UUID:\\s+([\\w-]+)\\s+\\((\\w+)\\)\\s+(.+)$"

class ProjModel {
    var identifier: String = ""
    var dSYMs: [dSYMModel] = []
    
    init(_ identifier: String) {
        self.identifier = identifier
    }
}

enum Arch: String {
    case arm64
    case x86_64
    
    init?(rawValue: String) {
        if rawValue.uppercased().contains("X86") {
            self = .x86_64
        } else {
            self = .arm64
        }
    }
}

struct DwarfFile {
    var uuid: String
    var arch: Arch
    var file: String
    
    private var upperArch: String
    
    init(uuid: String, arch: String, file: String) {
        self.uuid = uuid
        self.arch = Arch(rawValue: arch) ?? .x86_64
        self.file = file
        self.upperArch = arch.uppercased()
    }
    
    func isMatch(_ arch: String) -> Bool {
        return arch.uppercased() == upperArch
    }
}

/// 存储dSYM信息的对象
class dSYMModel {
    /// 打包版本
    var version: String = ""

    /// 编译版本
    var build: String = ""

    /// app的id
    var identifier: String = ""

    /// 当前dSYM所在路径
    var path: String = ""

    /// dSYM文件所在的目录
    var location: String = ""

    /// 当前dSYM所在的归档文件所在路径
    var archiveUrl: URL?

    var dwarfFiles: [DwarfFile] = []

    /// 是否是外部引入进来的
    var isImported: Bool = false

    /// 创建日期
    var creationDateString: String? {
        if cachedCreationDateString == nil, let archiveInfo = archiveInfo {
            cachedCreationDateString = (archiveInfo["CreationDate"] as? Date)?.stringValue
        }

        return cachedCreationDateString
    }

    private var cachedCreationDateString: String?

    /// 归档文件的信息
    var archiveInfo: [String: Any]?

    /// 用于排序比较的key
    private var compareKey: String!

    /// 初始化方法
    /// - Parameters:
    ///   - url: dSYM文件地址
    ///   - imported: 是否是外部引入进来的
    init?(url: URL, imported: Bool = false) {
        /// dSYM文件中的配置信息文件
        let infoURL = url.appendingPathComponent("/Contents/Info.plist")

        guard
            let data = try? Data(contentsOf: infoURL),
            let info = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? Dictionary<String, Any>,
            let version = info[CFBundleShortVersionString] as? String,
            let build = info[CFBundleVersion] as? String,
            let identifier = (info[CFBundleIdentifier] as? String)?.replacing(string: "com.apple.xcode.dsym.", target: "")
        else {
            return nil
        }

        path = url.path
        location = url.deletingLastPathComponent().path

        isImported = imported
        self.version = version
        self.build = build
        self.identifier = identifier
        compareKey = "\(self.identifier)\(self.version)\(self.build)"
    }

    /// 解析当前dSYM文件中的arch uuid
    func dump() {
        guard
            let res = execute("dwarfdump --uuid \"\(path)\"") as? String,
            let reg = try? NSRegularExpression(pattern: dsymPattern, options: [.caseInsensitive, .anchorsMatchLines]) else {
            return
        }
        
        dwarfFiles = reg.matches(in: res).compactMap { checkingResult -> DwarfFile? in
            guard
                let uuid = res.sub(range: checkingResult.range(at: 1)),
                let arch = res.sub(range: checkingResult.range(at: 2)),
                let dpath = res.sub(range: checkingResult.range(at: 3)) else {
                return nil
            }
            
            return DwarfFile(uuid: uuid, arch: arch, file: dpath)
        }

        /// 获取cpu类型
        /// dwarfdump --uuid ~/Library/Developer/Xcode/Archives/2020-07-03/Stock-Mac-Release\ 2020-7-3\,\ 9.43\ PM.xcarchive/dSYMs/Tiger\ Trade.app.dSYM
        /// UUID: EE396B01-3C64-33E6-BFD1-26C2C41C0ED2 (x86_64) /Users/hujinyou/Library/Developer/Xcode/Archives/2020-07-03/Stock-Mac-Release 2020-7-3, 9.43 PM.xcarchive/dSYMs/Tiger Trade.app.dSYM/Contents/Resources/DWARF/Tiger Trade
    }

    /// 使用当前dSYM文件解析崩溃日志内存地址
    /// - Parameters:
    ///   - slideAddress: slide address
    ///   - crashAddress: crash address
    /// - Returns: 解析结果
    func analysis(slideAddress: String, crashAddress: String, arch: Arch) -> String? {
        if self.dwarfFiles.count == 0 {
            dump()
        }
        
        guard let dwarfFile = dwarfFiles.first(where: { $0.arch == arch }) else { return nil }
        
        return execute(
            "xcrun atos -arch \(arch.rawValue) -o \"\(dwarfFile.file)\" -l \(slideAddress) \(crashAddress)"
        ) as? String
    }

    /// 比较两个dSYM文件
    /// - Returns: 比较的结果
    func compare(with dSYM: dSYMModel) -> ComparisonResult {
        return dSYM.compareKey.compare(compareKey, options: .numeric)
    }
}

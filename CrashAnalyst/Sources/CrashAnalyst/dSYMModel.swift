//
//  dSYMModel.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/9/15.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Foundation

private let CFBundleShortVersionString = "CFBundleShortVersionString"
private let CFBundleVersion = "CFBundleVersion"
private let CFBundleIdentifier = "CFBundleIdentifier"


private let dsymPattern = "UUID:\\s+([\\w-]+)\\s+\\((\\w+)\\)\\s+(.+)$"

public class dSYMProjModel {
    public var bundleID: String = ""
    public var dSYMs: [dSYMModel] = []
    
    public init(_ identifier: String) {
        self.bundleID = identifier
    }
}

/// 存储dSYM信息的对象
public class dSYMModel {
    public enum Arch: String {
        case arm64
        case x86_64
        
        public init?(rawValue: String) {
            if rawValue.uppercased().contains("X86") {
                self = .x86_64
            } else {
                self = .arm64
            }
        }
    }
    
    public struct DwarfFile {
        public var uuid: String
        public var arch: Arch
        public var file: String
        
        private var upperArch: String
        
        public init(uuid: String, arch: String, file: String) {
            self.uuid = uuid
            self.arch = Arch(rawValue: arch) ?? .x86_64
            self.file = file
            self.upperArch = arch.uppercased()
        }
    }
    
    /// 打包版本
    public var version: String = ""
    
    /// 编译版本
    public var build: String = ""
    
    /// app的id
    public var bundleID: String = ""
    
    /// 当前dSYM所在路径
    public var path: String = ""
    
    /// dSYM文件所在的目录
    public var location: String = ""
    
    /// 当前dSYM所在的归档文件所在路径
    public var archiveUrl: URL?
    
    public var dwarfFiles: [DwarfFile] = []
    
    /// 创建日期
    public var creationDateString: String? {
        if cachedCreationDateString == nil, let archiveInfo = archiveInfo {
            cachedCreationDateString = (archiveInfo["CreationDate"] as? Date)?.ana_stringValue
        }
        
        return cachedCreationDateString
    }
    
    private var cachedCreationDateString: String?
    
    /// 归档文件的信息
    public var archiveInfo: [String: Any]?
    
    /// 唯一的ID
    public private(set) var uniqueID: String!
    
    /// 初始化方法
    /// - Parameters:
    ///   - url: dSYM文件地址
    public init?(url: URL) {
        func getDSYMFileURL() -> URL? {
            if url.pathExtension == String.ana_dSYM {
                return url
            }
            
            if url.pathExtension == String.ana_archive {
                let dSYMsPath = url.appendingPathComponent("dSYMs").path
                guard
                    FileManager.default.fileExists(atPath: dSYMsPath),
                    let dSYMFiles = try? FileManager.default.contentsOfDirectory(atPath: dSYMsPath),
                    let dSYMFile = dSYMFiles.first(where: { $0.hasSuffix("app.\(String.ana_dSYM)") })
                else {
                    return nil
                }
                
                return URL(fileURLWithPath: "\(dSYMsPath)/\(dSYMFile)")
            }
            
            return nil
        }
        
        guard let dSYMURL = getDSYMFileURL() else { return nil }
        
        /// dSYM文件中的配置信息文件
        let infoURL = dSYMURL.appendingPathComponent("/Contents/Info.plist")
        
        guard
            let data = try? Data(contentsOf: infoURL),
            let info = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? Dictionary<String, Any>,
            let version = info[CFBundleShortVersionString] as? String,
            let build = info[CFBundleVersion] as? String,
            let identifier = (info[CFBundleIdentifier] as? String)?.replacingOccurrences(of: "com.apple.xcode.dsym.", with: "")
        else {
            return nil
        }
        
        path = dSYMURL.path
        location = dSYMURL.deletingLastPathComponent().path
        
        self.version = version
        self.build = build
        self.bundleID = identifier
        uniqueID = "\(self.bundleID)\(self.version)\(self.build)"
    }
    
    /// 解析当前dSYM文件中的arch uuid
    func dump() {
        guard
            let res = ana_execute("dwarfdump --uuid \"\(path)\"") as? String,
            let reg = try? NSRegularExpression(pattern: dsymPattern, options: [.caseInsensitive, .anchorsMatchLines]) else {
            return
        }
        
        dwarfFiles = reg.matches(in: res, range: NSMakeRange(0, res.count)).compactMap { checkingResult -> DwarfFile? in
            guard
                let uuid = res.ana_sub(range: checkingResult.range(at: 1)),
                let arch = res.ana_sub(range: checkingResult.range(at: 2)),
                let dpath = res.ana_sub(range: checkingResult.range(at: 3)) else {
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
    public func analysis(slideAddress: String, crashAddress: String, arch: Arch) async -> String? {
        if self.dwarfFiles.count == 0 {
            dump()
        }
        
        guard let dwarfFile = dwarfFiles.first(where: { $0.arch == arch }) else { return nil }
        
        return ana_execute(
            "xcrun atos -arch \(arch.rawValue) -o \"\(dwarfFile.file)\" -l \(slideAddress) \(crashAddress)"
        ) as? String
    }
    
    /// 比较两个dSYM文件
    /// - Returns: 比较的结果
    public func sortCompare(with dSYM: dSYMModel) -> ComparisonResult {
        return dSYM.uniqueID.compare(uniqueID, options: .numeric)
    }
}

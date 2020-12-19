//
//  dSYMManager.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/9/13.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Cocoa

struct dSYMExtension {
    static let archive: String = "xcarchive"
    static let dSYM: String = "dSYM"
}

class dSYMManager {
    
    /// 获取单例
    static var shared = dSYMManager()
    
    /// 缓存的所有dsym
    private(set) var dSYMs: [dSYMModel] = []

    /// 刷新所有的归档的的SYM文件列表，外部引入的不管
    func reload() {
        dSYMs.removeAll(where: { $0.isImported ? !FileManager.default.fileExists(atPath: $0.path) : true })
        /// 加载本地Xcode归档的dsym
        loadArchives()
    }
    
    /// 根据给定的参数获取对应的dSYM文件
    /// - Parameters:
    ///   - bundleID: bundler identifier
    ///   - version: 版本号
    ///   - build: build号
    /// - Returns: 对应的dSYM Model对象，如果没有找到，就会返回nil
    func dSYMFrom(bundleID: String, version: String, build: String) -> dSYMModel? {
        guard let dSYM = dSYMs.first(where: {
            $0.identifier == bundleID && $0.version == version && $0.build == build
        }) else {
            return nil
        }
        
        /// 如果没有做过dump，就没有这俩字段
        if dSYM.uuid == nil || dSYM.arch == nil {
            dSYM.dump()
        }
        
        return dSYM
    }
    
    /// 根据给定的url添加对应的dSYM数据对象
    /// - Parameter url: 资源地址
    /// - Returns: 添加的dSYM对象
    func append(with url: URL) -> dSYMModel? {
        
        /// 根据Xcode的归档的数据添加dSYM
        if url.pathExtension == dSYMExtension.archive {
            return appendWith(archiveURL: url, imported: true)
        }
        
        /// 添加dSYM数据
        if url.pathExtension == dSYMExtension.dSYM {
            return appendWith(dSYMURL: url, imported: true)
        }
        
        return nil
    }
    
    /// 筛选url列表中的文件
    /// - Parameter urls: url列表，可以是各种类型，包括文件夹、dSYM、archive文件
    /// - Returns: 查找到的dSYM文件列表
    func pickup(at urls: [URL]) -> [dSYMModel] {
        var results: [dSYMModel] = []
        for url in urls {
            /// dSYM文件
            if url.pathExtension == dSYMExtension.dSYM {
                if let dSYM = appendWith(dSYMURL: url, imported: true) {
                    results.append(dSYM)
                }
            }
            /// archive文件
            else if url.pathExtension == dSYMExtension.archive {
                if let dSYM = appendWith(archiveURL: url, imported: true) {
                    results.append(dSYM)
                }
            }
            /// 文件夹
            else {
                results.append(contentsOf: enumerated(at: url, imported: true))
            }
        }
        
        return results
    }
}

private extension dSYMManager {
    
    /// 遍历本地Xcode归档数据，添加dSYM
    func loadArchives() {
        let archivesPath = NSHomeDirectory().appending("/Library/Developer/Xcode/Archives/")
        let url = URL(fileURLWithPath: archivesPath)
        let _ = enumerated(at: url)
        NotificationCenter.default.post(name: .dsymUpdated, object: nil)
    }
    
    
    /// 枚举当前目录下的所有dSYM文件
    /// - Parameters:
    ///   - url: 需要枚举的目录
    ///   - imported: 是否是外部引入的
    /// - Returns: dSYM文件列表
    func enumerated(at url: URL, imported: Bool = false) -> [dSYMModel] {
        
        /// 当前文件下遍历出来的 dSYM 文件列表
        var result: [dSYMModel] = []
        
        /// 文件枚举器
        let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.nameKey, .isDirectoryKey], options: .skipsHiddenFiles)
        
        /// 遍历文件
        for enumObj in enumerator!.enumerated() {
            /// 判断路径有效
            guard let fileURL = enumObj.element as? URL else {
                continue
            }

            /// 获取当前文件的属性
            guard let resources = try? fileURL.resourceValues(forKeys: [.nameKey, .isDirectoryKey]) else {
                continue
            }

            /// 获取名字、是否是文件夹
            guard let filename = resources.name,
                  let isDirectory = resources.isDirectory else {
                continue
            }
            
            /// 如果有 "_" 开头，是无效目录，直接跳过
            if filename.hasPrefix("_") && isDirectory {
                enumerator?.skipDescendants()
                continue
            }
            
            /// 如果不是目录，直接跳过
            if !isDirectory {
                continue
            }

            /// 如果文件包含 archive 后缀，说明文件有效，需要缓存下来
            if filename.hasSuffix(".\(dSYMExtension.archive)") {
                enumerator?.skipDescendants()
                /// 缓存 dSYM 文件
                if let dSYM = appendWith(archiveURL: fileURL, imported: imported) {
                    result.append(dSYM)
                }
            }
            /// 如果文件包含 dSYM 后缀，说明文件有效，需要缓存下来
            else if filename.hasSuffix(".\(dSYMExtension.dSYM)") {
                enumerator?.skipDescendents()
                if let dSYM = appendWith(dSYMURL: fileURL, imported: imported) {
                    result.append(dSYM)
                }
            }
        }
        
        return result
    }
    
    /// 缓存 archive 文件
    /// - Parameters:
    ///   - archiveURL: 文件地址
    ///   - imported: 是否是外部引入的
    /// - Returns: dSYM 文件
    func appendWith(archiveURL: URL, imported: Bool = false) -> dSYMModel? {
        let dSYMsPath = archiveURL.appendingPathComponent("dSYMs").path
        guard
            FileManager.default.fileExists(atPath: dSYMsPath),
            let dSYMFiles = try? FileManager.default.contentsOfDirectory(atPath: dSYMsPath),
            let dSYMFile = dSYMFiles.first(where: { $0.hasSuffix("app.\(dSYMExtension.dSYM)") })
        else {
            return nil
        }

        let dSYMUrl = URL(fileURLWithPath: "\(dSYMsPath)/\(dSYMFile)")
        let dSYM = appendWith(dSYMURL: dSYMUrl, imported: imported)
        dSYM?.archiveUrl = archiveURL
        return dSYM
    }
    
    /// 缓存 dSYM 文件
    /// - Parameters:
    ///   - dSYMURL: 文件地址
    ///   - imported: 是否是外部引入
    /// - Returns: dSYM 文件
    func appendWith(dSYMURL: URL, imported: Bool = false) -> dSYMModel? {
        if let dSYM = dSYMModel(url: dSYMURL, imported: imported) {
            return append(dSYM: dSYM)
        }
        
        return nil
    }
    
    /// 缓存一个有效的 dSYM 文件
    /// - Parameter dSYM: dSYM 文件
    /// - Returns: 缓存进来的文件
    func append(dSYM: dSYMModel) -> dSYMModel {
        dSYMs.append(dSYM)
        dSYMs.sort { (dSYM1, dSYM2) -> Bool in
            return dSYM1.compare(with: dSYM2) == .orderedAscending
        }
        return dSYM
    }
}

//
//  File.swift
//  
//
//  Created by Jo on 2023/3/5.
//

import Cocoa

public class CrashAnalyst {
    /// 获取单例
    public static var shared = CrashAnalyst()
    
    /// 缓存的所有dsym
    public private(set) var projs: [dSYMProjModel] = []
    
    /// 遍历本地Xcode归档数据，添加dSYM，只可在未开启沙盒的情况下用
    public func loadArchives() {
        let archivesPath = NSHomeDirectory().appending("/Library/Developer/Xcode/Archives/")
        let url = URL(fileURLWithPath: archivesPath)
        enumerated(at: url)
        NotificationCenter.default.post(name: CrashAnalyst.dSYMListUpdated, object: nil)
    }
    
    /// 根据给定的参数获取对应的dSYM文件
    /// - Parameters:
    ///   - bundleID: bundler identifier
    ///   - version: 版本号
    ///   - build: build号
    ///   - effective: 如果为true，在本地没有找到有效的dSYM的时候会弹出选择窗口让使用者主动选择一次
    /// - Returns: 对应的dSYM Model对象，如果没有找到，就会返回nil
    public func dSYMFrom(bundleID: String, version: String, build: String, effective: Bool = true) -> dSYMModel? {
        func findDSYM() -> dSYMModel? {
            guard let dSYM = projs.first(where: {
                $0.bundleID == bundleID
            })?.dSYMs.first(where: {
                $0.version == version && $0.build == build
            }) else {
                return nil
            }
            
            if dSYM.dwarfFiles.count == 0 {
                dSYM.dump()
            }
            
            return dSYM
        }
        
        if let dSYM = findDSYM() {
            return dSYM
        }
        
        guard effective else { return nil }
        
        /// 如果没有找到会让使用者主动选择一次，
        /// 如果使用者确定选择后会再次从本地查找一次
        if chooiceDSYM() == .OK {
            return findDSYM()
        }
        
        return nil
    }
    
    /// 打开选择窗口提供主动选择dSYM文件的操作，
    /// 如果用户确定选择了，在筛选后会发送一次通知出去
    ///
    /// 允许选择文件夹、文件、选择多个文件
    ///
    /// - Returns: 用户选择的结果
    @discardableResult public func chooiceDSYM() -> NSApplication.ModalResponse {
        let openPanel = NSOpenPanel()
        openPanel.title = "Chooice dSym files or  directory"
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.allowedFileTypes = [ .ana_archive, .ana_dSYM ]
        
        let response = openPanel.runModal()
        
        /// 如果用户没有确定选择，就直接返回结果
        if response != .OK { return response }
        
        /// 遍历选择的所有文件
        for url in openPanel.urls {
            /// dSYM文件
            if url.pathExtension == .ana_dSYM {
                _ = appendWith(dSYMURL: url)
            }
            /// archive文件
            else if url.pathExtension == .ana_archive {
                _ = appendWith(archiveURL: url)
            }
            /// 文件夹
            else {
                enumerated(at: url)
            }
        }
        
        /// 发送dSYM变动的通知
        NotificationCenter.default.post(name: CrashAnalyst.dSYMListUpdated, object: nil)
        
        return response
    }
    
    public func enumerate(folder: URL) {
        enumerated(at: folder)
    }
}

private extension CrashAnalyst {
    /// 枚举当前目录下的所有dSYM文件
    /// - Parameters:
    ///   - url: 需要枚举的目录
    ///   - imported: 是否是外部引入的
    func enumerated(at url: URL) {
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
            if filename.hasSuffix(".\(String.ana_archive)") {
                enumerator?.skipDescendants()
                /// 缓存 dSYM 文件
                appendWith(archiveURL: fileURL)
            }
            /// 如果文件包含 dSYM 后缀，说明文件有效，需要缓存下来
            else if filename.hasSuffix(".\(String.ana_dSYM)") {
                enumerator?.skipDescendents()
                appendWith(dSYMURL: fileURL)
            }
        }
    }
    
    /// 缓存 archive 文件
    /// - Parameters:
    ///   - archiveURL: 文件地址
    ///   - imported: 是否是外部引入的
    /// - Returns: dSYM 文件
    @discardableResult func appendWith(archiveURL: URL) -> dSYMModel? {
        let dSYMsPath = archiveURL.appendingPathComponent("dSYMs").path
        guard
            FileManager.default.fileExists(atPath: dSYMsPath),
            let dSYMFiles = try? FileManager.default.contentsOfDirectory(atPath: dSYMsPath),
            let dSYMFile = dSYMFiles.first(where: { $0.hasSuffix("app.\(String.ana_dSYM)") })
        else {
            return nil
        }
        
        /// 归档文件的信息
        let infoUrl = archiveURL.appendingPathComponent("Info.plist")
        let dSYMUrl = URL(fileURLWithPath: "\(dSYMsPath)/\(dSYMFile)")
        guard let dSYM = appendWith(dSYMURL: dSYMUrl) else { return nil }
        
        dSYM.archiveUrl = archiveURL
        
        if let data = try? Data(contentsOf: infoUrl),
           let info = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: Any] {
            dSYM.archiveInfo = info
        }
        
        return dSYM
    }
    
    /// 缓存 dSYM 文件
    /// - Parameters:
    ///   - dSYMURL: 文件地址
    ///   - imported: 是否是外部引入
    /// - Returns: dSYM 文件
    @discardableResult func appendWith(dSYMURL: URL) -> dSYMModel? {
        if let dSYM = dSYMModel(url: dSYMURL) {
            appendDSYM(dSYM)
        }
        
        return nil
    }
    
    @discardableResult func appendDSYM(_ dSYM: dSYMModel) -> dSYMModel? {
        var proj = projs.first(where: {
            $0.bundleID == dSYM.bundleID
        })
        
        if proj == nil {
            proj = dSYMProjModel(dSYM.bundleID)
            projs.append(proj!)
            projs.sort(by: { $0.bundleID < $1.bundleID })
        }
        
        if proj?.dSYMs.contains(where: { $0.uniqueID == dSYM.uniqueID }) ?? false {
            return nil
        }
        
        proj?.dSYMs.append(dSYM)
        proj?.dSYMs.sort { (dSYM1, dSYM2) -> Bool in
            dSYM1.sortCompare(with: dSYM2) == .orderedAscending
        }
        
        return dSYM
    }
    
    /// 根据给定的url添加对应的dSYM数据对象
    /// - Parameter url: 资源地址
    /// - Returns: 添加的dSYM对象
    @discardableResult func append(with url: URL) -> dSYMModel? {
        /// 根据Xcode的归档的数据添加dSYM
        if url.pathExtension == .ana_archive {
            return appendWith(archiveURL: url)
        }
        
        /// 添加dSYM数据
        if url.pathExtension == .ana_dSYM {
            return appendWith(dSYMURL: url)
        }
        
        return nil
    }
}

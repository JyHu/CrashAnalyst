//
//  Definitions.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Foundation

/// 崩溃分析类型
enum AnalysisType {
    case file       /// 分析崩溃文件
    case address    /// 分析崩溃日志地址
    case matrix     /// tencent matrix
}

enum MainTab {
    case dSYM
    case doc
}

/// 内部通知
extension NSNotification.Name {
    
    /// 切换崩溃分析类型，object为AnalysisType类型
    static let switchAnalysis = NSNotification.Name("com.auu.swichAnalysis.notification")
    
    /// 增加日志
    static let log = NSNotification.Name("com.auu.appendLog.notification")
    
    /// dSYM 文件更新
    static let dsymUpdated = NSNotification.Name("com.auu.dsymUpdated.notification")
    
    /// 切换右侧显示页面，object为MainTab类型
    static let switchMainTab = NSNotification.Name("com.auu.switchMainTab.notification")
}

let CFBundleShortVersionString = "CFBundleShortVersionString"
let CFBundleVersion = "CFBundleVersion"
let CFBundleIdentifier = "CFBundleIdentifier"

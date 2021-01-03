//
//  AlertHelper.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2021/1/3.
//

import Cocoa

extension NSAlert {
    
    /// 弹出提示
    /// - Parameters:
    ///   - message: 提示信息
    ///   - title: 提示标题
    static func display(_ message: String, title: String? = nil) {
        let alert = NSAlert()
        if let title = title {
            alert.messageText = title
        }
        alert.informativeText = message
        alert.window.titlebarAppearsTransparent = true
        let _ = alert.runModal()
    }
}

//
//  File.swift
//  
//
//  Created by Jo on 2023/3/5.
//

import Foundation

public extension CrashAnalyst {
    static let dSYMListUpdated = Notification.Name("com.auu.crash.analyst.listUpdated")
    static let log = Notification.Name("com.auu.crash.analyst.log")
}

internal func post(log: String) {
    NotificationCenter.default.post(name: CrashAnalyst.log, object: log)
}

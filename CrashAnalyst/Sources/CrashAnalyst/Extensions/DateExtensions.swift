//
//  File.swift
//  
//
//  Created by Jo on 2023/3/4.
//

import Foundation

private struct ANAFormatter {
    static var shared = ANAFormatter()
    private init() { }

    /// 日志时间的格式化对象
    lazy var logFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm:ss.ssss"
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()
}

extension Date {
    /// 转成本地时间的字符串
    var ana_stringValue: String {
        return ANAFormatter.shared.logFormatter.string(from: self)
    }
}


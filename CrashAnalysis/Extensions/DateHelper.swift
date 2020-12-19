//
//  DateHelper.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Foundation

private struct Formatter {
    static var shared = Formatter()
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
    
    /// 获取日志时间
    static var logDate: String {
        return Formatter.shared.logFormatter.string(from: Date())
    }
}

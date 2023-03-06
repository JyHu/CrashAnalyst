//
//  File.swift
//  
//
//  Created by Jo on 2023/3/4.
//

import Foundation

internal extension String {
    /// 归档文件后缀
    static let ana_archive = "xcarchive"
    
    /// dSYM文件后缀
    static let ana_dSYM = "dSYM"
}


internal extension String {
    /// 使用NSRange截取当前字符串中的一部分
    /// - Parameter range: 要截取的区间
    /// - Returns: 截取的字符串
    func ana_sub(range: NSRange) -> String? {
        if range.location == NSNotFound || range.location + range.length > self.count {
            return nil
        }
        
        let start = index(self.startIndex, offsetBy: range.location)
        let end = index(start, offsetBy: range.length)
        return String(self[start..<end])
    }
}

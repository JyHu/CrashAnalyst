//
//  StringHelper.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/7/17.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Cocoa

extension String {
    
    /// 获取字符串中对应位置的字符
    /// - Parameter index: 要获取的位置
    /// - Returns: 对应位置的字符
    func char(at index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    /// 使用NSRange截取当前字符串中的一部分
    /// - Parameter range: 要截取的区间
    /// - Returns: 截取的字符串
    func sub(range: NSRange) -> String? {
        if range.location == NSNotFound ||
            range.location + range.length > self.count {
            return nil
        }
        
        let start = index(self.startIndex, offsetBy: range.location)
        let end = index(start, offsetBy: range.length)
        return String(self[start..<end])
    }
    

    /// 获取当前字符串的range对象
    var rangeValue: Range<String.Index>! {
        return self.startIndex..<self.index(self.startIndex, offsetBy: self.count)
    }
    
    /// 替换当前字符串中的指定字符
    /// - Parameters:
    ///   - string: 要替换的字符串
    ///   - target: 要替换成的字符串
    ///   - options: 替换方式，默认字符串匹配方式
    /// - Returns: 替换后的字符串
    func replacing(string: String, target: String, options: NSString.CompareOptions = .caseInsensitive) -> String {
        return replacingOccurrences(of: string, with: target, options: options, range: rangeValue)
    }
    
    /// 掐头去尾的去掉空格
    var trimming: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// 将普通字符串转换成富文本
    /// - Parameter color: 富文本的颜色
    /// - Returns: 转换后的富文本
    func colored(_ color: NSColor? = nil) -> NSAttributedString {
        guard let color = color else {
            return NSAttributedString(string: self)
        }
        
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}

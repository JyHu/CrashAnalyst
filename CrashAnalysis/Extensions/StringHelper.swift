//
//  StringHelper.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/7/17.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Cocoa

/// 定义一个操作符
infix operator ++: LogicalDisjunctionPrecedence

extension NSAttributedString {
    
    /// 添加换行
    class var lineFeed: Self {
        return self.init(string: "\n")
    }
    
    /// 获取一个空的富文本字符串
    class var empty: NSAttributedString {
        return self.init(string: "")
    }
}

extension NSMutableAttributedString {
    
    /// 拼接一个字符串
    /// - Parameters:
    ///   - string: 要拼接的字符串
    ///   - attributes: 富文本属性
    func append(_ string: String?, attributes: [NSAttributedString.Key: Any] = [:]) {
        guard let string = string else {
            return
        }
        
        if attributes.count == 0 {
            append(string.colored())
        } else {
            append(string.attributed(with: attributes))
        }
    }
    
    /// 拼接一个换行符
    func appendLineFeed() {
        append(NSAttributedString.lineFeed)
    }
    
    /// 定义两个富文本拼接的操作符
    /// - Parameters:
    ///   - left: 左边原始字符串
    ///   - right: 右边随意的字符串，可以是string，或者attributedString
    /// - Returns: 拼接后的字符串
    static func ++(left: NSMutableAttributedString, right: Any) -> NSMutableAttributedString {
        if right is String {
            left.append(right as? String)
        } else if right is NSAttributedString {
            left.append(right as! NSAttributedString)
        } else {
            left.append("\(right)")
        }
        
        return left
    }
}



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
    func colored(_ color: NSColor? = nil) -> NSMutableAttributedString {
        let color = color ?? .textColor
        return NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    /// 添加自定义的富文本属性
    /// - Parameter attributes: 富文本属性列表
    /// - Returns: 处理后的富文本
    func attributed(with attributes: [NSAttributedString.Key: Any] = [:]) -> NSMutableAttributedString {
        if attributes.count == 0 {
            return NSMutableAttributedString(string: self)
        }
        
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    /// 字符串高亮，默认为红色
    var highlighted: NSMutableAttributedString {
        return colored(.red)
    }
    
    /// 添加次要的颜色
    var lowlighted: NSMutableAttributedString {
        return colored(.secondaryLabelColor)
    }
    
    /// 获取当前字符串的最后路径
    var lastPathComponent: String? {
        guard let range = self.range(of: "/", options: .backwards) else {
            return nil
        }
        
        
        return String(self[self.index(after: range.lowerBound)..<self.index(self.startIndex, offsetBy: self.count)])
    }
}

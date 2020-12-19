//
//  RegularExpressionHelper.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/7/18.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    
    /// 获取第一个匹配结果
    /// - Parameter string: 要匹配的字符串
    /// - Returns: 匹配结果
    func firstMatch(in string: String) -> NSTextCheckingResult? {
        return firstMatch(in: string,
                          options: .reportCompletion,
                          range: NSMakeRange(0, string.count))
    }
    
    /// 获取匹配结果
    /// - Parameter string: 要匹配的字符串
    /// - Returns: 匹配结果列表
    func matches(in string: String) -> [NSTextCheckingResult] {
        return matches(in: string,
                       options: .reportCompletion,
                       range: NSMakeRange(0, string.count))
    }
}

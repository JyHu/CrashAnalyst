//
//  IntHelper.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/8/6.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Foundation

private let lowerChar = "0123456789abcdef"
private let upperChar = "0123456789ABCDEF"

extension uint64 {
    
    /// 将uint64转成hex string
    /// - Parameters:
    ///   - prefix: 前缀，0x 0X 或者其他
    ///   - length: 限定长度，比如转换后的结果是 A44 ，需要显示成 0x00000A44 ，则限定长度为8即可，会自动的补0
    ///   - uppercase: hex string是否大写，
    /// - Returns: 转换后的 hex string 结果
    func hexString(prefix: String = "",
                   length: Int = 0,
                   uppercase: Bool = false) -> String {
        var hex = ""
        var num = self
        
        /// 将值转换成16进制的字符
        var getchar: Character {
            return (uppercase ? upperChar : lowerChar).char(at: Int(num % 16))
        }
        
        /// 限定转换结果长度，自动补0
        if length == 0 {
            while num != 0 {
                hex = "\(getchar)\(hex)"
                num /= 16
            }
        } else {
            var bit = 0
            while bit < 16 {
                hex = "\(getchar)\(hex)"
                bit += 1
                num /= 16
            }
        }
        
        return "\(prefix)\(hex)"
    }
}

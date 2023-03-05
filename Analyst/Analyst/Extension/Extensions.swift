//
//  Extensions.swift
//  Analyst
//
//  Created by Jo on 2023/3/5.
//

import Cocoa

private let lowerChar = "0123456789abcdef"
private let upperChar = "0123456789ABCDEF"

extension UInt64 {
    
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


extension String {
    /// 获取字符串中对应位置的字符
    /// - Parameter index: 要获取的位置
    /// - Returns: 对应位置的字符
    func char(at index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    /// 将普通字符串转换成富文本
    /// - Parameter color: 富文本的颜色
    /// - Returns: 转换后的富文本
    func colored(_ color: NSColor? = nil) -> NSMutableAttributedString {
        let color = color ?? .textColor
        return NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}

extension Date {
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
    
    /// 获取日志时间
    static var logDate: String {
        return Formatter.shared.logFormatter.string(from: Date())
    }
}

extension NSFont {
    static var `default` = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
}

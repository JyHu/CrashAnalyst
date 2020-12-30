//
//  HashHelper.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/7/19.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Cocoa

private func space(with level: Int) -> String {
    return Array(repeating: "\t", count: level).joined(separator: "")
}

private func hashStringOf(object: Any) -> String {
    if let str = object as? String {
        return "\"\(str.replacing(string: "\"", target: "\\\""))\""
    }
    return (object is NSNumber) ? "\(object)" : "\"\(object)\""
}

/// 将一些swift对象转换成字符串
/// - Parameters:
///   - object: 要转换的对象
///   - level: 当前的层级，默认为0
/// - Returns: 转换后的字符串
func hashToString(of object: Any, level: Int = 0) -> String {
    if let object = object as? Array<AnyObject> {
        return object.toStringWith(level: level)
    }

    if let object = object as? Dictionary<String, AnyObject> {
        return object.toStringWith(level: level)
    }

    return hashStringOf(object: object)
}

extension Dictionary where Key: Comparable {
    func toStringWith(level: Int) -> String {
        return "{\n".appending(sorted(by: { $0.key < $1.key }).map { (key, value) -> String in
            let tabs = "\(space(with: level + 1))\"\(key)\": "

            if let value = value as? Array<AnyObject> {
                return "\(tabs)\(value.toStringWith(level: level + 1))"
            }

            if let value = value as? Dictionary<String, AnyObject> {
                return "\(tabs)\(value.toStringWith(level: level + 1))"
            }

            return "\(tabs)\(hashStringOf(object: value as AnyObject))"
        }.joined(separator: ",\n")).appending("\n\(space(with: level))}")
    }
}

extension Array {
    func toStringWith(level: Int) -> String {
        return "[\n".appending(map({ object -> String in
            let tabs = "\(space(with: level + 1))"

            if let object = object as? Array<AnyObject> {
                return "\(tabs)\(object.toStringWith(level: level + 1))"
            }

            if let object = object as? Dictionary<String, AnyObject> {
                return "\(tabs)\(object.toStringWith(level: level + 1))"
            }

            return "\(tabs)\(hashStringOf(object: object as AnyObject))"
        }).joined(separator: ",\n")).appending("\n\(space(with: level))]")
    }
}

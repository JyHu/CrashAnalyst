//
//  Tools.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/8/11.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Foundation

enum OutputType {
    case `default`
    case json
    case data
}

/// 执行shell脚本
/// - Parameters:
///   - sc: shell脚本
///   - type: 返回数据的类型
/// - Returns: 执行结果
func execute(_ sc: String, type: OutputType = .default) -> Any? {
    xlog(sc)
    
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", sc]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()
    task.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    
    if type == .data {
        return data
    }
    
    if type == .json {
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    if let result = String(data: data, encoding: .utf8) {
        return result.trimming
    }
    
    return nil
}

//
//  Tools.swift
//  TigerTool
//
//  Created by 胡金友 on 2020/8/11.
//  Copyright © 2020 JyHu. All rights reserved.
//

import Foundation

/// 执行shell脚本
/// - Parameters:
///   - sc: shell脚本
/// - Returns: 执行结果
func ana_execute(_ sc: String) -> Any? {
    post(log: sc)
    
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", sc]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()
    task.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()

    if let result = String(data: data, encoding: .utf8) {
        let output = result.trimmingCharacters(in: .whitespacesAndNewlines)
        post(log: output)
        return output
    }
    
    return nil
}

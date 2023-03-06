//
//  File.swift
//  
//
//  Created by Jo on 2023/3/5.
//

import Foundation

private struct _R {
    private static var shared = _R()
    
    private var bundleIDReg: NSRegularExpression?
    private var versionReg1: NSRegularExpression?
    private var versionReg2: NSRegularExpression?
    private var addressReg: NSRegularExpression?
    private var codeTypeReg: NSRegularExpression?
    
    static var bundleIDReg: NSRegularExpression? { return _R.shared.bundleIDReg }
    static var versionReg1: NSRegularExpression? { return _R.shared.versionReg1 }
    static var versionReg2: NSRegularExpression? { return _R.shared.versionReg2 }
    static var addressReg: NSRegularExpression? { return _R.shared.addressReg }
    static var codeTypeReg: NSRegularExpression? { return _R.shared.codeTypeReg }
    
    private init() {
        let options: NSRegularExpression.Options = [.caseInsensitive, .anchorsMatchLines]
        
        let bundleIDPattern = "^Identifier:\\s+([\\w-\\.]+)$"
        let versionPattern = "^Version:\\s+([\\d\\.]+)\\s*?\\(([\\w]+)\\)"
        let versionPattern2 = "^Version:\\s+([\\w]+)\\s*?\\(([\\d\\.]+)\\)"
        let codeTypePattern = "^Code\\s+Type:\\s+(.*?)$"
        let addressPattern = "\\s+(0x\\w+)\\s+(0x\\w+).*+"
        
        bundleIDReg = try? NSRegularExpression(pattern: bundleIDPattern, options: options)
        versionReg1 = try? NSRegularExpression(pattern: versionPattern, options: options)
        versionReg2 = try? NSRegularExpression(pattern: versionPattern2, options: options)
        codeTypeReg = try? NSRegularExpression(pattern: codeTypePattern, options: options)
        addressReg = try? NSRegularExpression(pattern: addressPattern, options: .caseInsensitive)
    }
}

public extension CrashAnalyst {
    func analysis(crashFile content: String) async -> String {
        return await dSYMOf(crashFile: content)?.analysis(crashFile: content) ?? content
    }
    
    func dSYMOf(crashFile content: String) -> dSYMModel? {
        guard let idRange = _R.bundleIDReg?.firstMatch(in: content, range: NSMakeRange(0, content.count))?.range(at: 1),
              let (version, build) = compileVersion(content),
              let bundleID = content.ana_sub(range: idRange) else {
            return nil
        }
        
        return dSYMFrom(bundleID: bundleID, version: version, build: build)
    }
    
    private func compileVersion(_ string: String) -> (String, String)? {
        if let versionCheck = _R.versionReg1?.firstMatch(in: string, range: NSMakeRange(0, string.count)) {
            guard let version = string.ana_sub(range: versionCheck.range(at: 1)),
                  let build = string.ana_sub(range: versionCheck.range(at: 2)) else {
                return nil
            }
            
            return (version, build)
        }
        
        if let versionCheck = _R.versionReg2?.firstMatch(in: string, range: NSMakeRange(0, string.count)) {
            guard let version = string.ana_sub(range: versionCheck.range(at: 2)),
                  let build = string.ana_sub(range: versionCheck.range(at: 1)) else {
                return nil
            }
            
            return (version, build)
        }
        
        return nil
    }
}

public extension dSYMModel {
    func analysis(crashFile content: String) async -> String {
        guard let codeTypeRange = _R.codeTypeReg?.firstMatch(in: content, range: NSMakeRange(0, content.count))?.range(at: 1),
              let codeType = content.ana_sub(range: codeTypeRange),
              let arch = Arch(rawValue: codeType),
              let checkingResults = _R.addressReg?.matches(in: content, range: NSMakeRange(0, content.count)) else {
            return content
        }
        
        var mutableContent = content
        
        for index in 0 ..< checkingResults.count {
            let checkingResult = checkingResults[checkingResults.count - 1 - index]
            guard let crashAddress = content.ana_sub(range: checkingResult.range(at: 1)),
                  let slideAddress = content.ana_sub(range: checkingResult.range(at: 2)),
                  let code = await analysis(slideAddress: slideAddress, crashAddress: crashAddress, arch: arch) else {
                continue
            }
            
            let insertLoc = checkingResult.range.location + checkingResult.range.length
            mutableContent.insert(contentsOf: " \(code)", at: mutableContent.index(mutableContent.startIndex, offsetBy: insertLoc))
        }
        
        return mutableContent
    }
}

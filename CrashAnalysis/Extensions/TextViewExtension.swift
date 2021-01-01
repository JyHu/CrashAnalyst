//
//  TextViewExtension.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2021/1/1.
//

import Cocoa

extension NSTextView {
    /// 取消所有自动检查处理操作
    func disableAutomaticOperating() {
        isAutomaticTextReplacementEnabled = false
        isAutomaticSpellingCorrectionEnabled = false
        isAutomaticDataDetectionEnabled = false
        isAutomaticLinkDetectionEnabled = false
        isAutomaticDashSubstitutionEnabled = false
        isAutomaticQuoteSubstitutionEnabled = false
        if #available(OSX 10.12.2, *) {
            isAutomaticTextCompletionEnabled = false
        }
    }
}

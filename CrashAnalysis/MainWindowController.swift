//
//  MainWindowController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        dSYMManager.shared.reload()
    }

    @IBAction func analysisTypeAction(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            NotificationCenter.default.post(name: .switchAnalysis, object: AnalysisType.file)
        } else if sender.selectedSegment == 1 {
            NotificationCenter.default.post(name: .switchAnalysis, object: AnalysisType.address)
        } else if sender.selectedSegment == 2 {
            NotificationCenter.default.post(name: .switchAnalysis, object: AnalysisType.matrix)
        }
    }
    
}

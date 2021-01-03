//
//  MainWindowController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
    @IBOutlet weak var chooiceButton: NSButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        dSYMManager.shared.reload()
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchMainTabAction(_:)), name: .switchMainTab, object: nil)
    }
    
    @objc private func switchMainTabAction(_ notification: NSNotification) {
        guard let object = notification.object as? MainTab else {
            return
        }
        
        segmentedControl.isHidden = object == .doc
        chooiceButton.isHidden = object == .doc
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
    
    @IBAction func chooiceDSYMAction(_ sender: Any) {
        if dSYMManager.shared.chooiceDSYM() == .OK {
            NSAlert.display("筛选成功 ！！！", title: "提醒")
        }
    }
}

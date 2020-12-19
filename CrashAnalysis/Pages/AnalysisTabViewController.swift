//
//  AnalysisTabViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

class AnalysisTabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(switchAnalysisTypeAction(_:)), name: .switchAnalysis, object: nil)
    }
}

private extension AnalysisTabViewController {
    @objc func switchAnalysisTypeAction(_ notification: Notification) {
        guard let type = notification.object as? AnalysisType else {
            return
        }
        
        if type == .address {
            if self.tabViewItems.count >= 2 {
                self.selectedTabViewItemIndex = 1
            }
        } else {
            if self.tabViewItems.count >= 1 {
                self.selectedTabViewItemIndex = 0
            }
        }
    }
}

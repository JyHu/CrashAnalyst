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

        if type == .file {
            if tabViewItems.count >= 1 {
                selectedTabViewItemIndex = 0
            }
        } else if type == .address {
            if tabViewItems.count >= 2 {
                selectedTabViewItemIndex = 1
            }
        } else if type == .matrix {
            if tabViewItems.count >= 3 {
                selectedTabViewItemIndex = 2
            }
        }
    }
}

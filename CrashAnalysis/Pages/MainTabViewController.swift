//
//  MainTabViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/30.
//

import Cocoa

class MainTabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(switchAction(_:)), name: .switchMainTab, object: nil)
    }
    
    @objc private func switchAction(_ notification: NSNotification) {
        guard let object = notification.object as? MainTab else {
            return
        }
        
        if object == .dSYM {
            selectedTabViewItemIndex = 0
        } else {
            selectedTabViewItemIndex = 1
        }
    }
}

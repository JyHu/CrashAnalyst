//
//  NavigateTabViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/30.
//

import Cocoa

class NavigateTabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)
        
        guard let tabViewItem = tabViewItem else {
            return
        }
        
        if tabView.indexOfTabViewItem(tabViewItem) == 0 {
            NotificationCenter.default.post(name: .switchMainTab, object: MainTab.dSYM)
        } else {
            NotificationCenter.default.post(name: .switchMainTab, object: MainTab.doc)
        }
    }
}

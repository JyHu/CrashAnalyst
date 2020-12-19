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

}

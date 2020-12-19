//
//  MainSplitViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewItems.first?.minimumThickness = 200
        splitViewItems.first?.maximumThickness = 400
    }
    
}

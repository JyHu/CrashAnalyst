//
//  AnalysisSplitViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

class AnalysisSplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewItems.first?.minimumThickness = 200
        splitViewItems.last?.minimumThickness = 100
    }
    
}

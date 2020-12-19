//
//  MatrixAnalysisViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/19.
//

import Cocoa

class MatrixAnalysisViewController: NSViewController {
    
    @IBOutlet weak var analysisButton: NSButton!
    
    @IBOutlet weak var pathButton: NSButton!
    
    @IBOutlet var jsonTextView: NSTextView!
    
    @IBOutlet var resultTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dsymAction(_ sender: Any) {
        if jsonTextView.string.trimming.count == 0 {
            return
        }
        
        guard let data = jsonTextView.string.data(using: .utf8) else {
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return
        }
        
        
    }
    
    @IBAction func analysisAction(_ sender: Any) {
    }
    
    @IBAction func pathAction(_ sender: Any) {
    }
}

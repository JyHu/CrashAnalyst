//
//  MatrixAnalysisViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/19.
//

import Cocoa

class MatrixAnalysisViewController: NSViewController {
    
    let nameColumnID = NSUserInterfaceItemIdentifier(rawValue: "com.auu.nameColumn")
    let valueColumnID = NSUserInterfaceItemIdentifier(rawValue: "com.auu.valueColumn")
    
    @IBOutlet weak var analysisButton: NSButton!
    
    @IBOutlet weak var pathButton: NSButton!
    
    @IBOutlet var jsonTextView: NSTextView!
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    @IBOutlet var originalTextView: NSTextView!
    
    private var dSYM: dSYMModel?
    private var crash: CrashAna?
    
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
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any> else {
            return
        }
        
        reload(CrashAna(json, title: "Ana", content: ""))
    }
    
    @IBAction func analysisAction(_ sender: Any) {
        print("")
    }
    
    @IBAction func pathAction(_ sender: Any) {
    }
}

extension MatrixAnalysisViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func reload(_ crashContent: CrashAna?) {
        self.crash = crashContent
        self.outlineView.reloadData()
        self.outlineView.expandItem(nil, expandChildren: true)
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? CrashContent {
            return item.children.count
        }
        
        return self.crash != nil ? 1 : 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? CrashContent {
            return item.children[index]
        }

        return self.crash!.content!
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return (item as? CrashContent)?.children.count ?? 0 > 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return (item as? CrashContent)?.children.count ?? 0 > 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        guard let item = item as? CrashContent else {
            return nil
        }
        
        if tableColumn?.identifier == nameColumnID {
            return item.title
        }
        
        if tableColumn?.identifier == valueColumnID {
            return item.content
        }
        
        return nil
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
//        xdesc((outlineView.item(atRow: outlineView.selectedRow) as? CrashContent)?.jsonString() ?? "")
        
//        if let item = outlineView.item(atRow: outlineView.selectedRow) as? CrashContent {
//            if item.type == .root {
//                let md = item.md(0)
//                xdesc("```\n\n\(md)\n\n```")
//            } else {
//                xdesc(item.jsonString() ?? "")
//            }
//        } else {
//            xdesc("")
//        }
    }
}

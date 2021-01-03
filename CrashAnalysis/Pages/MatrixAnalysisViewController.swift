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
    
    @IBOutlet weak var jsonTextView: NSTextView!
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    @IBOutlet weak var originalTextView: NSTextView!

    private var crash: CrashAna?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let martixTips = FileTips.martixTips else {
            return
        }
        
        jsonTextView.textStorage?.setAttributedString(martixTips)
    }

    @IBAction func analysisAction(_ sender: Any) {
        if jsonTextView.string.trimming.count == 0 {
            reload(nil)
            return
        }

        guard let data = jsonTextView.string.data(using: .utf8) else {
            reload(nil)
            return
        }

        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any> else {
            reload(nil)
            return
        }

        let ana = CrashAna(json)

        if let dSYM = dSYMManager.shared.dSYMFrom(bundleID: ana.identifier, version: ana.version, build: ana.build) {
            pathButton.title = dSYM.location
            ana.content.analysis(with: dSYM)
        }
        
        reload(ana)
    }

    @IBAction func pathAction(_ sender: Any) {
        NSWorkspace.shared.open(URL(fileURLWithPath: pathButton.title))
    }
}

extension MatrixAnalysisViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func reload(_ crashContent: CrashAna?) {
        crash = crashContent
        outlineView.reloadData()
        outlineView.expandItem(nil, expandChildren: true)
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? CrashContent {
            return item.children.count
        }

        return crash != nil ? 1 : 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? CrashContent {
            return item.children[index]
        }

        return crash!.content!
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
        if let crashContent = outlineView.item(atRow: outlineView.selectedRow) as? CrashContent {
            let mutableText = NSMutableAttributedString(string: "")
            let attrs = [
                NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: NSColor.red,
            ]
            
            if let text = crashContent.jsonString() {
                mutableText.append("Original: -------------------------------->\n", attributes: attrs)
                mutableText.append(text)
                mutableText.append("\n\n\n")
            }
            
            mutableText.append("Format: --------------------------------->\n", attributes: attrs)
            mutableText.append(crashContent.md(0))
            
            originalTextView.textStorage?.setAttributedString(mutableText)
        } else {
            originalTextView.string = ""
        }
    }
}

private extension CrashContent {
    func space(_ count: Int) -> String {
        return Array(repeating: " ", count: abs(count)).joined()
    }

    func fmt(_ title: String, _ level: Int) -> String {
        return "\(space(level * 2))\(title)\(space(50 - level * 2 - title.count))"
    }

    func md(_ level: Int) -> String {
        var md = ""
        var stringContent = ""
        
        if let content = content as? NSAttributedString {
            stringContent = content.string
        } else if let content = content as? String {
            stringContent = content
        }
        
        if let title = title as? NSAttributedString {
            md = "\(fmt(title.string, level))\(stringContent)"
        } else if let title = title as? String {
            md = "\(fmt(title, level))\(stringContent)"
        } else {
            return ""
        }

        if children.count > 0 {
            md.append("\n\(children.map({ $0.md(level + 1) }).joined(separator: "\n"))\n")
        }

        return md
    }
}

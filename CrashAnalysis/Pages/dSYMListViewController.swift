//
//  dSYMListViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

private extension NSUserInterfaceItemIdentifier {
    /// 标识列id
    static let identifier = NSUserInterfaceItemIdentifier("com.auu.dsymList.identifier")
}

class dSYMListViewController: NSViewController {
    
    /// 显示dSYM的列表
    @IBOutlet weak var outlineView: NSOutlineView!
    
    /// 显示选中dSYM的信息
    @IBOutlet var descTextView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadAction), name: .dsymUpdated, object: nil)
    }

    /// 单击事件
    @IBAction func clickAction(_ sender: NSOutlineView) {
        showContent(with: sender.item(atRow: sender.selectedRow))
    }
    
    /// 双击事件
    @IBAction func doubleClickAction(_ sender: NSOutlineView) {
        showContent(with: sender.item(atRow: sender.selectedRow))
    }
}

extension dSYMListViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let proj = item as? ProjModel {
            return proj.dSYMs.count
        }
        
        return dSYMManager.shared.projs.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let proj = item as? ProjModel {
            return proj.dSYMs[index]
        }
        
        return dSYMManager.shared.projs[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return item is ProjModel
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item is ProjModel
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        
        guard let identifier = tableColumn?.identifier else {
            return nil
        }
        
        if let proj = item as? ProjModel {
            return identifier == .identifier ? proj.identifier : nil
        }
        
        guard let dsym = item as? dSYMModel else {
            return nil
        }

        if identifier == .identifier {
            return "\(dsym.version)  (\(dsym.build))"
        }

        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        showContent(with: item)
        return true
    }
}

private extension dSYMListViewController {
    /// 刷新列表
    @objc func reloadAction() {
        outlineView.reloadData()
        outlineView.expandItem(nil, expandChildren: true)
    }

    /// 显示对应行的概要信息
    func showContent(with object: Any?) {
        if let dSYM = object as? dSYMModel {
            show(dSYM)
        } else if let proj = object as? ProjModel {
            show(proj)
        } else {
            descTextView.string = ""
        }
    }
    
    func redirectContent(of dSYM: dSYMModel) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        
        if let archiveURL = dSYM.archiveUrl {
            let attr = [NSAttributedString.Key.link: archiveURL]
            attributedString.append("Archive", attributes: attr)
            attributedString.append("  ")
        }

        let dSYMUrl = URL(fileURLWithPath: dSYM.path)
        attributedString.append("dSYM", attributes: [NSAttributedString.Key.link: dSYMUrl])

        if let dwarfFile = dSYM.dwarfFile {
            let attr = [NSAttributedString.Key.link: URL(fileURLWithPath: dwarfFile)]
            attributedString.append("  ")
            attributedString.append("DWARF", attributes: attr)
        }
        
        return attributedString
    }
    
    func show(_ dSYM: dSYMModel) {
        
        let attrInfo = NSMutableAttributedString(string: "")
        attrInfo.append("Identifier :  \(dSYM.identifier)\n")
        attrInfo.append("Version :  \(dSYM.version)  (\(dSYM.build))\n")

        if let uuid = dSYM.uuid, let arch = dSYM.arch {
            attrInfo.append("UUID :  \(uuid) (\(arch))\n")
        }

        if let dateString = dSYM.creationDateString {
            attrInfo.append("Creation Date :  \(dateString)\n")
        }

        attrInfo.append("\n")
        attrInfo.append("Open:\n")
        attrInfo.append(redirectContent(of: dSYM))

        descTextView.textStorage?.setAttributedString(attrInfo)
    }
    
    func show(_ proj: ProjModel) {
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append("\(proj.identifier) (\(proj.dSYMs.count))\n")
        
        for (index, dSYM) in proj.dSYMs.enumerated() {
            attributedString.append(String(format: "%8d", index))
            attributedString.append(" - \(dSYM.version) (\(dSYM.build)) :  ")
            attributedString.append(redirectContent(of: dSYM))
            attributedString.append("\n")
        }
        
        descTextView.textStorage?.setAttributedString(attributedString)
    }
}

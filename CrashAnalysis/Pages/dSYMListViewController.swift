//
//  dSYMListViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

private let _UseIt = "useit"
private let _moveDSYM = "movedsym"
private let _moveAllDSYM = "movealldsym"

private extension NSUserInterfaceItemIdentifier {
    /// 标识列id
    static let identifier = NSUserInterfaceItemIdentifier("com.auu.dsymList.identifier")
}

extension Notification.Name {
    static let useSelectedDSYM = Notification.Name("use_selected_dsym")
}

class dSYMListViewController: NSViewController, NSTextViewDelegate {
    
    /// 显示dSYM的列表
    @IBOutlet weak var outlineView: NSOutlineView!
    
    /// 显示选中dSYM的信息
    @IBOutlet var descTextView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        descTextView.delegate = self
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
    
    func moveDSYMAction(dsym: dSYMModel) -> Bool {
        guard let archiveURL = dsym.archiveUrl, let dsymName = dsym.path.lastPathComponent else {
            return false
        }
        
        let url = archiveURL.deletingLastPathComponent().appendingPathComponent(dsymName)
        
        var moveSuccessed: Bool = false
        
        do {
            if !FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.moveItem(at: URL(fileURLWithPath: dsym.path), to: url)
                print("move \(dsym.path) --> to \(url.path)")
            }
            
            try FileManager.default.removeItem(at: archiveURL)
            print("remove archive \(archiveURL.path)")
            
            dsym.path = url.path
            dsym.archiveUrl = nil
            
            moveSuccessed = true
        } catch {
            print(error)
            moveSuccessed = false
        }
        
        return moveSuccessed
    }
    
    func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        if (link as? String) == _UseIt {
            guard let dsym = outlineView.item(atRow: outlineView.selectedRow) as? dSYMModel else {
                return false
            }
            
            NotificationCenter.default.post(name: .useSelectedDSYM, object: dsym)
            
            return true
        } else if (link as? String) == _moveDSYM {
            guard let dsym = outlineView.item(atRow: outlineView.selectedRow) as? dSYMModel else {
                return true
            }
            
            if moveDSYMAction(dsym: dsym) {
                showContent(with: dsym)
            }
            
            return true
        } else if (link as? String) == _moveAllDSYM {
            guard let proj = outlineView.item(atRow: outlineView.selectedRow) as? ProjModel else {
                return true
            }
            
            var moveSuccessed = false
            
            for dsym in proj.dSYMs {
                if moveDSYMAction(dsym: dsym) {
                    moveSuccessed = true
                }
            }
            
            if moveSuccessed {
                showContent(with: proj)
            }
            
            return true
        }
        
        return false
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
        return false
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
    
    func redirectContent(of dSYM: dSYMModel, needMoveArchive: Bool = true) -> NSAttributedString {
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
        
        let useAttr = [NSAttributedString.Key.link: _UseIt]
        attributedString.append("  ")
        attributedString.append("Use it", attributes: useAttr)
        
        if needMoveArchive, let _ = dSYM.archiveUrl {
            let moveAttr = [NSAttributedString.Key.link: _moveDSYM]
            attributedString.append("\n")
            attributedString.append("Move dSYM", attributes: moveAttr)
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
        
        var containsArchive: Bool = false
        for (index, dSYM) in proj.dSYMs.enumerated() {
            if let _ = dSYM.archiveUrl {
                containsArchive = true
            }
            
            attributedString.append(String(format: "%8d", index))
            attributedString.append(" - \(dSYM.version) (\(dSYM.build)) (\(dSYM.archiveUrl == nil ? "dSYM" : "archive")) :  ")
            attributedString.append(redirectContent(of: dSYM, needMoveArchive: false))
            attributedString.append("\n")
        }
        
        if containsArchive {
            attributedString.append("\n\n")
            attributedString.append("Move all dSYMs", attributes: [.link: _moveAllDSYM])
            attributedString.append("\n\n")
        }
        
        descTextView.textStorage?.setAttributedString(attributedString)
    }
}

//
//  ProjectListViewController.swift
//  Analyst
//
//  Created by Jo on 2023/3/4.
//

import Cocoa
import SwiftExtensions
import CrashAnalyst

private let _moveDSYM = "movedsym"
private let _moveAllDSYM = "movealldsym"

private extension NSUserInterfaceItemIdentifier {
    static let fileItem = NSUserInterfaceItemIdentifier("com.auu.dsym.fileItem")
}

class ProjectListViewController: NSViewController {

    private var outlineView = NSOutlineView(frame: NSMakeRect(0, 0, 100, 100))
    private var textView = NSTextView(frame: NSMakeRect(0, 0, 100, 100))
    
    override func loadView() {
        let outlineScroll = NSScrollView(documentView: outlineView, isHorizontal: false)
        let textScroll = NSScrollView(documentView: textView, isHorizontal: false)
        
        let splitView = NSSplitView(frame: NSMakeRect(0, 0, 100, 100))
        splitView.addArrangedSubview(outlineScroll)
        splitView.addArrangedSubview(textScroll)
        splitView.dividerStyle = .thin
        splitView.delegate = self
        view = splitView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        textView.autoresizingMask = [.width, .height]
        textView.isEditable = false
        textView.delegate = self
        
        outlineView.addOutlineColumn(identifier: .fileItem, title: "")
        outlineView.delegate = self
        outlineView.dataSource = self
        outlineView.headerView = nil
        outlineView.usesAlternatingRowBackgroundColors = true
        outlineView.allowsMultipleSelection = true
        outlineView.style = .inset
        
        NotificationCenter.default.addObserver(forName: CrashAnalyst.dSYMListUpdated, object: nil, queue: .main) { [weak self] _ in
            self?.outlineView.reloadData()
            self?.outlineView.expandItem(nil, expandChildren: true)
        }
    }
}

extension ProjectListViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? dSYMProjModel { return item.dSYMs.count }
        if item == nil { return CrashAnalyst.shared.projs.count }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? dSYMProjModel {
            return item.dSYMs[index]
        }
        
        if item == nil {
            return CrashAnalyst.shared.projs[index]
        }
        
        fatalError()
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return (item as? dSYMProjModel)?.dSYMs.count ?? 0 > 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let identifier = tableColumn?.identifier else { return nil }
        let cellView = outlineView.reuse(with: identifier, orCreate: dSYMTableCellView())
        
        if let item = item as? dSYMProjModel {
            cellView.stringValue = item.bundleID
        }
        
        if let item = item as? dSYMModel {
            cellView.stringValue = "\(item.version) (\(item.build))"
        }
        
        return cellView
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        showContent(with: outlineView.item(atRow: outlineView.selectedRow))
    }
}

extension ProjectListViewController: NSSplitViewDelegate {
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 300
    }
    
    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return splitView.bounds.height - 100
    }
}

extension ProjectListViewController: NSTextViewDelegate {
    func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        if (link as? String) == _moveDSYM {
            guard let dsym = outlineView.item(atRow: outlineView.selectedRow) as? dSYMModel else {
                return true
            }
            
            if moveDSYMAction(dsym: dsym) {
                showContent(with: dsym)
            }
            
            return true
        } else if (link as? String) == _moveAllDSYM {
            guard let proj = outlineView.item(atRow: outlineView.selectedRow) as? dSYMProjModel else {
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

private extension ProjectListViewController {
    /// 显示对应行的概要信息
    func showContent(with object: Any?) {
        if let dSYM = object as? dSYMModel {
            show(dSYM)
        } else if let proj = object as? dSYMProjModel {
            show(proj)
        } else {
            textView.string = ""
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

        for dwarfFile in dSYM.dwarfFiles {
            let attr = [NSAttributedString.Key.link: URL(fileURLWithPath: dwarfFile.file)]
            attributedString.append("  ")
            attributedString.append("DWARF(\(dwarfFile.arch.rawValue))", attributes: attr)
        }
        
        if needMoveArchive, let _ = dSYM.archiveUrl {
            let moveAttr = [NSAttributedString.Key.link: _moveDSYM]
            attributedString.append("\n")
            attributedString.append("Move dSYM", attributes: moveAttr)
        }
        
        
        return attributedString
    }
    
    func show(_ dSYM: dSYMModel) {
        
        let attrInfo = NSMutableAttributedString(string: "")
        attrInfo.append("Identifier :  \(dSYM.bundleID)\n")
        attrInfo.append("Version :  \(dSYM.version)  (\(dSYM.build))\n")

        for dwarfFile in dSYM.dwarfFiles {
            attrInfo.append("UUID :  \(dwarfFile.uuid) (\(dwarfFile.arch.rawValue))\n")
        }

        if let dateString = dSYM.creationDateString {
            attrInfo.append("Creation Date :  \(dateString)\n")
        }

        attrInfo.append("\n")
        attrInfo.append("Open:\n")
        attrInfo.append(redirectContent(of: dSYM))

        textView.textStorage?.setAttributedString(attrInfo)
    }
    
    func show(_ proj: dSYMProjModel) {
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append("\(proj.bundleID) (\(proj.dSYMs.count))\n")
        
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
        
        textView.textStorage?.setAttributedString(attributedString)
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
}

private class dSYMTableCellView: NSTableCellView {
    var stringValue: String = "" {
        didSet {
            label.stringValue = stringValue
        }
    }
    
    private var label = NSTextField(labelWithString: "--")
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        layout(subViews: [label], constraints: [
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  dSYMListViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

private extension NSUserInterfaceItemIdentifier {
    /// 索引列id
    static let index = NSUserInterfaceItemIdentifier("com.auu.dsymList.index")
    /// 标识列id
    static let identifier = NSUserInterfaceItemIdentifier("com.auu.dsymList.identifier")
    /// 版本号id
    static let version = NSUserInterfaceItemIdentifier("com.auu.dsymList.version")
}

class dSYMListViewController: NSViewController {
    /// 显示dSYM的列表
    @IBOutlet var tableView: NSTableView!

    /// 显示选中dSYM的信息
    @IBOutlet var descTextView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(reloadAction),
                         name: .dsymUpdated,
                         object: nil)
    }

    /// 单击事件
    @IBAction func clickAction(_ sender: NSTableView) {
        showContent(at: sender.selectedRow)
    }

    /// 双击事件
    @IBAction func doubleClickAction(_ sender: NSTableView) {
        if let dSYM = activeDSYM(sender.selectedRow) {
            let url = URL(fileURLWithPath: dSYM.location)
            NSWorkspace.shared.open(url)
        }
    }
}

extension dSYMListViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dSYMManager.shared.dSYMs.count
    }

    func tableView(_ tableView: NSTableView,
                   objectValueFor tableColumn: NSTableColumn?,
                   row: Int) -> Any? {
        
        guard let identifier = tableColumn?.identifier else {
            return nil
        }

        let dsym = dSYMManager.shared.dSYMs[row]

        if identifier == .index {
            return "\(row)"
        }

        if identifier == .identifier {
            return dsym.identifier
        }

        if identifier == .version {
            return "\(dsym.version)(\(dsym.build))"
        }

        return nil
    }

    func tableView(_ tableView: NSTableView,
                   shouldSelectRow row: Int) -> Bool {
        showContent(at: row)
        return true
    }
}

private extension dSYMListViewController {
    /// 刷新列表
    @objc func reloadAction() {
        tableView.reloadData()
    }

    /// 当前选中的活跃的dSYM文件
    /// - Parameter row: 行，如果没传入，会默认使用tableView选择的行
    /// - Returns: dSYM文件
    func activeDSYM(_ row: Int?) -> dSYMModel? {
        let selectedRow = row ?? tableView.selectedRow
        let dSYMs = dSYMManager.shared.dSYMs

        /// 判断行的有效
        if selectedRow >= 0 && selectedRow < dSYMs.count {
            return dSYMs[selectedRow]
        }

        return nil
    }

    /// 显示对应行的dSYM的概要信息
    func showContent(at row: Int?) {
        guard let row = row,
              let dSYM = activeDSYM(row) else {
            descTextView.string = ""
            return
        }

        let dSYMUrl = URL(fileURLWithPath: dSYM.path)

        let attrInfo = NSMutableAttributedString(string: "")
        attrInfo.append("Identifier :  \(dSYM.identifier)\n")
        attrInfo.append("Version :  \(dSYM.version)(\(dSYM.build))\n")

        if let uuid = dSYM.uuid, let arch = dSYM.arch {
            attrInfo.append("UUID :  \(uuid) (\(arch))\n")
        }

        if let dateString = dSYM.creationDateString {
            attrInfo.append("Creation Date :  \(dateString)\n")
        }

        attrInfo.append("\n")

        attrInfo.append("Open:\n")
        
        if let archiveURL = dSYM.archiveUrl {
            let attr = [NSAttributedString.Key.link: archiveURL]
            attrInfo.append("Archive", attributes: attr)
            attrInfo.append("  ")
        }

        attrInfo.append("dSYM", attributes: [NSAttributedString.Key.link: dSYMUrl])

        if let dwarfFile = dSYM.dwarfFile {
            let attr = [NSAttributedString.Key.link: URL(fileURLWithPath: dwarfFile)]
            attrInfo.append("  ")
            attrInfo.append("DWARF", attributes: attr)
        }

        descTextView.textStorage?.setAttributedString(attrInfo)
    }
}

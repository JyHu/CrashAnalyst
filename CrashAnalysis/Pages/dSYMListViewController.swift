//
//  dSYMListViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

private extension NSUserInterfaceItemIdentifier {
    static let index = NSUserInterfaceItemIdentifier("com.auu.dsymList.index")
    static let identifier = NSUserInterfaceItemIdentifier("com.auu.dsymList.identifier")
    static let version = NSUserInterfaceItemIdentifier("com.auu.dsymList.version")
}

class dSYMListViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAction), name: .dsymUpdated, object: nil)
    }
}

extension dSYMListViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dSYMManager.shared.dSYMs.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
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
}

private extension dSYMListViewController {
    @objc func reloadAction() {
        self.tableView.reloadData()
    }
}

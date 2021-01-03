//
//  LogsViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

/// 增加普通文本的日志
func xlog(_ log: String) {
    NotificationCenter.default.post(name: .log, object: log)
}

/// 增加富文本的日志
func xlog(_ log: NSAttributedString) {
    NotificationCenter.default.post(name: .log, object: log)
}

class LogsViewController: NSViewController {
    @IBOutlet var textView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appendLog(_:)), name: .log, object: nil)

        let menu = NSMenu()

        let item = NSMenuItem(title: "Clear", action: #selector(clearAction), keyEquivalent: "")
        item.target = self
        menu.addItem(item)

        textView.menu = menu
    }
}

private extension LogsViewController {
    @objc func appendLog(_ notification: Notification) {
        guard let storage = textView.textStorage else {
            return
        }

        storage.append(Date.logDate.colored(.secondaryLabelColor))
        storage.append(" ")

        if let log = notification.object as? String {
            storage.append(log.colored(.textColor))
        } else if let log = notification.object as? NSAttributedString {
            storage.append(log)
        }

        storage.append("\n".colored())
    }

    @objc func clearAction() {
        textView.string = ""
    }
}

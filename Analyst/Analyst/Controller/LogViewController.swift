//
//  LogViewController.swift
//  Analyst
//
//  Created by Jo on 2023/3/4.
//

import Cocoa
import CrashAnalyst

func xlog(info: String) {
    NotificationCenter.default.post(name: .logInfo, object: info)
}

func xlog(error: String) {
    NotificationCenter.default.post(name: .logError, object: error)
}

private extension NSNotification.Name {
    static var logInfo = Notification.Name("com.auu.analyst.logInfo")
    static var logError = Notification.Name("com.auu.analyst.logError")
}

class LogViewController: NSViewController {
    private var logView = LogView()
    override func loadView() {
        view = logView.view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        NotificationCenter.default.addObserver(forName: .logInfo, object: nil, queue: .main) { [weak self] notification in
            guard let info = notification.object as? String else { return }
            self?.logView.append(log: info)
        }
        
        NotificationCenter.default.addObserver(forName: .logError, object: nil, queue: .main) { [weak self] notification in
            guard let error = notification.object as? String else { return }
            self?.logView.append(errorInfo: error)
        }
        
        NotificationCenter.default.addObserver(forName: CrashAnalyst.log, object: nil, queue: .main) { [weak self] notification in
            guard let log = notification.object as? String else { return }
            self?.logView.append(log: log)
        }
    }
}

/// 日志视图
public class LogView {
    private var scrollView = NSScrollView(frame: NSMakeRect(0, 0, 100, 100))
    public var view: NSView { scrollView }
    private var textView = NSTextView(frame: NSMakeRect(0, 0, 100, 100))

    /// 日期格式化对象
    private var formatter = DateFormatter()
    /// 暂存暂未显示的日志数据，如果日志输出的频率过快，需要限制输出频率
    /// 这个数组在主线程中操作，不可在异步线程
    private var logStack: [NSAttributedString] = []
    /// 上一次输出日志信息的时间
    private var previousDate = Date()
    /// 是否已经添加了定时器用于输出暂存的日志
    private var hadTimer: Bool = false

    public init() {
        let clearItem = NSMenuItem(title: "Clear All", target: self, action: #selector(clearAllLogsAction))
        clearItem.target = self
        let menu = NSMenu(title: "")
        menu.addItem(clearItem)

        textView.menu = menu
        textView.isEditable = false
        textView.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.autoresizingMask = [.width, .height]
        scrollView.documentView = textView
        formatter.dateFormat = "HH:mm:ss.SSSS"
    }

    /// 添加普通的日志信息
    public func append(log: String) {
        self.append(attributedLog: attributed(log: log, color: .textColor, fontSize: 13))
    }

    /// 添加错误的日志信息
    public func append(errorInfo: String) {
        self.append(attributedLog: attributed(log: errorInfo, color: .red, fontSize: 13))
    }

    /// 添加一个空行
    public func linefeed() {
        self.append(attributedLog: attributed(log: "\n", color: nil, fontSize: nil))
    }
}

private extension LogView {
    @objc func clearAllLogsAction() {
        textView.string = ""
    }

    /// 现在当前线程把日志内容处理成富文本
    func attributed(log: String, color: NSColor?, fontSize: CGFloat?) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]

        if let color = color {
            attributes[.foregroundColor] = color
        }

        if let fontSize = fontSize {
            attributes[.font] = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        }

        let date = Date()
        let dateStr = formatter.string(from: date).appending(": ")
        let dateAttrs: [NSAttributedString.Key: Any] = [ .font: NSFont.monospacedSystemFont(ofSize: 13, weight: .regular), .foregroundColor: NSColor.secondaryLabelColor ]
        let attrLog = NSMutableAttributedString(string: dateStr, attributes: dateAttrs)
        attrLog.append(log, attributes: attributes)

        return attrLog
    }

    /// 在主线程把日志添加到textView里
    func append(attributedLog: NSAttributedString) {
        /// 如果不是主线程，就先抛到主线程中，然后跳出
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.append(attributedLog: attributedLog)
            }
            return
        }

        let date = Date()

        /// 如果距离上次输出时间不到100ms，避免高频刷新，就先暂存数据
        if date.timeIntervalSince(previousDate) * 1000 < 100 {
            logStack.append(attributedLog)

            /// 如果没有添加定时器，就添加一个定时器，在100ms后把暂存的内容输出
            if !hadTimer {
                hadTimer = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.flush()
                }
            }
        }
        /// 如果距离上次时间超过了100ms，那么直接输出内容
        else {
            /// 输出内容的时候先输出一下缓存
            flush()

            textView.textStorage?.append("\n")
            textView.textStorage?.append(attributedLog)
            previousDate = date
            toVisible()
        }
    }

    func toVisible() {
        if textView.string.isEmpty { return }
        textView.scrollRangeToVisible(NSMakeRange(textView.string.count - 1, 0))
    }

    func flush() {
        guard logStack.count > 0 else { return }

        for attrLog in logStack {
            textView.textStorage?.append("\n")
            textView.textStorage?.append(attrLog)
        }

        toVisible()

        logStack.removeAll()
        hadTimer = false
        previousDate = Date()
    }
}

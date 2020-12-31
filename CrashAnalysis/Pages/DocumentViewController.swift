//
//  DocumentViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/30.
//

import Cocoa
import WebKit

private extension NSUserInterfaceItemIdentifier {
    /// 翻译后web的tab id
    static let chineseWebID = NSUserInterfaceItemIdentifier("com.auu.chineseWebID.identifier")
    /// 原始内容web的tab id
    static let originWebID = NSUserInterfaceItemIdentifier("com.auu.originWebID.identifier")
    /// 外部链接web的tab id
    static let remoteWebID = NSUserInterfaceItemIdentifier("com.auu.remoteWebID.identifier")
    /// 本地资源tab的tab id
    static let localTabID = NSUserInterfaceItemIdentifier("com.auu.localTabID.identifier")
}

class DocumentViewController: NSViewController {

    @IBOutlet weak var stopLoadingButton: NSButton!
    @IBOutlet weak var refreshButton: NSButton!
    
    /// 返回本地资源web tab的按钮
    @IBOutlet weak var backLocalButton: NSButton!
    /// 显示Apple原始内容的按钮
    @IBOutlet weak var showOriginButton: NSButton!
    /// 文件地址按钮
    @IBOutlet weak var fileButton: NSButton!
    /// 承载webview的tab
    @IBOutlet weak var webTab: NSTabView!
    /// 网页加载进度
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    /// 本地资源tab
    private var localTab = NSTabView()
    
    /// 显示本地汉化资源的web view
    private lazy var chineseWebView = { createWebView() }()
    /// 显示apple原始内容的web view
    private lazy var originWebView = { createWebView() }()
    /// 显示外部链接内容的web view
    private lazy var remoteWebView = { createWebView() }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showOriginButton.state = .off
        stopLoadingButton.isHidden = true
        
        localTab.tabViewType = .noTabsNoBorder
        
        localTab.addTab(web: chineseWebView, identifier: .chineseWebID)
        localTab.addTab(web: originWebView, identifier: .originWebID)
        webTab.addTab(web: localTab, identifier: .localTabID)
        webTab.addTab(web: remoteWebView, identifier: .remoteWebID)
        
        updateNavigationState()
        
        loadHTMLFile(with: "diagnosing_issues_using_crash_reports_and_device_logs_en.html", webView: originWebView)
        loadHTMLFile(with: "diagnosing_issues_using_crash_reports_and_device_logs.html", webView: chineseWebView)
    }
    
    @IBAction func stopLoadingAction(_ sender: NSButton) {
        activeWebView.stopLoading()
    }
    
    @IBAction func refreshAction(_ sender: NSButton) {
        activeWebView.reload()
    }
    
    @IBAction func backLocalAction(_ sender: NSButton) {
        webTab.selectedItem(with: .localTabID)
        updateNavigationState()
    }
    
    @IBAction func showOriginAction(_ sender: NSButton) {
        if sender.state == .on {
            localTab.selectedItem(with: .originWebID)
        } else {
            localTab.selectedItem(with: .chineseWebID)
        }
    }
    
    @IBAction func openFileAction(_ sender: NSButton) {
        guard let url = activeWebView.url else {
            return
        }
        
        if url.scheme?.hasPrefix("http") ?? false {        
            NSWorkspace.shared.open(url)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath != "estimatedProgress" {
            return
        }
        
        guard let change = change,
              let progress = change[.newKey] as? Double else {
            return
        }
        
        update(progress: progress)
    }
}

extension DocumentViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        
        updateNavigationState()
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        
        updateNavigationState()
    }
    
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        webView.load(navigationAction.request)
        updateNavigationState()
        return nil
    }
    
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alert = NSAlert()
        alert.messageText = message;
        alert.runModal()
        completionHandler()
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if webView != remoteWebView && (navigationAction.request.url?.scheme?.hasPrefix("http") ?? false) {
            webTab.selectedItem(with: .remoteWebID)
            remoteWebView.load(navigationAction.request)
            
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        
        updateNavigationState()
    }
    
    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = message
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        if alert.runModal() == .alertFirstButtonReturn {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        let textView = NSTextView(frame: NSMakeRect(0, 0, 360, 120))
        textView.autoresizingMask = [.width, .height]
        textView.string = defaultText ?? ""
        let scroll = NSScrollView(frame: NSMakeRect(0, 0, 360, 120))
        scroll.documentView = textView
        
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = prompt
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.accessoryView = scroll
        
        if alert.runModal() == .alertFirstButtonReturn {
            completionHandler(textView.string)
        } else {
            completionHandler(nil)
        }
    }
    
    func webView(_ webView: WKWebView,
                 runOpenPanelWith parameters: WKOpenPanelParameters,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping ([URL]?) -> Void) {
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = parameters.allowsMultipleSelection
        openPanel.canChooseDirectories = parameters.allowsDirectories
        if openPanel.runModal() == .OK {
            completionHandler(openPanel.urls)
        } else {
            completionHandler(nil)
        }
    }
}

private extension DocumentViewController {
    func createWebView() -> WKWebView {
        let userContentController = WKUserContentController()
        
        let configuration = WKWebViewConfiguration()
        configuration.processPool = _ToolProcessPoolManager.shared.processPool
        configuration.userContentController = userContentController
                
        let webView = WKWebView(frame: NSMakeRect(0, 0, 100, 100), configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [ .new ], context: nil)
        
        return webView
    }
    
    /// 更新导航按钮的状态
    func updateNavigationState() {
        
        if isRemoteItem {
            refreshButton.isHidden = remoteWebView.isLoading
            stopLoadingButton.isHidden = !remoteWebView.isLoading
        } else {
            refreshButton.isHidden = true
            stopLoadingButton.isHidden = true
        }
        
        backLocalButton.isHidden = !isRemoteItem
        showOriginButton.isHidden = isRemoteItem
        
        update(progress: activeWebView.estimatedProgress)
        
        guard let urlString = activeWebView.url?.absoluteString else {
            fileButton.title = ""
            return
        }
        
        if urlString.hasPrefix("http") {
            fileButton.title = urlString + " ⤴︎"
        } else {
            fileButton.title = ""
        }
    }
    
    func createTab(with webView: WKWebView) -> NSTabViewItem {
        let item = NSTabViewItem()
        item.view = webView
        return item
    }
    
    func loadHTMLFile(with fileName: String, webView: WKWebView) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let html = String(data: data, encoding: .utf8) else {
            return
        }
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func update(progress: Double) {
        progressBar.isHidden = progress == 0 || progress == 1
        progressBar.doubleValue = progress
    }
    
    var isRemoteItem: Bool {
        return webTab.selectedItemID == .remoteWebID
    }
    
    var isOriginItem: Bool {
        return localTab.selectedItemID == .originWebID
    }
    
    var activeWebView: WKWebView {
        if webTab.selectedItemID == .remoteWebID {
            return remoteWebView
        }
        
        if localTab.selectedItemID == .originWebID {
            return originWebView
        }
        
        return chineseWebView
    }
}

private struct _ToolProcessPoolManager {
    static var shared = _ToolProcessPoolManager()
    var processPool = WKProcessPool()
}

private extension NSTabView {
    func addTab(web: NSView, identifier: NSUserInterfaceItemIdentifier) {
        let item = NSTabViewItem(identifier: identifier)
        item.view = web
        addTabViewItem(item)
    }
    
    var selectedItemID: NSUserInterfaceItemIdentifier? {
        return selectedTabViewItem?.identifier as? NSUserInterfaceItemIdentifier
    }
    
    func selectedItem(with identifier: NSUserInterfaceItemIdentifier) {
        selectTabViewItem(withIdentifier: identifier)
    }
}

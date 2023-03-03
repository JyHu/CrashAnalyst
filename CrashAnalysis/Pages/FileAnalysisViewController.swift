//
//  FileAnalysisViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

protocol FileDraggingDelegate {
    func draggingFile(_ fileURL: URL)
}

class FileDraggingStack: NSStackView {
    var draggingDelegate: FileDraggingDelegate?

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let types = sender.draggingPasteboard.types else {
            return []
        }

        return types.contains(.fileURL) ? .copy : []
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pb = sender.draggingPasteboard
        if let filePath = pb.propertyList(forType: .fileURL) as? String {
            if let url = URL(string: filePath) {
                draggingDelegate?.draggingFile(url)
                return true
            }
        }

        return false
    }
}

class FileAnalysisViewController: NSViewController, FileDraggingDelegate {
    @IBOutlet var pathButton: NSButton!
    @IBOutlet var analysisButton: NSButton!
    @IBOutlet var dSymButton: NSButton!

    private var bundleIDReg: NSRegularExpression!
    private var versionReg1: NSRegularExpression!
    private var versionReg2: NSRegularExpression!
    private var addressReg: NSRegularExpression!
    private var codeTypeReg: NSRegularExpression!

    @IBOutlet var actionStack: FileDraggingStack!
    @IBOutlet var pathStack: FileDraggingStack!

    private var dSYM: dSYMModel? {
        didSet {
            guard let dSYM = dSYM else { return }

            pathButton.title = dSYM.location

            let pattern = "\\s+(0x\\w+)\\s+(0x\\w+).*+"

            if let reg = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .anchorsMatchLines]) {
                addressReg = reg
                analysisButton.isEnabled = true
            }
        }
    }

    @IBOutlet var textView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.disableAutomaticOperating()

        let options: NSRegularExpression.Options = [.caseInsensitive, .anchorsMatchLines]
        let bundleIDPattern = "^Identifier:\\s+([\\w-\\.]+)$"
        let versionPattern = "^Version:\\s+([\\d\\.]+)\\s*?\\(([\\w]+)\\)"
        let versionPattern2 = "^Version:\\s+([\\w]+)\\s*?\\(([\\d\\.]+)\\)"
        let codeTypePattern = "^Code\\s+Type:\\s+(.*?)$"

        if let reg = try? NSRegularExpression(pattern: bundleIDPattern, options: options),
           let reg1 = try? NSRegularExpression(pattern: versionPattern, options: options),
           let reg2 = try? NSRegularExpression(pattern: versionPattern2, options: options),
           let reg3 = try? NSRegularExpression(pattern: codeTypePattern, options: options) {
            bundleIDReg = reg
            versionReg1 = reg1
            versionReg2 = reg2
            codeTypeReg = reg3
        }

        guard let attributedString = FileTips.fileTips else {
            return
        }

        textView.textStorage?.setAttributedString(attributedString)

        actionStack.registerForDraggedTypes([.fileURL])
        actionStack.draggingDelegate = self
        pathStack.registerForDraggedTypes([.fileURL])
        pathStack.draggingDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(useDSYMAction), name: .useSelectedDSYM, object: nil)
    }
    
    @objc func useDSYMAction(_ notification: Notification) {
        guard view.window != nil else { return }
        guard let dsym = notification.object as? dSYMModel else { return }
        self.dSYM = dsym
    }

    @IBAction func openDSymPathAction(_ sender: Any) {
        NSWorkspace.shared.open(URL(fileURLWithPath: pathButton.title))
    }

    @IBAction func analysisAction(_ sender: Any) {
        guard let codeTypeRange = codeTypeReg.firstMatch(in: textView.string)?.range(at: 1) else { return }
        guard let codeType = textView.string.sub(range: codeTypeRange) else { return }
        guard let arch = Arch(rawValue: codeType) else { return }
        
        let checkingResults = addressReg.matches(in: textView.string)
        
        let text = textView.string
        let attrContent = NSMutableAttributedString(string: text)

        for index in 0 ..< checkingResults.count {
            let checkingResult = checkingResults[checkingResults.count - 1 - index]
            guard let crashAddress = text.sub(range: checkingResult.range(at: 1)),
                  let slideAddress = text.sub(range: checkingResult.range(at: 2)),
                  let code = dSYM?.analysis(slideAddress: slideAddress, crashAddress: crashAddress, arch: arch) else {
                continue
            }

            let insertLoc = checkingResult.range.location + checkingResult.range.length
            attrContent.insert(" \(code)".colored(.red), at: insertLoc)
        }

        textView.textStorage?.setAttributedString(attrContent)
    }

    @IBAction func findDSymAction(_ sender: Any) {
        analysisButton.isEnabled = false
        pathButton.title = ""
        dSYM = nil

        let text = textView.string

        guard let idRange = bundleIDReg.firstMatch(in: text)?.range(at: 1),
              let (version, build) = compileVersion(text),
              let bundleID = textView.string.sub(range: idRange),
              let dSYM = dSYMManager.shared.dSYMFrom(bundleID: bundleID, version: version, build: build) else {
            return
        }

        self.dSYM = dSYM
    }

    func compileVersion(_ string: String) -> (String, String)? {
        if let versionCheck = versionReg1.firstMatch(in: string) {
            guard let version = string.sub(range: versionCheck.range(at: 1)),
                  let build = string.sub(range: versionCheck.range(at: 2)) else {
                return nil
            }

            return (version, build)
        }

        if let versionCheck = versionReg2.firstMatch(in: string) {
            guard let version = string.sub(range: versionCheck.range(at: 2)),
                  let build = string.sub(range: versionCheck.range(at: 1)) else {
                return nil
            }

            return (version, build)
        }

        return nil
    }

    func draggingFile(_ fileURL: URL) {
        if let content = try? String(contentsOf: fileURL) {
            textView.string = content
        }
    }
}

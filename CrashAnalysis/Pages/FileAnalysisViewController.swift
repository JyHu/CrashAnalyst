//
//  FileAnalysisViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

class FileAnalysisViewController: NSViewController {
        
    @IBOutlet weak var pathButton: NSButton!
    
    @IBOutlet weak var analysisButton: NSButton!
    
    @IBOutlet weak var dSymButton: NSButton!
    

    private var bundleIDReg: NSRegularExpression!
    private var versionReg: NSRegularExpression!
    private var addressReg: NSRegularExpression!
    private var bundleAddress: String?

    private var dSYM: dSYMModel?
    
    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options: NSRegularExpression.Options = [.caseInsensitive, .anchorsMatchLines]
        let bundleIDPattern = "^Identifier:\\s+([\\w-\\.]+)$"
        let versionPattern = "^Version:\\s+([\\d\\.]+)\\s*?\\(([\\w]+)\\)"
        
        if let reg = try? NSRegularExpression(pattern: bundleIDPattern, options: options) {
            bundleIDReg = reg
        }

        if let reg = try? NSRegularExpression(pattern: versionPattern, options: options) {
            versionReg = reg
        }
    }
    
    @IBAction func openAddressAnalysisAction(_ sender: NSButton) {
        NotificationCenter.default.post(name: .switchAnalysis, object: AnalysisType.address)
    }
    
    @IBAction func openDSymPathAction(_ sender: Any) {
        NSWorkspace.shared.open(URL(fileURLWithPath: pathButton.title))
    }
    
    @IBAction func analysisAction(_ sender: Any) {
        let checkingResults = addressReg.matches(in: textView.string)
        
        let text = textView.string
        let attrContent = NSMutableAttributedString(string: text)
        
        for index in 0 ..< checkingResults.count {
            let checkingResult = checkingResults[checkingResults.count - 1 - index]
            guard let crashAddress = text.sub(range: checkingResult.range(at: 1)),
                  let slideAddress = text.sub(range: checkingResult.range(at: 2)),
                  let code = dSYM?.analysis(slideAddress: slideAddress, crashAddress: crashAddress) else {
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

        guard let idRange = bundleIDReg.firstMatch(in: text)?.range(at: 1) else {
            return
        }

        guard let versionCheck = versionReg.firstMatch(in: text) else {
            return
        }

        guard
            let version = text.sub(range: versionCheck.range(at: 1)),
            let build = text.sub(range: versionCheck.range(at: 2)),
            let bundleID = textView.string.sub(range: idRange) else {
            return
        }

        guard let dSYM = dsym(with: bundleID, version: version, build: build) else {
            return
        }

        self.dSYM = dSYM
        pathButton.title = dSYM.location

        let repID = bundleID.replacing(string: ".", target: "\\.")
        let pattern = "\\s*?\\d+\\s*?\(repID)\\s*?(\\w+)\\s*?(\\w+).*+"

        if let reg = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .anchorsMatchLines]) {
            guard let addresRange = reg.firstMatch(in: text)?.range(at: 1) else { return }
            guard let address = text.sub(range: addresRange) else { return }
            analysisButton.isEnabled = true
            bundleAddress = address
            addressReg = reg
        }
    }
    
    private func dsym(with bundleID: String, version: String, build: String) -> dSYMModel? {
        if let dSYM = dSYMManager.shared.dSYMFrom(bundleID: bundleID, version: version, build: build) {
            return dSYM
        }

        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["xcarchive", "dSYM"]
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false

        guard openPanel.runModal() == .OK else {
            return nil
        }

        guard let url = openPanel.url else {
            return nil
        }

        return dSYMManager.shared.append(with: url)
    }
}

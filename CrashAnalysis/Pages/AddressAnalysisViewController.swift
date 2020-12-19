//
//  AddressAnalysisViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

class AddressAnalysisViewController: NSViewController {

    @IBOutlet weak var dsymListButton: NSPopUpButton!
    
    @IBOutlet weak var slideAddressField: NSTextField!
    
    @IBOutlet weak var crashAddressField: NSTextField!
    
    @IBOutlet var resultTextView: NSTextView!
    
    var dsym: dSYMModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadAction()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAction), name: .dsymUpdated, object: nil)
    }
    
    @IBAction func openFileAnalysisAction(_ sender: Any) {
        NotificationCenter.default.post(name: .switchAnalysis, object: AnalysisType.file)
    }
    
    @IBAction func chooiceDSymAction(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.title = "Chooice dSym files or  directory"
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.allowedFileTypes = [ dSYMExtension.dSYM, dSYMExtension.archive ]
        
        guard openPanel.runModal() == .OK else {
            return
        }
        
        let dSYMs = dSYMManager.shared.pickup(at: openPanel.urls)
        
        if dSYMs.count > 0 {        
            reloadAction()
        }
    }
    
    @IBAction func analysisAction(_ sender: Any) {
        guard let slideAddress = legalHexAddress(slideAddressField.stringValue),
              let crashAddress = legalHexAddress(crashAddressField.stringValue) else {
            return
        }
        
        let dsym = dSYMManager.shared.dSYMs[dsymListButton.indexOfSelectedItem]
        let res = dsym.analysis(slideAddress: slideAddress, crashAddress: crashAddress)
        self.resultTextView.string = res ?? ""
    }
}

private extension AddressAnalysisViewController {
    func legalHexAddress(_ address: String) -> String? {
        if address.count == 0 {
            return nil
        }
        
        let addressContent = address.trimming
        
        if addressContent.count == 0 {
            return nil
        }
        
        if addressContent.hasPrefix("0x") || addressContent.hasPrefix("0X") {
            return addressContent
        }
        
        return UInt64(addressContent)?.hexString(prefix: "0x")
    }
    
    @objc func reloadAction() {
        dsymListButton.removeAllItems()
        dsymListButton.addItems(withTitles: dSYMManager.shared.dSYMs.map({ "\($0.identifier) \($0.version)(\($0.build))" }))
    }
}

//
//  AddressAnalysisViewController.swift
//  CrashAnalysis
//
//  Created by 胡金友 on 2020/12/18.
//

import Cocoa

class AddressAnalysisViewController: NSViewController {
    
    @IBOutlet var dsymListButton: NSPopUpButton!
    @IBOutlet var slideAddressField: NSTextField!
    @IBOutlet var crashAddressField: NSTextField!
    @IBOutlet var noteTextView: NSTextView!
    @IBOutlet var historyTextView: NSTextView!
    @IBOutlet var analysisButton: NSButton!
    @IBOutlet weak var archPop: NSPopUpButton!
    
    private var dSYMs: [dSYMModel] = []

    private var preUUID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        noteTextView.disableAutomaticOperating()
        historyTextView.disableAutomaticOperating()

        reloadAction()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadAction), name: .dsymUpdated, object: nil)
    }

    @IBAction func analysisAction(_ sender: NSButton) {
        guard let slideAddress = legalHexAddress(slideAddressField.stringValue),
              let crashAddress = legalHexAddress(crashAddressField.stringValue) else {
            return
        }
        
        guard let dsym = dsymListButton.selectedItem?.representedObject as? dSYMModel else { return }

        sender.isEnabled = false

        let res = dsym.analysis(slideAddress: slideAddress, crashAddress: crashAddress, arch: selectedArch())

        func appendDSYM() {
            let dinfo = "\(dsym.identifier) \(dsym.version)(\(dsym.build)) "
            let attr = [NSAttributedString.Key.link: URL(fileURLWithPath: dsym.location)]

            historyTextView.textStorage?.append(Date.logDate.colored(.secondaryLabelColor))
            historyTextView.textStorage?.append(dinfo.colored(.red))
            historyTextView.textStorage?.append(dsym.location, attributes: attr)
            historyTextView.textStorage?.append("\n")
        }

        if preUUID == nil || dsym.dwarfFiles.first?.uuid != preUUID {
            if preUUID != nil {
                historyTextView.textStorage?.append("\n\n")
            }

            appendDSYM()
            preUUID = dsym.dwarfFiles.first?.uuid
        }

        historyTextView.textStorage?.append(Date.logDate.colored(.secondaryLabelColor))
        let ainfo = "  \(crashAddress)  \(slideAddress)  -->  \(res ?? "")\n"
        historyTextView.textStorage?.append(ainfo)

        sender.isEnabled = true
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

        if addressContent.hasPrefix("0x") ||
            addressContent.hasPrefix("0X") {
            return addressContent
        }

        return UInt64(addressContent)?.hexString(prefix: "0x")
    }

    @objc func reloadAction() {
        dsymListButton.removeAllItems()
        dSYMs = dSYMManager.shared.projs.flatMap({ $0.dSYMs })
        for dSYM in dSYMs {
            let title = "\(dSYM.identifier) \(dSYM.version)(\(dSYM.build))"
            dsymListButton.addItem(withTitle: title)
            dsymListButton.item(withTitle: title)?.representedObject = dSYM
        }
    }
    
    func selectedArch() -> Arch {
        if archPop.indexOfSelectedItem == 0 {
            return .arm64
        }
        return .x86_64
    }
}

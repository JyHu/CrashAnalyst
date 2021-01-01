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
    @IBOutlet var chooiceDSYMButton: NSButton!

    private var preUUID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        noteTextView.disableAutomaticOperating()
        historyTextView.disableAutomaticOperating()

        reloadAction()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadAction), name: .dsymUpdated, object: nil)
    }

    @IBAction func chooiceDSymAction(_ sender: Any) {
        _ = dSYMManager.shared.chooiceDSYM()
    }

    @IBAction func analysisAction(_ sender: NSButton) {
        guard let slideAddress = legalHexAddress(slideAddressField.stringValue),
              let crashAddress = legalHexAddress(crashAddressField.stringValue) else {
            return
        }

        sender.isEnabled = false

        let dsym = dSYMManager.shared.dSYMs[dsymListButton.indexOfSelectedItem]
        let res = dsym.analysis(slideAddress: slideAddress, crashAddress: crashAddress)

        func appendDSYM() {
            let dinfo = "\(dsym.identifier) \(dsym.version)(\(dsym.build)) "
            let attr = [NSAttributedString.Key.link: URL(fileURLWithPath: dsym.location)]

            historyTextView.textStorage?.append(dinfo.colored(.red))
            historyTextView.textStorage?.append(dsym.location, attributes: attr)
            historyTextView.textStorage?.append("\n")
        }

        if preUUID == nil || dsym.uuid != preUUID {
            if preUUID != nil {
                historyTextView.textStorage?.append("\n\n")
            }

            appendDSYM()
            preUUID = dsym.uuid
        }

        let ainfo = "\(crashAddress)  \(slideAddress)  -->  \(res ?? "")\n"
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
        dsymListButton.addItems(
            withTitles: dSYMManager.shared.dSYMs.map({
                "\($0.identifier) \($0.version)(\($0.build))"
            })
        )
    }
}

//
//  AddressAnalysisViewController.swift
//  Analyst
//
//  Created by Jo on 2023/3/4.
//

import Cocoa
import CrashAnalyst


class AddressAnalysisViewController: NSViewController {

    private lazy var projPop = NSPopUpButton(title: "", target: self, action: #selector(chooiceProjAction))
    private lazy var dsymPop = NSPopUpButton(title: "", target: self, action: nil)
    private lazy var archPop = NSPopUpButton(title: "", target: self, action: nil)
    private lazy var analysisButton = ActionButton(target: self, action: #selector(analysisAction))
    private var slideFiled = NSTextField()
    private var crashField = NSTextField()
    private var analysedView = NSTextView(frame: NSMakeRect(0, 0, 100, 100))
    
    private var preUUID: String?
    
    override func loadView() {
        view = NSView(frame: NSMakeRect(0, 0, 100, 100))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        slideFiled.placeholderString = "10进制或16进制地址"
        crashField.placeholderString = "10进制或16进制地址"
        
        archPop.addItem(with: "x86_64", representedObject: dSYMModel.Arch.x86_64)
        archPop.addItem(with: "arm64", representedObject: dSYMModel.Arch.arm64)
        
        analysisButton.translatesAutoresizingMaskIntoConstraints = false
        analysisButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        let dsymStack = NSStackView()
        dsymStack.distribution = .fillEqually
        dsymStack.addView(projPop, in: .leading)
        dsymStack.addView(dsymPop, in: .leading)
        
        analysedView.autoresizingMask = [.width, .height]
        
        let gridView = NSGridView(views: [
            [createLabel("dSYM"), dsymStack, analysisButton],
            [createLabel("Slide Address"), slideFiled],
            [createLabel("Crash Address"), crashField],
            [createLabel("Arch"), archPop]
        ])
        
        gridView.rowSpacing = 0
        gridView.mergeCells(x: 2, xLength: 1, y: 0, yLength: 4)
        gridView.column(at: 0).width = 100
        gridView.column(at: 0).xPlacement = .trailing
        gridView.column(at: 1).xPlacement = .fill
        gridView.column(at: 2).xPlacement = .leading
        gridView.column(at: 2).width = 82
        
        for row in 0..<gridView.numberOfRows {
            let gridRow = gridView.row(at: row)
            gridRow.yPlacement = .center
            gridRow.height = 30
        }
        
        let scrollView = NSScrollView(documentView: analysedView, isHorizontal: false)
        view.layout(subViews: ["g": gridView, "t": scrollView], vfls: [
            "H:|[g]|", "H:|[t]|", "V:|-10-[g]-10-[t]|"
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(dsymListChangedAction), name: CrashAnalyst.dSYMListUpdated, object: nil)
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
    
    func selectedArch() -> dSYMModel.Arch {
        return archPop.selectedItem?.representedObject as? dSYMModel.Arch ?? .x86_64
    }
}

private extension AddressAnalysisViewController {
    func createLabel(_ stringValue: String) -> NSTextField {
        let label = NSTextField(labelWithString: stringValue)
        label.textColor = .secondaryLabelColor
        return label
    }
    
    @objc func chooiceProjAction(_ popup: NSPopUpButton) {
        guard let identifier = popup.selectedItem?.representedObject as? String else { return }
        guard let proj = CrashAnalyst.shared.projs.first(where: { $0.bundleID == identifier }) else { return }
        dsymPop.removeAllItems()
        
        for dsym in proj.dSYMs {
            dsymPop.addItem(with: "\(dsym.version) (\(dsym.build))", representedObject: dsym)
        }
    }
    
    @objc func analysisAction(_ sender: NSButton) {
        guard let slideAddress = legalHexAddress(slideFiled.stringValue),
              let crashAddress = legalHexAddress(crashField.stringValue) else {
            return
        }
        
        guard let dsym = dsymPop.selectedItem?.representedObject as? dSYMModel else { return }

        func appendDSYM() {
            let dinfo = " \(dsym.bundleID) \(dsym.version)(\(dsym.build))"

            analysedView.textStorage?.append(Date.logDate, attributes: [ .font: NSFont.default, .foregroundColor: NSColor.secondaryLabelColor ])
            analysedView.textStorage?.append(dinfo, attributes: [.font: NSFont.default, .foregroundColor: NSColor.red])
            analysedView.textStorage?.append(dsym.location, attributes: [NSAttributedString.Key.link: URL(fileURLWithPath: dsym.location), .font: NSFont.default])
            analysedView.textStorage?.append("\n")
        }

        if preUUID == nil || dsym.dwarfFiles.first?.uuid != preUUID {
            if preUUID != nil {
                analysedView.textStorage?.append("\n\n")
            }

            appendDSYM()
            preUUID = dsym.dwarfFiles.first?.uuid
        }

        let arch = selectedArch()
        sender.isEnabled = false
        
        Task {
            let res = await dsym.analysis(slideAddress: slideAddress, crashAddress: crashAddress, arch: arch)
            
            DispatchQueue.main.async {
                self.analysedView.textStorage?.append(Date.logDate, attributes: [ .font: NSFont.default, .foregroundColor: NSColor.secondaryLabelColor ])
                let ainfo = " \(crashAddress) \(slideAddress)  >  \(res ?? "")\n"
                self.analysedView.textStorage?.append(ainfo, attributes: [.font: NSFont.default, .foregroundColor: NSColor.textColor])

                sender.isEnabled = true
            }
        }
    }
    
    @objc func dsymListChangedAction() {
        projPop.removeAllItems()
        for proj in CrashAnalyst.shared.projs {
            projPop.addItem(with: proj.bundleID, representedObject: proj.bundleID)
        }
        
        chooiceProjAction(projPop)
    }
}

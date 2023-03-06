//
//  FileAnalysisViewController.swift
//  Analyst
//
//  Created by Jo on 2023/3/4.
//

import Cocoa
import CrashAnalyst

private class MyTextView: NSTextView {
    override func pasteAsRichText(_ sender: Any?) {
        pasteAsPlainText(sender)
    }
    
    override func paste(_ sender: Any?) {
        pasteAsPlainText(sender)
    }
}

class FileAnalysisViewController: NSViewController {

    private lazy var anaButton = ActionButton(target: self, action: #selector(analysisAction))
    private var textView = MyTextView(frame: NSMakeRect(0, 0, 100, 100))
    private var dsymLabel = NSTextField(labelWithString: "")
    
    override func loadView() {
        view = NSView(frame: NSMakeRect(0, 0, 100, 100))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        dsymLabel.stringValue = "path/to/dsymfile"
        dsymLabel.font = .default
        dsymLabel.textColor = .secondaryLabelColor
        
        textView.font = NSFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        textView.autoresizingMask = [.width, .height]
        
        let scrollView = NSScrollView(documentView: textView, isHorizontal: false)
        
        view.layout(subViews: ["s": scrollView, "a": anaButton, "l": dsymLabel], vfls: [
            "H:|-10-[l]-10-[a(90)]-10-|", "H:|[s]|", "V:|-10-[a(27)]-10-[s]|"
        ])
        
        dsymLabel.centerYAnchor.constraint(equalTo: anaButton.centerYAnchor).isActive = true
    }
}

private extension FileAnalysisViewController {
    @objc func analysisAction() {
        guard let dSYM = CrashAnalyst.shared.dSYMOf(crashFile: textView.string) else { return }
        
        anaButton.isEnabled = false
        textView.isEditable = false
        
        dsymLabel.stringValue = dSYM.path
        let crashContent = textView.string
        
        Task {
            let res = await dSYM.analysis(crashFile: crashContent)
            
            DispatchQueue.main.async {
                self.textView.string = res
                self.anaButton.isEnabled = true
                self.textView.isEditable = true
            }
        }
    }
}

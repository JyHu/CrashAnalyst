//
//  ActionButton.swift
//  Analyst
//
//  Created by Jo on 2023/3/5.
//

import Cocoa

public class ActionButton: NSControl {
    private var titleLabel = NSTextField(labelWithString: "Analysis")
    
    public init(target: AnyObject, action: Selector) {
        super.init(frame: NSMakeRect(0, 0, 100, 100))
        titleLabel.textColor = .white
        titleLabel.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .medium)
        layoutCenter(subView: titleLabel, horizontalPadding: 8)
        wantsLayer = true
        layer?.cornerRadius = 5
        layerBackgroundColor = .systemBlue
        add(target: target, action: action)
    }
    
    public override var isEnabled: Bool {
        didSet {
            if isEnabled {
                layerBackgroundColor = .systemBlue
            } else {
                layerBackgroundColor = .systemBlue.withSystemEffect(.disabled)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateTrackingAreas() {
        addCustomizedTrackingArea()
    }
    
    public override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        if !isEnabled { return }
        layerBackgroundColor = .systemBlue.withSystemEffect(.pressed)
    }
    
    public override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        if !isEnabled { return }
        layerBackgroundColor = .systemBlue
    }
    
    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if !isEnabled { return }
        layerBackgroundColor = .systemBlue.withSystemEffect(.deepPressed)
    }
    
    public override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        if !isEnabled { return }
        layerBackgroundColor = .systemBlue.withSystemEffect(.pressed)
        sendAction(action, to: target)
    }
}


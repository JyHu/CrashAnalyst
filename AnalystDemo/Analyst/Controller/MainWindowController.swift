//
//  MainWindowController.swift
//  Analyst
//
//  Created by Jo on 2023/3/4.
//

import Cocoa
import SwiftExtensions
import SFSymbols
import CrashAnalyst

private extension NSToolbar.Identifier {
    static let mainToolbar = NSToolbar.Identifier("mainToolbar")
}

private extension NSToolbarItem.Identifier {
    static let analysisGroup = NSToolbarItem.Identifier("com.auu.analyst.analysisGroup")
    static let visibleGroup = NSToolbarItem.Identifier("com.auu.analyst.visibleGroup")
    static let customSpace = NSToolbarItem.Identifier("com.auu.analyst.customSpace")
    static let loadGroup = NSToolbarItemGroup.Identifier("com.auu.analyst.loadGroup")
}

class MainWindowController: NSWindowController {
    init() {
        super.init(window: MainWindow())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let defaultToolBarItems: [NSToolbarItem.Identifier] = [
    .analysisGroup,
    .customSpace,
    .visibleGroup,
    .customSpace,
    .loadGroup,
    .customSpace
]

private class MainWindow: NSWindow, NSToolbarDelegate {
    var projectListPage = ProjectListViewController()
    var fileAnalysisPage = FileAnalysisViewController()
    var addressAnalysisPage = AddressAnalysisViewController()
    var logPage = LogViewController()
    
    var mainTabPage = MainTabViewController()
    
    var mainSplit = NSSplitViewController()
    var analysisSplit = NSSplitViewController()
    
    init() {
        let styleMasks: NSWindow.StyleMask = [.titled, .closable, .resizable, .miniaturizable]
        super.init(contentRect: NSMakeRect(0, 0, 720, 540), styleMask: styleMasks, backing: .buffered, defer: true)
        contentViewController = mainSplit
        
        let bar = NSToolbar(identifier: .mainToolbar)
        bar.delegate = self
        bar.displayMode = .iconOnly
        bar.sizeMode = .default
        bar.showsBaselineSeparator = true
        toolbar = bar
        
        title = "Crash Analyst"
        contentViewController = mainSplit
        minSize = NSMakeSize(720, 540)
        setFrame(NSMakeRect(0, 0, 720, 540), display: true)
        titlebarSeparatorStyle = .line
        toolbarStyle = .unifiedCompact
        
        center()
        
        mainTabPage.tabView.addTabbed(viewController: addressAnalysisPage)
        mainTabPage.tabView.addTabbed(viewController: fileAnalysisPage)
        
        analysisSplit.isVertical = false
        analysisSplit.add(mainTabPage, minThickness: 200)
        analysisSplit.add(logPage, minThickness: 100)
        
        let sideBarItem = NSSplitViewItem(sidebarWithViewController: projectListPage)
        sideBarItem.minimumThickness = 200
        sideBarItem.maximumThickness = 400
        
        mainSplit.isVertical = true
        mainSplit.addSplitViewItem(sideBarItem)
        mainSplit.add(analysisSplit, minThickness: 300)
    }
    
    // MARK: - NSToolbarDelegate
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return defaultToolBarItems
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return defaultToolBarItems
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        if itemIdentifier == .analysisGroup {
            guard let fileImage = SFSymbol.docTextMagnifyingglass.image,
                  let addressImage = SFSymbol.textMagnifyingglass.image else { return nil }
            let itemGroup = NSToolbarItemGroup(itemIdentifier: .analysisGroup, images: [addressImage, fileImage], selectionMode: .selectOne, labels: nil, target: self, action: #selector(chooiceAnalysisAction))
            itemGroup.selectedIndex = 0
            return itemGroup
        }
        
        if itemIdentifier == .visibleGroup {
            guard let bottom = SFSymbol.rectangleBottomhalfInsetFilled.image,
                  let left = SFSymbol.rectangleLefthalfInsetFilled.image else { return nil }
            
            let itemGroup = NSToolbarItemGroup(itemIdentifier: .visibleGroup, images: [left, bottom], selectionMode: .selectAny, labels: nil, target: self, action: #selector(toggleVisibleAction))
            itemGroup.setSelected(true, at: 0)
            itemGroup.setSelected(true, at: 1)
            return itemGroup
        }
        
        if itemIdentifier == .loadGroup {
            guard let chooiceFileImage = SFSymbol.folder.image, let loadDefaultImage = SFSymbol.archivebox.image else { return nil }
            
            return NSToolbarItemGroup(itemIdentifier: itemIdentifier, images: [chooiceFileImage, loadDefaultImage], selectionMode: .momentary, labels: nil, target: self, action: #selector(loadFilesAction))
        }
        
        if itemIdentifier == .customSpace {
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.view = NSView(frame: NSMakeRect(0, 0, 1, 1))
            return item
        }
        
        return NSToolbarItem(itemIdentifier: itemIdentifier)
    }
}

private extension MainWindow {
    @objc func chooiceAnalysisAction(_ itemGroup: NSToolbarItemGroup) {
        mainTabPage.tabView.selectTabViewItem(at: itemGroup.selectedIndex)
    }
    
    @objc func chooiceDSYMFilesAction() {
        CrashAnalyst.shared.chooiceDSYM()
    }
    
    @objc func toggleVisibleAction(_ itemGroup: NSToolbarItemGroup) {
        mainSplit.splitViewItems.first?.isCollapsed = !itemGroup.isSelected(at: 0)
        analysisSplit.splitViewItems.last?.isCollapsed = !itemGroup.isSelected(at: 1)
    }
    
    @objc func loadDefaultArchivesAction() {
        CrashAnalyst.shared.loadArchives()
    }
    
    @objc func loadFilesAction(_ itemGroup: NSToolbarItemGroup) {
        if itemGroup.selectedIndex == 0 {
            CrashAnalyst.shared.chooiceDSYM()
        } else if itemGroup.selectedIndex == 1 {
            CrashAnalyst.shared.loadArchives()
        }
    }
}

private class MainTabViewController: NSViewController {
    var tabView = NSTabView(frame: NSMakeRect(0, 0, 100, 100))
    
    override func loadView() {
        view = NSView(frame: NSMakeRect(0, 0, 100, 100))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.tabViewType = .noTabsNoBorder
        view.layout(subView: tabView)
    }
}

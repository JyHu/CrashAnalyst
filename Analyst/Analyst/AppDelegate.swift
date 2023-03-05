//
//  AppDelegate.swift
//  Analyst
//
//  Created by Jo on 2023/3/4.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    private lazy var mainWindowController = MainWindowController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController.window?.makeKeyAndOrderFront(nil)
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            mainWindowController.window?.makeKeyAndOrderFront(nil)
        }
        
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}


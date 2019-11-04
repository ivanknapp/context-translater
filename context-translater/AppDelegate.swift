//
//  AppDelegate.swift
//  context-translater
//
//  Created by Иван Кнапп on 04/11/2019.
//  Copyright © 2019 Иван Кнапп. All rights reserved.
//

import Cocoa
import HotKey
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let pasteboard = NSPasteboard.general

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if Storage.fileExists("globalKeybind.json", in: .documents) {
            let globalKeybinds = Storage.retrieve("globalKeybind.json", from: .documents, as: GlobalKeybindPreferences.self)
            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: globalKeybinds.keyCode, carbonModifiers: globalKeybinds.carbonFlags))
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    public var hotKey: HotKey? {
            didSet {
                guard let hotKey = hotKey else {
                    return
                }
                hotKey.keyDownHandler = { [weak self] in
                    NSApplication.shared.orderedWindows.forEach({ (window) in
                        if let mainWindow = window as? Screen {
                            NSApplication.shared.activate(ignoringOtherApps: true)
                            mainWindow.makeKeyAndOrderFront(self)
                            mainWindow.makeKey()
                            let contr = mainWindow.contentViewController as! TargetViewController
    //                        self?.copyText()
                            contr.translate(self?.paste())
                        }
                    })
                }
            }
        }
        
        func copyText() {
            
            // Clear pasteboard
            pasteboard.clearContents()
            
            let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

            let cmdu = CGEvent(keyboardEventSource: src, virtualKey: 0x37, keyDown: false)

            let c_down = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: true)
            let c_up = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: false)

            // Set Flags
            c_down?.flags = CGEventFlags.maskCommand
            c_up?.flags = CGEventFlags.maskCommand

            let loc = CGEventTapLocation.cghidEventTap

            c_down?.post(tap: loc)
            c_up?.post(tap: loc)
            cmdu?.post(tap: loc)
        }


        func paste() -> String {
            let lengthOfPasteboard = pasteboard.pasteboardItems!.count
            var theText = ""
            if lengthOfPasteboard > 0 {
                theText = pasteboard.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text"))!
            } else {
                theText = "Nothing Coppied"
            }

            return theText
        }
}


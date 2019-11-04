//
//  PreferencesWindowController.swift
//  context-translater
//
//  Created by Иван Кнапп on 28/09/2019.
//  Copyright © 2019 Иван Кнапп. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        let vc = self.contentViewController as! PreferencesViewController
        let listen = vc.listening
        if listen {
            vc.updateGlobalShortcut(event)
        }
    }
}

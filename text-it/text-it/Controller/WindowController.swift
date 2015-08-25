//
//  WindowController.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/29/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSToolbarDelegate, NSMenuDelegate {

    @IBOutlet weak var toolBar: NSToolbar!
    @IBOutlet weak var pushToolBarItem: NSToolbarItem!
    @IBOutlet weak var recordToolBarItem: NSToolbarItem!
    
    var viewController: ViewController {
        get {
            return self.window!.contentViewController! as! ViewController
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.toolBar.delegate = self
        self.pushToolBarItem.enabled = false
        self.recordToolBarItem.enabled = false
        self.viewController.toolBar = self.toolBar
        self.viewController.pushToolBarItem = self.pushToolBarItem
        self.viewController.recordToolBarItem = self.recordToolBarItem
    }
    
    override func validateToolbarItem(theItem: NSToolbarItem) -> Bool {
        if ((theItem.tag == 101) || (theItem.tag == 102))
        {
            return false
        }
        return true
    }
    
    
    @IBAction func buttonPressed(sender: NSButton) {
        println(sender)
    }
}

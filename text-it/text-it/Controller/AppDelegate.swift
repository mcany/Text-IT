//
//  AppDelegate.swift
//  text-it
//
//  Created by Mertcan Yigin on 5/29/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    @IBOutlet weak var newFileMenuItem: NSMenuItem!
    @IBOutlet weak var newFolderMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func menuItemPressed(sender: AnyObject) {
        if let window = NSApplication.sharedApplication().mainWindow {
            if let viewController = window.contentViewController as? ViewController {
                // do stuff
            }
        }
    }
}


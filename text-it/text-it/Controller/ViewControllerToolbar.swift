//
//  ViewControllerToolbar.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/26/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

extension ViewController: NSWindowDelegate {
    
    func pushButtonTapped(toolbarItem: NSToolbarItem) {
        println("pushButtonTapped")
        self.sendMessage()
    }
    
    
    func recordButtonTapped(toolbarItem: NSToolbarItem) {
        println("recordButtonTapped")
        self.startReceivingData()
    }
}

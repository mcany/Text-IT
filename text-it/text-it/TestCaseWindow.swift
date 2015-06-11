//
//  TestCaseWindow.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/10/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore


@objc(TestCaseWindowController) class TestCaseWindowController: NSWindowController {

    @IBOutlet var codeTextView: NSTextView!
    
    @IBOutlet weak var funcName: NSTextField!
    
    var context: JSContext!
    var testCase: TestCase!
    
    func setJSContext(context: JSContext)
    {
        self.context = context
    }
    
    func settestCase(testCase: TestCase)
    {
        self.testCase = testCase
        
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        //self.codeTextView.string = "function(){\n\n\n};"
        self.codeTextView.string = ""
        self.funcName.stringValue = ""
        if self.testCase != nil
        {
            self.funcName.stringValue = self.testCase.name
            self.codeTextView.string = self.testCase.code
        }
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        var userInput = self.codeTextView.string
        var newJSFunction = "var " + self.funcName.stringValue + " = function(){" + userInput! + "}"
        var result = self.context.evaluateScript(newJSFunction)

        if(!result.toString().hasPrefix("JS Error"))
        {
            
            self.testCase.code = userInput!
            self.testCase.name = self.funcName.stringValue
            println(self.context.evaluateScript(testCase.name+"()"))
            self.close()
        }

    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.close()
    }
}

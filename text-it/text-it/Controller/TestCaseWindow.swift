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
    
    var testCase: TestCase!
    
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
        var result = JavascriptRunner.sharedInstance.executeMain(newJSFunction)
        self.checkIfFunctionValid(result)
        
        //JavascriptRunner.sharedInstance.execute(newJSFunction){result in self.checkIfFunctionValid(result)}
    }
    
    func checkIfFunctionValid(result: JSValue?)
    {
        if(!result!.toString().hasPrefix("JS Error"))
        {
            self.testCase.code = self.codeTextView.string!
            self.testCase.name = self.funcName.stringValue
            JavascriptRunner.sharedInstance.execute(testCase.name+"()"){result in println (result)}
//            println(JavascriptRunner.sharedInstance.execute(testCase.name+"()"))
            ViewControllerOutlineView.sharedInstance.testCaseComponent.methodNames.append(SubComponentModel(name: self.testCase.name))
            self.close()
        }
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.close()
    }
}

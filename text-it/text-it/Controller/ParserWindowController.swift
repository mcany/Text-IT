//
//  ParserWindowController.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/30/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

@objc(ParserWindowController) class ParserWindowController: NSWindowController {

    var parser: CustomParser!

    @IBOutlet weak var view: NSView!
    @IBOutlet var codeTextView: NSTextView!
    @IBOutlet weak var funcName: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.codeTextView.string = ""
        self.funcName.stringValue = ""
        if self.parser != nil
        {
            self.funcName.stringValue = self.parser.name
            self.codeTextView.string = self.parser.code
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
            self.parser.code = self.codeTextView.string!
            self.parser.name = self.funcName.stringValue
            JavascriptRunner.sharedInstance.execute(parser.name+"()"){result in println (result)}
            //println(JavascriptRunner.sharedInstance.execute(parser.name+"()"))
            //ViewControllerOutlineView.sharedInstance.parserComponent.methodNames.append(SubComponentModel(name: self.parser.name))
            self.close()
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.close()
    }
}

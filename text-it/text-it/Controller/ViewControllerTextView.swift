//
//  ViewControllerTextView.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/29/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

extension ViewController: NSTextViewDelegate, ExceptionHandler {
    
    
    func handleException(exception: JSValue) -> Void {
        println("JS Error: \(exception)")
        if (self.debugTextView.string?.hasSuffix("JS Error: \(exception)") != true)
        {
            self.debugTextView.string = self.debugTextView.string! + "JS Error: \(exception)\n"
            self.debugTextView.scrollRangeToVisible(NSRange(location: count(self.debugTextView.string!), length: 0))
        }
    }
    
    func printResult(result: JSValue?)
    {
        dispatch_async(dispatch_get_main_queue(), {
            println(result)
            
            if(!result!.toString().hasPrefix("undefined") && self.printResult)
            {
                self.debugTextView.string = self.debugTextView.string! + result!.toString() + "\n"
                self.debugTextView.scrollRangeToVisible(NSRange(location: count(self.debugTextView.string!), length: 0))
                self.printResult = false
            }
        })
    }
    
    func readCurrentFile()
    {
        var file = File();
        //var savedCode = file.read(Constants.Path.FullPath.stringByAppendingPathComponent(self.currentFile))
        var savedCode = file.read(self.currentFile)
        self.codeTextView.string = savedCode!
    }
    
    func writeToCurrentFile()
    {
        if (self.codeChanged)
        {
            dispatch_async(self.queue) {
                self.codeChanged = false
                self.writeLoop = true
                var file = File()
                file.write(Constants.Path.FullPath.stringByAppendingPathComponent(self.currentFile), data: self.codeTextView.string)
                //file.write((self.currentFile), data: self.codeTextView.string)
                dispatch_async(dispatch_get_main_queue(), {self.writeLoop = false; if(self.codeChanged){self.writeToCurrentFile()}})
            }
        }
    }
    
    func textDidChange(notification: NSNotification) {
        var textView = notification.object as! NSTextView
        if(textView == self.codeTextView)
        {
            
            JavascriptRunner.sharedInstance.executionCode = textView.string!
            self.codeChanged = true
            if !self.writeLoop
            {
                self.writeToCurrentFile()
            }
            var codeWithoutWhitespaceAndNewline = textView.string?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if codeWithoutWhitespaceAndNewline!.hasSuffix(";")
            {
                self.printResult = true
                // var result = JavascriptRunner.sharedInstance.execute(codeWithoutWhitespaceAndNewline!)
                
                //JavascriptRunner.sharedInstance.execute(codeWithoutWhitespaceAndNewline!){result in self.printResult(result)}
                
                
            }
            else
            {
                self.printResult = false
            }
            
            /*
            var fullCode: String = codeWithoutWhitespaceAndNewline!
            
            let lastCodeArray = fullCode.componentsSeparatedByString(";")
            println(lastCodeArray)
            
            if(lastCodeArray.count > 1)
            {
            var lastCode: String = lastCodeArray[lastCodeArray.count - 2]
            
            println(lastCode)
            //println(context.evaluateScript(lastCode))
            
            
            //println(fullCode)De
            var result = self.context.evaluateScript(lastCode)
            println(result)
            if(!result.toString().hasPrefix("undefined"))
            {
            self.debugTextView.string = self.debugTextView.string! + result.toString() + "\n"
            self.debugTextView.scrollRangeToVisible(NSRange(location: count(self.debugTextView.string!), length: 0))
            }
            }
            }
            else if (self.codeTextView.string?.isEmpty == true)
            {
            self.debugTextView.string = ""
            }
            */
            
            if (self.codeTextView.string?.isEmpty == true)
            {
                self.debugTextView.string = ""
            }
            
        }
        else if(textView == self.debugTextView)
        {
            
        }
    }
}

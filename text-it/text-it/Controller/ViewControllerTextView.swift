//
//  ViewControllerTextView.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/29/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

extension ViewController: NSTextViewDelegate {
    
    func textDidChange(notification: NSNotification) {
        var textView = notification.object as! NSTextView
        if(textView == self.codeTextView)
        {
            var codeWithoutWhitespaceAndNewline = textView.string?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if codeWithoutWhitespaceAndNewline!.hasSuffix(";")
            {
                var fullCode: String = codeWithoutWhitespaceAndNewline!
                
                let lastCodeArray = fullCode.componentsSeparatedByString(";")
                println(lastCodeArray)
                
                if(lastCodeArray.count > 1)
                {
                    var lastCode: String = lastCodeArray[lastCodeArray.count - 2]
                    
                    println(lastCode)
                    //println(context.evaluateScript(lastCode))
                    
                    
                    //println(fullCode)
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
        }
        else if(textView == self.debugTextView)
        {
            
        }
    }
}

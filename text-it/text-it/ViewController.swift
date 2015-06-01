//
//  ViewController.swift
//  text-it
//
//  Created by Mertcan Yigin on 5/29/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

class ViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet var codeTextView: NSTextView!
    @IBOutlet weak var palletTableView: NSTableColumn!
    var context: JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = JSContext()

        // Do any additional setup after loading the view.
        self.codeTextView.delegate = self
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    

    
    func textDidChange(notification: NSNotification) {
        if codeTextView.string!.hasSuffix("\n")
        {
            var fullCode: String = codeTextView.string!
            let lastCodeArray = fullCode.componentsSeparatedByString("\n")
            
            if(lastCodeArray.count > 1)
            {
                var lastCode: String = lastCodeArray[lastCodeArray.count - 2]
                
               // println(lastCode)
                //println(context.evaluateScript(lastCode))
            }
            
            println(fullCode)
            println(context.evaluateScript(fullCode))
        }
    }
}


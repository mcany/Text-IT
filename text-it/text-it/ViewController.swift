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
    
    @IBOutlet weak var codeScrollView: NSScrollView!
    @IBOutlet var codeTextView: NSTextView!
    @IBOutlet weak var palletTableView: NSTableColumn!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var lineNumberView: NoodleLineNumberView!
    var context: JSContext!
    var dataLoader: DataLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataLoader = DataLoader()
        self.context = JSContext()
        self.addFunctionsToJSContext()
        
        self.codeTextView.delegate = self
        self.codeTextView.font = NSFont.userFixedPitchFontOfSize(NSFont.smallSystemFontSize())
        
        //line number view
        self.lineNumberView = MarkerLineNumberView(scrollView: self.codeScrollView)
        self.codeScrollView.verticalRulerView = self.lineNumberView
        self.codeScrollView.hasHorizontalRuler = false
        self.codeScrollView.hasVerticalRuler = true
        self.codeScrollView.rulersVisible = true
        
        
        if let lineChart = lineChartView.layer as? LineChart {
            let data: [CGFloat] = [3.0, 4.0, 9.0, 11.0, 13.0, 15.0]
            lineChart.datasets += [ LineChart.Dataset(label: "My Data", data: data) ]
        }
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
    
    
    func addFunctionsToJSContext()
    {
        let loadData: @objc_block String -> String = { input in
            return self.dataLoader.loadAccelerometerData(input)
        }
        
        context.setObject(unsafeBitCast(loadData, AnyObject.self), forKeyedSubscript: "loadData")

        let simplifyString: @objc_block String -> String = { input in
            return self.simple(input)
        }
        context.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "simplifyString")
        

    }
    

    func simple(str: String) -> String
    {
        var mutableString = NSMutableString(string: str) as CFMutableStringRef
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, Boolean(0))
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, Boolean(0))
        return mutableString as String
    }
}


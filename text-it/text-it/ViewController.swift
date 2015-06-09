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
    @IBOutlet var debugTextView: NSTextView!
    
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
        self.codeTextView.automaticQuoteSubstitutionEnabled = false
        
        self.debugTextView.delegate = self
        self.debugTextView.font = NSFont.userFixedPitchFontOfSize(NSFont.smallSystemFontSize())
        self.debugTextView.editable = false
        
        //line number view
        self.lineNumberView = MarkerLineNumberView(scrollView: self.codeScrollView)
        self.codeScrollView.verticalRulerView = self.lineNumberView
        self.codeScrollView.hasHorizontalRuler = false
        self.codeScrollView.hasVerticalRuler = true
        self.codeScrollView.rulersVisible = true
        
        
        if let lineChart = lineChartView.layer as? LineChart {
            let data: [CGFloat] = [3.0, 4.0, 9.0, 11.0, 13.0, 15.0]
            lineChart.datasets += [ LineChart.Dataset(label: "Test Data", data: data) ]
        }
    }

    func textDidChange(notification: NSNotification) {
        var textView = notification.object as! NSTextView
        if(textView == self.codeTextView)
        {
            if self.codeTextView.string!.hasSuffix("\n")
            {
                var fullCode: String = self.codeTextView.string!

                let lastCodeArray = fullCode.componentsSeparatedByString("\n")
                
                if(lastCodeArray.count > 1)
                {
                    var lastCode: String = lastCodeArray[lastCodeArray.count - 2]
                    
                    // println(lastCode)
                    //println(context.evaluateScript(lastCode))
                }
                
                println(fullCode)
                var result = self.context.evaluateScript(fullCode)
                println(result)
                if(!result.toString().hasPrefix("undefined"))
                {
                    self.debugTextView.string =  result.toString()
                    
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
    
    func addFunctionsToJSContext()
    {
        self.context.exceptionHandler = { context, exception in
            println("JS Error: \(exception)")
            if (self.debugTextView.string?.hasSuffix("JS Error: \(exception)") != true)
            {
                self.debugTextView.string = self.debugTextView.string! + "\nJS Error: \(exception)"
                self.debugTextView.scrollRangeToVisible(NSRange(location: count(self.debugTextView.string!), length: 0))
            }
        }
        
        let loadData: @objc_block String -> [CGFloat] = { input in
            return self.dataLoader.loadAccelerometerData(input)
        }
        self.context.setObject(unsafeBitCast(loadData, AnyObject.self), forKeyedSubscript: "loadData")
        
        let simplifyString: @objc_block String -> String = { input in
            return self.simple(input)
        }
        self.context.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "simplifyString")
        
        let displayData: @objc_block [CGFloat] -> () = { input in
            return self.display(input)
        }
        self.context.setObject(unsafeBitCast(displayData, AnyObject.self), forKeyedSubscript: "displayData")
        
        // export JS class
        self.context.setObject(LowPassFilter.self, forKeyedSubscript: "LowPassFilter")
        self.context.setObject(RCFilter.self, forKeyedSubscript: "RCFilter")
        
        //test
        var co = LowPassFilter()
        self.context.globalObject.setValue(co, forProperty: "lowPassFilter")
    }
    
    
    func display(accData: [CGFloat])
    {
        if let lineChart = lineChartView.layer as? LineChart {
            //let data: [CGFloat] = [3.0, 4.0, 9.0, 11.0, 13.0, 15.0]
            //let count = accData.count / sizeof(CGFloat)
            
            // create array of appropriate length:
            //var array = [CGFloat](count: count, repeatedValue: 0)
            
            // copy bytes into array
            //accData.getBytes(&array, length:count * sizeof(CGFloat))
            //println(array)
            let dataset1 = LineChart.Dataset(label: "My Data", data: accData)
            dataset1.color = NSColor.redColor().CGColor
            dataset1.fillColor = nil
            dataset1.curve = .Bezier(0.3)
            lineChart.datasets = [dataset1]
        }
        //return accData
    }
    
    func simple(str: String) -> String
    {
        var mutableString = NSMutableString(string: str) as CFMutableStringRef
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, Boolean(0))
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, Boolean(0))
        return mutableString as String
    }
}


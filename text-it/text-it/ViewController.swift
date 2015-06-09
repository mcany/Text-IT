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
        self.codeTextView.automaticQuoteSubstitutionEnabled = false

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
        self.context.exceptionHandler = { context, exception in
            println("JS Error: \(exception)")
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


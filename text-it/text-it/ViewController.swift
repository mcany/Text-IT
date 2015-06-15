//
//  ViewController.swift
//  text-it
//
//  Created by Mertcan Yigin on 5/29/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

class ViewController: NSViewController, NSTextViewDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    @IBOutlet weak var codeScrollView: NSScrollView!
    @IBOutlet var codeTextView: NSTextView!
    @IBOutlet weak var palletTableView: NSTableColumn!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet var debugTextView: NSTextView!
    
    var lineNumberView: NoodleLineNumberView!
    var context: JSContext!
    var dataLoader: DataLoader!
    //test
    var items: [String] = ["Item 1", "Item 2", "Item is an item", "Thing"]
    let featurExtractionComponent : ComponentModel = ComponentModel(name: "Feature Extraction");
    let filterComponent:ComponentModel = ComponentModel(name: "Filter");
    let testCaseComponent : ComponentModel  = ComponentModel(name: "Test Case");
    
    @IBOutlet weak var componentOutlineView: NSOutlineView!
    
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
        
        //test items
        self.componentOutlineView.setDataSource(self)
        self.componentOutlineView.setDelegate(self)
        self.featurExtractionComponent.methodNames.append("Mean")
        self.featurExtractionComponent.methodNames.append("Median")
        
        self.filterComponent.methodNames.append("RC Filter")
        self.filterComponent.methodNames.append("LowPass Filter")
        
        self.testCaseComponent.methodNames.append("New Test")
    }
    
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
    
    func addFunctionsToJSContext()
    {
        self.context.exceptionHandler = { context, exception in
            println("JS Error: \(exception)")
            if (self.debugTextView.string?.hasSuffix("JS Error: \(exception)") != true)
            {
                self.debugTextView.string = self.debugTextView.string! + "JS Error: \(exception)\n"
                self.debugTextView.scrollRangeToVisible(NSRange(location: count(self.debugTextView.string!), length: 0))
            }
        }
        
        let loadData: @objc_block String -> [CGFloat] = { input in
            return self.dataLoader.loadAccelerometerData(input)
        }
        self.context.setObject(unsafeBitCast(loadData, AnyObject.self), forKeyedSubscript: "loadData")
        
        let displayData: @objc_block [CGFloat] -> () = { input in
            return self.display(input)
        }
        self.context.setObject(unsafeBitCast(displayData, AnyObject.self), forKeyedSubscript: "displayData")
        
        // export JS class
        self.context.setObject(LowPassFilter.self, forKeyedSubscript: "LowPassFilter")
        self.context.setObject(RCFilter.self, forKeyedSubscript: "RCFilter")
        self.context.setObject(Evaluator.self, forKeyedSubscript: "Evaluator")
        self.context.setObject(TestCase.self, forKeyedSubscript: "TestCase")
        TestCase.staticContext = self.context
        
        //test
        var co = LowPassFilter()
        self.context.globalObject.setValue(co, forProperty: "lowPassFilter")
        if let lineChart = lineChartView.layer as? LineChart {
            let data: [CGFloat] = [3.0, 4.0, 9.0, 11.0, 13.0, 15.0]
            let dataset1 = LineChart.Dataset(label: "My Data", data: data)
            lineChart.datasets = [dataset1]
            self.context.globalObject.setValue(lineChart, forProperty: "lineChart")
            self.context.globalObject.setValue(dataset1, forProperty: "dataSet")
        }
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
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        println("child:ofItem")
        if let it: AnyObject = item {
            switch it {
            case let c as ComponentModel: // This works even though NSMutableArray is more accurate
                return c.methodNames[index]
            default:
                assert(false, "outlineView:index:item: gave a dud item")
                return self
            }
        } else {
            switch index {
            case 0:
                return featurExtractionComponent
            case 1:
                return filterComponent
            default:
                return testCaseComponent
            }
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        println("isItemExpandable")
        switch item {
        case let c as ComponentModel:
            return (c.methodNames.count > 0) ? true : false
        default:
            return false
        }
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        println("numberOfChildrenOfItem")
        if let it: AnyObject = item {
            println("\(it)")
            switch it {
            case let c as ComponentModel:
                return c.methodNames.count
            default:
                return 0
            }
        } else {
            return 3 // Flora and Fauna
        }
    }
    
    // NSOutlineViewDelegate
    func outlineView(outlineView: NSOutlineView, viewForTableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        println("viewForTableColumn")
        switch item {
        case let c as ComponentModel:
            let view = outlineView.makeViewWithIdentifier("HeaderCell", owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = c.name
            }
            return view
        default:
            let view = outlineView.makeViewWithIdentifier("DataCell", owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = item as! String
            }
            return view
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
        switch item {
        case let c as ComponentModel:
            return true
        default:
            return false
        }
    }

}


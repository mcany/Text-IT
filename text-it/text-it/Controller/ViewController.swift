//
//  ViewController.swift
//  text-it
//
//  Created by Mertcan Yigin on 5/29/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

class ViewController: NSViewController {
    
    @IBOutlet weak var codeScrollView: NSScrollView!
    @IBOutlet var codeTextView: NSTextView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet var debugTextView: NSTextView!
    @IBOutlet weak var componentOutlineView: NSOutlineView!
    
    //toolbar
    var toolBar:NSToolbar!
    var pushToolBarItem: NSToolbarItem!
    var recordToolBarItem: NSToolbarItem!

    //code text view
    var context: JSContext!
    var lineNumberView: NoodleLineNumberView!
    var dataLoader: DataLoader!

    //connections
    var firmataController: IFFirmata!
    var serverController: THServerController!
    
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
        
        //Firmata & BLE
        BLEDiscovery.sharedInstance().discoveryDelegate = self
        BLEDiscovery.sharedInstance().peripheralDelegate = self
        self.firmataController = IFFirmata()
        self.firmataController.delegate = self
        
        //To communicate with iPad
        self.serverController = THServerController()
        self.serverController.delegate = self
        self.serverController.startServer()
        
        //outlineview items
        self.componentOutlineView.setDataSource(ViewControllerOutlineView.sharedInstance)
        self.componentOutlineView.setDelegate(ViewControllerOutlineView.sharedInstance)
        ViewControllerOutlineView.sharedInstance.outlineView = self.componentOutlineView
        
        //feature extraction
        ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Mean"))
        ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Median"))
        ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Deviation"))
        ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Correlation"))
        ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Threshold"))
        ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "PeakDetection"))
        ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "FFT"))
        ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Energy"))
        
        //filter
        ViewControllerOutlineView.sharedInstance.filterComponent.methodNames.append(SubComponentModel(name: "RC Filter"))
        ViewControllerOutlineView.sharedInstance.filterComponent.methodNames.append(SubComponentModel(name: "Low-Pass Filter"))
        ViewControllerOutlineView.sharedInstance.filterComponent.methodNames.append(SubComponentModel(name: "High-Pass Filter"))
        ViewControllerOutlineView.sharedInstance.filterComponent.methodNames.append(SubComponentModel(name: "Moving Window Average Filter"))

        //machine learning
        ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "k-Nearest Neighbors"))
        ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "Hidden Markov Model"))
        ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "Support Vector Machine"))
        ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "Principal Component Analysis"))
        ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "Linear Discriminant Analysis"))

        //test
        //let data2: [CGFloat] = [3.0, 4.0, 9.0, 11.0, 13.0, 15.0, 2.0]
        //var peakDetect = PeakDetection()
        //peakDetect.detectPeaks(data2, peakThreshold: 1)
    }
        
    //BLE test
    func startScanning()
    {
        BLEDiscovery.sharedInstance().startScanningForSupportedUUIDs()
        println("scanningStarted")
    }
    
    //server test
    func sendMessage()
    {
        self.serverController.sendMessage("test message")
        var custom = THCustomComponent()
        custom.name = "sideHop"
        custom.code = self.codeTextView.string!
        
        self.serverController.sendObject(custom)
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
        
        let display: @objc_block [CGFloat] -> () = { input in
            return self.display(input)
        }
        self.context.setObject(unsafeBitCast(display, AnyObject.self), forKeyedSubscript: "display")
        
        // export JS class
        self.context.setObject(PeakDetection.self, forKeyedSubscript: "PeakDetection")

        self.context.setObject(LowPassFilter.self, forKeyedSubscript: "LowPassFilter")
        self.context.setObject(RCFilter.self, forKeyedSubscript: "RCFilter")
        self.context.setObject(Evaluator.self, forKeyedSubscript: "Evaluator")
        self.context.setObject(TestCase.self, forKeyedSubscript: "TestCase")
        TestCase.staticContext = self.context
        Parser.staticContext = self.context
        self.context.setObject(Parser.self, forKeyedSubscript: "Parser")

        //test
        let sendMessage: @objc_block () -> () = { input in
            return self.sendMessage()
        }
        self.context.setObject(unsafeBitCast(sendMessage, AnyObject.self), forKeyedSubscript: "sendMessage")
        
        
        let startScanning: @objc_block () -> () = { input in
            return self.startScanning()
        }
        self.context.setObject(unsafeBitCast(startScanning, AnyObject.self), forKeyedSubscript: "startScanning")
        
        var co = LowPassFilter()
        self.context.globalObject.setValue(co, forProperty: "lowPassFilter")
    }
    
    
    func display(data: [CGFloat])
    {
        if let lineChart = lineChartView.layer as? LineChart {
            //let data: [CGFloat] = [3.0, 4.0, 9.0, 11.0, 13.0, 15.0]
            //let count = accData.count / sizeof(CGFloat)
            
            // create array of appropriate length:
            //var array = [CGFloat](count: count, repeatedValue: 0)
            
            // copy bytes into array
            //accData.getBytes(&array, length:count * sizeof(CGFloat))
            //println(array)
            let dataset1 = LineChart.Dataset(label: "Data", data: data)
            dataset1.color = NSColor.redColor().CGColor
            dataset1.fillColor = nil
            dataset1.curve = .Bezier(0.3)
            lineChart.datasets = [dataset1]
            //lineChart.xAxis.labels = ["January"]
        }
        //return accData
    }
}
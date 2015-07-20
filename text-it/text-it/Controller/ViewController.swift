//
//  ViewController.swift
//  text-it
//
//  Created by Mertcan Yigin on 5/29/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var codeScrollView: NSScrollView!
    @IBOutlet var codeTextView: NSTextView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet var debugTextView: NSTextView!
    @IBOutlet weak var componentOutlineView: NSOutlineView!
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        ViewControllerOutlineView.sharedInstance.outlineView.reloadData()
    }
    //toolbar
    var toolBar:NSToolbar!
    var pushToolBarItem: NSToolbarItem!
    var recordToolBarItem: NSToolbarItem!
    var gatheringWindowController: GatheringWindowController!
    
    //text view
    var previosData: [CGFloat] = []
    
    //code text view
    var lineNumberView: NoodleLineNumberView!
    
    //connections
    var firmataController: IFFirmata!
    var serverController: THServerController!
    var bleCommunicationModule:CustomBLECommunicationModule?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.codeTextView.delegate = self
        self.codeTextView.font = NSFont.userFixedPitchFontOfSize(NSFont.smallSystemFontSize())
        self.codeTextView.automaticQuoteSubstitutionEnabled = false
        
        self.debugTextView.delegate = self
        self.debugTextView.font = NSFont.userFixedPitchFontOfSize(NSFont.smallSystemFontSize())
        self.debugTextView.editable = false
        
        JavascriptRunner.sharedInstance.exceptionHandler = self
        self.addPreDefinedFunctionsToJSContext()
        self.gatheringWindowController = GatheringWindowController(windowNibName: "GatheringWindow")

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

    func addPreDefinedFunctionsToJSContext()
    {
        var dataLoader = DataLoader()
        let load: @objc_block String -> [CGFloat] = { input in
            return dataLoader.loadAccelerometerData(input)
        }
        
        JavascriptRunner.sharedInstance.context.setObject(unsafeBitCast(load, AnyObject.self), forKeyedSubscript: "load")
        
        let display: @objc_block [CGFloat] -> () = { input in
            return self.display(input)
        }
        JavascriptRunner.sharedInstance.context.setObject(unsafeBitCast(display, AnyObject.self), forKeyedSubscript: "display")
        
        //test
        let sendMessage: @objc_block () -> () = { input in
            return self.sendMessage()
        }
        JavascriptRunner.sharedInstance.context.setObject(unsafeBitCast(sendMessage, AnyObject.self), forKeyedSubscript: "sendMessage")
        
        
        let startScanning: @objc_block () -> () = { input in
            return self.startScanning()
        }
        JavascriptRunner.sharedInstance.context.setObject(unsafeBitCast(startScanning, AnyObject.self), forKeyedSubscript: "startScanning")
    }
    
    func display(data: [CGFloat])
    {
        if let lineChart = self.lineChartView.layer as? LineChart {
            if(data.count > 0 && self.previosData != data)
            {
                previosData = data
                let dataset1 = LineChart.Dataset(label: "Data", data: data)
                dataset1.color = NSColor.redColor().CGColor
                dataset1.fillColor = nil
                dataset1.curve = .Bezier(0.3)
                lineChart.datasets = [dataset1]
            }
        }
    }
}
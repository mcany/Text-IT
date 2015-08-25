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
    
    //toolbar
    var toolBar:NSToolbar!
    var pushToolBarItem: NSToolbarItem!
    var recordToolBarItem: NSToolbarItem!
    lazy var gatheringWindowController: GatheringWindowController = GatheringWindowController(windowNibName: "GatheringWindow")
    var eTextileCommunicationSelectionController: ETextileCommunicationSelectionController!
    
    //text view
    var previousData: [CGFloat] = []
    var previousCircles: [CGFloat] = []
    var circlesChanged: Bool = true
    
    //code text view
    var lineNumberView: NoodleLineNumberView!
    var printResult: Bool = false
    let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)
    var currentFile: String = "main.txt"{
        didSet{
            self.readCurrentFile()
        }
    }
    var codeChanged: Bool = false
    
    //connections
    var firmataController: IFFirmata!
    var serverController: THServerController!
    var bleCommunicationModule:CustomBLECommunicationModule?
    var currentCommunicationTypes = [CommunicationType]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.codeTextView.delegate = self
        self.codeTextView.font = NSFont.userFixedPitchFontOfSize(NSFont.smallSystemFontSize())
        self.codeTextView.automaticQuoteSubstitutionEnabled = false
        
        self.debugTextView.delegate = self
        self.debugTextView.font = NSFont.userFixedPitchFontOfSize(NSFont.smallSystemFontSize())
        self.debugTextView.editable = false
        
        JavascriptRunner.sharedInstance.exceptionHandler = self
        JavascriptRunner.sharedInstance.executeLoop(){result in self.printResult(result)}
        self.addPreDefinedFunctionsToJSContext()
        //self.gatheringWindowController = GatheringWindowController(windowNibName: "GatheringWindow")
        self.eTextileCommunicationSelectionController = ETextileCommunicationSelectionController(windowNibName: "ETextileCommunicationSelection")
        self.eTextileCommunicationSelectionController.handler = self
        
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
        self.componentOutlineView.setDataSource(self)
        self.componentOutlineView.setDelegate(self)
        //ViewControllerOutlineView.sharedInstance.outlineView = self.componentOutlineView
        
        //directory
        var fileHelper = File()
        if ( !fileHelper.folderExists(Constants.Path.FullPath))
        {
            fileHelper.createFolder()
        }
        var currentFilePath = Constants.Path.FullPath.stringByAppendingPathComponent(self.currentFile)
        if ( !fileHelper.fileExists(currentFilePath) )
        {
            fileHelper.write(currentFilePath,data: "")
        }
        self.readCurrentFile()
        self.writeToCurrentFile()
        
        
        //feature extraction
        //ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Mean"))
        //ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Median"))
        //ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Deviation"))
        //ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Correlation"))
        //ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Threshold"))
        //ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "PeakDetection"))
        //ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "FFT"))
        //ViewControllerOutlineView.sharedInstance.featurExtractionComponent.methodNames.append(SubComponentModel(name: "Energy"))
        
        //filter
        //ViewControllerOutlineView.sharedInstance.filterComponent.methodNames.append(SubComponentModel(name: "RC Filter"))
        //ViewControllerOutlineView.sharedInstance.filterComponent.methodNames.append(SubComponentModel(name: "Low-Pass Filter"))
        //ViewControllerOutlineView.sharedInstance.filterComponent.methodNames.append(SubComponentModel(name: "High-Pass Filter"))
        //ViewControllerOutlineView.sharedInstance.filterComponent.methodNames.append(SubComponentModel(name: "Moving Window Average Filter"))
        
        //machine learning
        //ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "k-Nearest Neighbors"))
        //ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "Hidden Markov Model"))
        //ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "Support Vector Machine"))
        //ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "Principal Component Analysis"))
        //ViewControllerOutlineView.sharedInstance.machineLearningComponent.methodNames.append(SubComponentModel(name: "Linear Discriminant Analysis"))
        
        //test
        //self.eTextileCommunicationSelectionController.showWindow(nil)
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
        var file = File()
        let load: @objc_block String -> [CGFloat] = { input in
            return file.loadData(input)
        }
        
        JavascriptRunner.sharedInstance.context.setObject(unsafeBitCast(load, AnyObject.self), forKeyedSubscript: "load")
        
        let read: @objc_block String -> String? = { input in
            return file.read(input)
        }
        
        JavascriptRunner.sharedInstance.context.setObject(unsafeBitCast(read, AnyObject.self), forKeyedSubscript: "read")
        
        let sringToBandageData: @objc_block String -> BandageDataArray? = { input in
            return file.sringToBandageData(input)
        }
        
        JavascriptRunner.sharedInstance.context.setObject(unsafeBitCast(sringToBandageData, AnyObject.self), forKeyedSubscript: "sringToBandageData")
        
        let display: @objc_block AnyObject? -> () = { input in
            return self.display(input)
        }
        JavascriptRunner.sharedInstance.context.setObject(unsafeBitCast(display, AnyObject.self), forKeyedSubscript: "display")
        
        let addCircles: @objc_block [CGFloat]? -> () = { input in
            return self.addCircles(input)
        }
        JavascriptRunner.sharedInstance.context.setObject(unsafeBitCast(addCircles, AnyObject.self), forKeyedSubscript: "addCircles")
        
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
    
    func addCircles(data: [CGFloat]?)
    {
        if let myData: [CGFloat] = data {
            if let lineChart = self.lineChartView.layer as? LineChart {
                if(data!.count > 0 && lineChart.datasets.count > 0 && self.previousCircles != data! )
                {
                    lineChart.datasets[0].addCircle(data!)
                    self.previousCircles = data!
                    self.circlesChanged = true
                }
            }
        }
    }
    
    func display(data: AnyObject?)
    {
        dispatch_async(dispatch_get_main_queue(), {
            if let myData: AnyObject = data {
                switch myData {
                case let floatArray as [CGFloat]:
                    if let lineChart = self.lineChartView.layer as? LineChart {
                        if(floatArray.count > 0 && self.previousData != floatArray && self.circlesChanged)
                        {
                            self.circlesChanged = false
                            self.previousData = floatArray
                            let dataset1 = LineChart.Dataset(label: "Data", data: floatArray)
                            dataset1.color = NSColor.redColor().CGColor
                            dataset1.fillColor = nil
                            dataset1.curve = .Bezier(0.3)
                            lineChart.datasets = [dataset1]
                        }
                    }
                    break
                case let bandageDataArray as BandageDataArray:
                    if let lineChart = self.lineChartView.layer as? LineChart {
                        let dataset1 = LineChart.Dataset(label: "X", data: bandageDataArray.x)
                        dataset1.color = NSColor.redColor().CGColor
                        dataset1.fillColor = nil
                        dataset1.curve = .Bezier(0.3)
                        
                        let dataset2 = LineChart.Dataset(label: "Y", data: bandageDataArray.y)
                        dataset2.color = NSColor.blueColor().CGColor
                        dataset2.curve = .Bezier(0.3)
                        
                        let dataset3 = LineChart.Dataset(label: "Z", data: bandageDataArray.z)
                        dataset2.color = NSColor.greenColor().CGColor
                        dataset2.curve = .Bezier(0.3)
                        
                        lineChart.datasets = [ dataset1, dataset2, dataset3 ]
                    }
                    break
                default:
                    break
                }
            }
        })
    }
}
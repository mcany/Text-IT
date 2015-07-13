//
//  GatheringWindowController.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/12/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class GatheringWindowController: NSWindowController, DataViewer, Recorder {

    @IBOutlet weak var fileNameTextField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet var outputTextView: NSTextView!
    
    var fileName: String = "untitled.txt"
    var isRecording: Bool = false
    var stopRecording: Bool = false
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.fileNameTextField.stringValue = fileName
        self.startButton.enabled = true
        self.stopButton.enabled = false
        self.outputTextView.string = ""
    }
    
    func showData(bandageData: THBandageData) {
        self.outputTextView.string! += bandageData.printData()
        self.outputTextView.scrollRangeToVisible(NSRange(location: count(self.outputTextView.string!), length: 0))
    }
    
    @IBAction func fileNameEntered(sender: AnyObject) {
        self.fileName = self.fileNameTextField.stringValue
    }
    
    @IBAction func startButtonTapped(sender: AnyObject) {
        self.stopButton.enabled = true
        self.startButton.enabled = false
        self.isRecording = true
        self.stopRecording = false
    }

    @IBAction func stopButtonTapped(sender: AnyObject) {
        self.fileName = self.fileNameTextField.stringValue

        self.stopButton.enabled = false
        self.startButton.enabled = true
        self.isRecording = false
        self.stopRecording = true
    }
}

//
//  GatheringWindowController.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/12/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

protocol GatheringWindowClosedHandler
{
    func gatheringWindowClosed(save:Bool, fileName: String?)
}

class GatheringWindowController: NSWindowController, Recorder {
    
    @IBOutlet weak var fileNameTextField: NSTextField!
    @IBOutlet weak var exitButton: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet var outputTextView: NSTextView!
    
    var fileName: String = "untitled.txt"
    var isRecording: Bool = true
    var stopRecording: Bool = false
    var data: String = ""
    var handler:GatheringWindowClosedHandler!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.fileNameTextField.stringValue = fileName
        self.exitButton.enabled = true
        self.saveButton.enabled = true
        self.outputTextView.string = ""
        self.fileName = "untitled.txt"
        self.isRecording = true
        self.stopRecording = false
        self.data = ""
    }
    
    func showData(bandageData: THBandageData) {
        var string = bandageData.printData()
        self.printData(string)
    }
    
    func showDataArray(values: [AnyObject]) {
        var string: String = ""
        for value in values
        {
            string += value.description + " "
        }
        string += "\n"
        self.printData(string)
    }
    
    func showDataNumber(value: AnyObject) {
        var string: String = ""
        string += value.description + " "
        string += "\n"
        self.printData(string)
    }
    
    func printData(string: String)
    {
        self.outputTextView.string! += string
        self.data = self.outputTextView.string!
        self.outputTextView.scrollRangeToVisible(NSRange(location: count(self.outputTextView.string!), length: 0))
    }
    
    @IBAction func fileNameEntered(sender: AnyObject) {
        self.fileName = self.fileNameTextField.stringValue
    }
    
    @IBAction func exitButtonTapped(sender: AnyObject) {
        self.saveButton.enabled = true
        self.exitButton.enabled = false
        self.isRecording = true
        self.stopRecording = false
        self.handler.gatheringWindowClosed(false, fileName: nil)
        self.close()
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        self.fileName = self.fileNameTextField.stringValue
        self.saveButton.enabled = true
        self.exitButton.enabled = true
        self.isRecording = false
        self.stopRecording = true
        
        self.handler.gatheringWindowClosed(true, fileName: self.fileName)
    }
}

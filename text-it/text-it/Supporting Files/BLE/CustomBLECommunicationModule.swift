//
//  CustomBLECommunicationModule.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/25/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

protocol DataViewer
{
    func showData(bandageData: THBandageData)
}

protocol Recorder
{
    var isRecording: Bool {get}
    var stopRecording: Bool {get}
    var fileName:String {get}
}

class CustomBLECommunicationModule: IFFirmataCommunicationModule, BLEServiceDataDelegate, THBandageDataDelegate {
    
    var bleService:  BLEService!
    var firmataController:  IFFirmata!
    
    var dataViewerHandler: DataViewer?
    var recorder: Recorder?
    var currentBandageDataSession: [THBandageData] = []
    var parser = Parser()
        {
        didSet{
            parser.delegate = self
        }
    }
    
    override func sendData(bytes: UnsafeMutablePointer<UInt8>, count: Int) {
        println("CustomBLECommunicationModule sendData")
        self.bleService.sendData(bytes, count: count)
    }
    
    func didReceiveData(buffer: UnsafeMutablePointer<UInt8>, lenght originalLength: Int) {
        if(self.recorder!.isRecording)
        {
            //println("CustomBLECommunicationModule didReceiveData: ")
            //self.firmataController.didReceiveData(buffer, lenght: originalLength)
            parser.parse(buffer, length: originalLength)
        }
        else if (self.self.recorder!.stopRecording)
        {
            self.finishSession()
        }
    }
    
    func didReceiveSensorData(bandageData: THBandageData) {
        currentBandageDataSession.append(bandageData)
        self.dataViewerHandler!.showData(bandageData)
    }
    
    func finishSession() {
        //write to file
        var writer = FileWriter()
        writer.writeToFile(self.recorder!.fileName, data: self.currentBandageDataSession)
    }
    
    /*
    func setBleService(bleService: BLEService)
    {
    if(bleService != self.bleService)
    {
    self.bleService = bleService
    self.usesFillBytes = (self.bleService.deviceType.value == kBleDeviceTypeKroll)
    }
    }
    */
}

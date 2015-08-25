//
//  CustomBLECommunicationModule.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/25/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

protocol Recorder
{
    var isRecording: Bool {get}
    var stopRecording: Bool {get}
}

class CustomBLECommunicationModule: IFFirmataCommunicationModule, BLEServiceDataDelegate {
    
    var bleService:  BLEService!
    var firmataController:  IFFirmata!
    
    var recorder: Recorder?
    var currentBandageDataSession: [THBandageData] = []
    
    
    override init() {
        super.init()
    }
    
    override func sendData(bytes: UnsafeMutablePointer<UInt8>, count: Int) {
        println("CustomBLECommunicationModule sendData")
        self.bleService.sendData(bytes, count: count)
    }
    
    func didReceiveData(buffer: UnsafeMutablePointer<UInt8>, lenght originalLength: Int) {
        if((self.recorder) != nil)
        {
            if(self.recorder!.isRecording)
            {
                self.firmataController.didReceiveData(buffer, lenght: originalLength)
            }
            else if (self.recorder!.stopRecording)
            {
                //self.finishSession()
            }
        }
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

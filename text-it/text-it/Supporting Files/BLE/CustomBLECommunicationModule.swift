//
//  CustomBLECommunicationModule.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/25/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class CustomBLECommunicationModule: IFFirmataCommunicationModule, BLEServiceDataDelegate {
    
    var bleService:  BLEService!
    var firmataController:  IFFirmata!
    
    override func sendData(bytes: UnsafeMutablePointer<UInt8>, count: Int) {
        println("CustomBLECommunicationModule sendData")
        self.bleService.sendData(bytes, count: count)
    }
    
    func didReceiveData(buffer: UnsafeMutablePointer<UInt8>, lenght originalLength: Int) {
        //println("CustomBLECommunicationModule didReceiveData: ")
        //self.firmataController.didReceiveData(buffer, lenght: originalLength)
        var parser = Parser()
        parser.parse(buffer, length: originalLength)
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

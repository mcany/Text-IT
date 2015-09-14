//
//  ViewControllerBLE_Firmata.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/26/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

extension ViewController: BLEDiscoveryDelegate, BLEServiceDelegate, IFFirmataControllerDelegate, ETextileCommunicationSelectionControllerHandler, GatheringWindowClosedHandler {
    
    // MARK: - Text-It delegates
    
    func communicationTypesSelected(communicationTypes: [CommunicationType])
    {
        self.currentCommunicationTypes = communicationTypes
        self.gatheringWindowController.handler = self
        self.gatheringWindowController.showWindow(nil)
        self.startReceivingData()
    }
    
    func gatheringWindowClosed(save:Bool, fileName: String?)
    {
        if(save)
        {
            for currentCommunicationType in self.currentCommunicationTypes
            {
                if let comm = currentCommunicationType as? I2CReply
                {
                    var dictionaryString:String = comm.address.description+"/"+comm.register.description
                    comm.data = self.i2cReplyDictionary[dictionaryString]!
                    self.firmataController.sendI2CStopReadingAddress(comm.address)
                }
                else if let comm = currentCommunicationType as? DigitalMessage
                {
                    comm.data = self.digitalDictionary[comm.pin.description]!
                    self.firmataController.sendReportRequestsForDigitalPin(comm.pin, reports: false)
                }
                else if let comm = currentCommunicationType as? AnalogMessage
                {
                    comm.data = self.analogDictionary[comm.pin.description]!
                    self.firmataController.sendReportRequestForAnalogPin(comm.pin, reports: false)
                }
            }
            
            //test
            var analog = AnalogMessage()
            analog.name = "analog"
            analog.pin = 0
            analog.data = [1,2,3,4]
            
            var digital = DigitalMessage()
            digital.name = "digital"
            digital.pin = 0
            digital.data = [1,2,3,4]
            
            self.currentCommunicationTypes.append(analog)
            self.currentCommunicationTypes.append(digital)
            //test
            
            var writer = File()
            var currentFilePath = Constants.Path.FullPath.stringByAppendingPathComponent(fileName!)
            writer.write(currentFilePath, data: self.currentCommunicationTypes)
        }
        self.firmataController.reset()
    }
    
    // MARK: - BLE delegates
    
    func connectToBle()
    {
        println("connectToBle")
        
        if(BLEDiscovery.sharedInstance().foundPeripherals.count > 0)
        {
            for foundPeripheral in BLEDiscovery.sharedInstance().foundPeripherals
            {
                if(foundPeripheral.name! == Constants.BLEConstanst.peripheralName)
                {
                    BLEDiscovery.sharedInstance().connectPeripheral(foundPeripheral as! CBPeripheral)
                }
            }
        }
    }
    
    func startReceivingData()
    {
        println("sendFirmwareRequest")
        self.firmataController.sendFirmwareRequest()
    }
    
    func bleServiceIsReady(service: BLEService!) {
        println("bleServiceIsReady")
        var customBLECommunicationModule = CustomBLECommunicationModule()
        customBLECommunicationModule.recorder = self.gatheringWindowController
        self.bleCommunicationModule = customBLECommunicationModule
        bleCommunicationModule!.bleService = service
        bleCommunicationModule!.firmataController = self.firmataController
        bleCommunicationModule!.currentBandageDataSession = []
        service.dataDelegate = bleCommunicationModule
        self.firmataController.communicationModule = bleCommunicationModule;
        self.recordToolBarItem.enabled = true
    }
    
    func peripheralDiscovered(peripheral: CBPeripheral!) {
        println("peripheralDiscovered")
        println(peripheral.name)
        self.connectToBle()
    }
    
    func bleServiceDidConnect(service: BLEService!) {
        println("bleServiceDidConnect")
        service.delegate = self
    }
    
    func bleServiceDidDisconnect(service: BLEService!) {
        println("bleServiceDidDisconnect")
        self.recordToolBarItem.enabled = false
        self.bleCommunicationModule = nil
        //service.delegate = nil
        //service.dataDelegate = nil
    }
    
    func bleServiceDidReset() {
        println("bleServiceDidReset")
        
    }
    
    func discoveryDidRefresh() {
        println("discoveryDidRefresh")
        
    }
    
    func discoveryStatePoweredOff() {
        println("discoveryStatePoweredOff")
        
    }
    
    // MARK: - Firmata delegates
    
    func sendI2CRequests()
    {
        println("sendI2CRequests")
        
        self.firmataController.sendI2CStartReadingAddress(104, reg: 59, size: 6)
    }
    
    
    func firmataController(firmataController: IFFirmata!, didReceiveFirmwareName name: String!) {
        println("didReceiveFirmwareName")
        
        for commType in self.currentCommunicationTypes
        {
            if commType is I2CReply
            {
                let i2cReply = commType as? I2CReply
                self.firmataController.sendI2CStartReadingAddress(i2cReply!.address, reg: i2cReply!.register, size: i2cReply!.size)
            }
            else if commType is DigitalMessage
            {
                let digitalMessage = commType as? DigitalMessage
                self.firmataController.sendReportRequestsForDigitalPin(digitalMessage!.pin, reports: true)
            }
            else if commType is AnalogMessage
            {
                let analogMessage = commType as? AnalogMessage
                self.firmataController.sendReportRequestForAnalogPin(analogMessage!.pin, reports: true)
            }
        }
    }
    
    func firmataController(firmataController: IFFirmata!, didReceiveI2CReply buffer: UnsafeMutablePointer<UInt8>, length: Int)
    {
        //println("didReceiveI2CReply")
        var address = buffer[2] + (buffer[3] << 7)
        var register = buffer[4]
        
        if !(self.firmataController.startedI2C)
        {
            println("reporting but i2c did not start")
            self.firmataController.sendI2CStopReadingAddress(Int(address))
        }
        else
        {
            var parsedValues = self.shifter(buffer+6, length: length-6)
            var dictionaryString:String = address.description+"/"+register.description
            if self.i2cReplyDictionary[dictionaryString] == nil
            {
               self.i2cReplyDictionary[dictionaryString] = [[CGFloat]]()
            }
            self.i2cReplyDictionary[dictionaryString]?.append(parsedValues)
            self.gatheringWindowController.showDataArray(parsedValues)
        }
    }
    
    func shifter(data: UnsafeMutablePointer<UInt8>, length: Int) -> [CGFloat]
    {
        var size = length;
        var bufCount = 0;
        var rawValues: [UInt16] = []
        var values: [CGFloat] = []
        
        for (var i = 0; i < size; i++) {
            //firmata sends as two seven bit bytes
            var byte1: UInt16 = UInt16(data[bufCount++])
            var bufValue: UInt16 = UInt16 (data[bufCount++])
            var shiftValue: UInt16 = ( bufValue << 7)
            var value: UInt16 = byte1 + shiftValue
            rawValues.append(value)
        }
        
        for var y = 0; y < rawValues.count-1;
        {
            var value = Float((rawValues[y+1] << 8 | rawValues[y])) / Float(65536.0)
            values.append(CGFloat(value))
            y += 2
        }
        
        return values
        //var linAccelX = Float((values[1] << 8 | values[0])) / Float(65536.0)
        //var linAccelY = Float((values[3] << 8 | values[2])) / Float(65536.0)
        //var linAccelZ = Float((values[5] << 8 | values[4])) / Float(65536.0)
    }
    
    func firmataController(firmataController: IFFirmata!, didReceiveAnalogMessageOnChannel channel: Int, value: Int) {
        println("didReceiveAnalogMessageOnChannel : %d, value: %d", channel, value)
        if self.analogDictionary[channel.description] == nil
        {
            self.analogDictionary[channel.description] = [CGFloat]()
        }
        self.analogDictionary[channel.description]?.append(CGFloat(value))
        self.gatheringWindowController.showDataNumber(value)
    }
    
    func firmataController(firmataController: IFFirmata!, didReceiveDigitalMessageForPort port: Int, value: Int) {
        println("didReceiveDigitalMessageForPort : %d value: %d", port, value)
        if self.digitalDictionary[port.description] == nil
        {
            self.digitalDictionary[port.description] = [CGFloat]()
        }
        self.digitalDictionary[port.description]?.append(CGFloat(value))
        self.gatheringWindowController.showDataNumber(value)
    }
    
    func firmataController(firmataController: IFFirmata!, didReceivePinStateResponse buffer: UnsafeMutablePointer<UInt8>, length: Int) {
        println("didReceivePinStateResponse")
    }
}

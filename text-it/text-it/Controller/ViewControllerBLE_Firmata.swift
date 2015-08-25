//
//  ViewControllerBLE_Firmata.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/26/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

extension ViewController: BLEDiscoveryDelegate, BLEServiceDelegate, IFFirmataControllerDelegate, ETextileCommunicationSelectionControllerHandler {
    
    func communicationTypesSelected(communicationTypes: [CommunicationType])
    {
        self.currentCommunicationTypes = communicationTypes
        self.gatheringWindowController.showWindow(nil)
        self.startReceivingData()
    }
    // MARK: - BLE delegates
    
    func connectToBle()
    {
        println("connectToBle")
        
        if(BLEDiscovery.sharedInstance().foundPeripherals.count > 0)
        {
            for foundPeripheral in BLEDiscovery.sharedInstance().foundPeripherals
            {
                if(foundPeripheral.name! == "Biscuit")
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
        println("didReceiveI2CReply")
        
        var address = buffer[2] + (buffer[3] << 7)
        var registerNumber = buffer[4]
        
        if !(self.firmataController.startedI2C)
        {
            println("reporting but i2c did not start")
            self.firmataController.sendI2CStopReadingAddress(Int(address))
        }
        else
        {
            println(buffer)
            var parser = GeneralParser()
            var parsedValues = parser.parse(buffer+6, length: length-6)
            self.gatheringWindowController.showDataArray(parsedValues)
        }
    }
    
    func firmataController(firmataController: IFFirmata!, didReceiveAnalogMessageOnChannel channel: Int, value: Int) {
        println("didReceiveAnalogMessageOnChannel : %d, value: %d", channel, value)
        self.gatheringWindowController.showDataNumber(value)
    }
    
    func firmataController(firmataController: IFFirmata!, didReceiveDigitalMessageForPort port: Int, value: Int) {
        println("didReceiveDigitalMessageForPort : %d value: %d", port, value)
        self.gatheringWindowController.showDataNumber(value)
    }
    
    func firmataController(firmataController: IFFirmata!, didReceivePinStateResponse buffer: UnsafeMutablePointer<UInt8>, length: Int) {
        println("didReceivePinStateResponse")
    }
}

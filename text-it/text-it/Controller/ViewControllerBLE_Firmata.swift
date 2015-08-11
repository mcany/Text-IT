//
//  ViewControllerBLE_Firmata.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/26/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

extension ViewController: BLEDiscoveryDelegate, BLEServiceDelegate, IFFirmataControllerDelegate {
    
    
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
        self.firmataController.sendFirmwareRequest()
    }
    
    func bleServiceIsReady(service: BLEService!) {
        println("bleServiceIsReady")
        var customBLECommunicationModule = CustomBLECommunicationModule()
        customBLECommunicationModule.dataViewerHandler = self.gatheringWindowController
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
        self.bleCommunicationModule!.finishSession()
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
        
        self.sendI2CRequests()
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
        }
    }
    
    func firmataController(firmataController: IFFirmata!, didReceiveAnalogMessageOnChannel channel: Int, value: Int) {
        println("didReceiveAnalogMessageOnChannel")
    }
    
    func firmataController(firmataController: IFFirmata!, didReceiveDigitalMessageForPort port: Int, value: Int) {
        println("didReceiveDigitalMessageForPort")
    }
    
    func firmataController(firmataController: IFFirmata!, didReceivePinStateResponse buffer: UnsafeMutablePointer<UInt8>, length: Int) {
        println("didReceivePinStateResponse")
    }

}

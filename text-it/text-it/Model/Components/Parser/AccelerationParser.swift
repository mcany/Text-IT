//
//  Parser.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/30/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol AccelerationParserJSExports : JSExport {
    var code: String { get }
    var name: String { get }
    
    static func new() -> AccelerationParser
    func change() -> AccelerationParser
}

protocol THBandageDataDelegate
{
    func didReceiveSensorData(bandageData: THBandageData)
}

// Custom class must inherit from `NSObject`
@objc(AccelerationParser)
class AccelerationParser: Component, AccelerationParserJSExports, Parser {
    static  var myWindowController: ParserWindowController!
    var code: String = ""
    var name: String = ""
    
    var delegate: THBandageDataDelegate!
    
    override static func new() -> AccelerationParser {
        var parser = AccelerationParser()
        openParserWindow(parser)
        return parser
    }
    
    static func openParserWindow(parser : AccelerationParser)
    {
        myWindowController = ParserWindowController(windowNibName: "ParserWindow")
        //TODO: 
        //myWindowController.parser = parser
        myWindowController.showWindow(nil)
    }
    
    func change() -> AccelerationParser
    {
        AccelerationParser.openParserWindow(self)
        return self
    }
    
    func parse(data: UnsafeMutablePointer<UInt8>, length: Int)
    {
        println(data)
        
        var size = 6;
        var bufCount = 0;
        var values: [UInt16] = []
        
        for (var i = 0; i < size; i++) {//firmata sends as two seven bit bytes
            var byte1: UInt16 = UInt16(data[bufCount++])
            var bufValue: UInt16 = UInt16 (data[bufCount++])
            var shiftValue: UInt16 = ( bufValue << 7)
            var value: UInt16 = byte1 + shiftValue
            values.append(value)
        }
        
        var linAccelX = Float((values[1] << 8 | values[0])) / Float(65536.0)
        var linAccelY = Float((values[3] << 8 | values[2])) / Float(65536.0)
        var linAccelZ = Float((values[5] << 8 | values[4])) / Float(65536.0)
        
        println(" x: " + linAccelX.description)
        println(" y: " + linAccelY.description)
        println(" z: " + linAccelZ.description)
        
        var linearAcceleration = LinearAcceleration();
        linearAcceleration.x = CGFloat(linAccelX)
        linearAcceleration.y = CGFloat(linAccelY)
        linearAcceleration.z = CGFloat(linAccelZ)
        var bandageData = THBandageData()
        bandageData.linearAcceleration = linearAcceleration
        self.delegate.didReceiveSensorData(bandageData)
        
        /*
        TangoHapps:
        NSInteger size = 6;
        NSInteger bufCount = 0;
        uint8_t values[size];
        
        for (int i = 0; i < size; i++) {//firmata sends as two seven bit bytes
        uint8_t byte1 = buffer[bufCount++];
        uint8_t value = byte1 + (buffer[bufCount++] << 7);
        values[i] = value;
        }
        
        THAccelerometerData * accelerometerData = [[THAccelerometerData alloc] init];
        
        accelerometerData.x = (values[1] << 8 | values[0]) / 65536.0f;
        accelerometerData.y = (values[3] << 8 | values[2]) / 65536.0f;
        accelerometerData.z = (values[5] << 8 | values[4]) / 65536.0f;
        
        self.accelerometer = accelerometerData;
        */
        
        /*
        KHSensorData *sensorData = [KHSensorData new];
        
        sensorData.creationDate = [NSDate date];
        sensorData.sensorID = [NSNumber numberWithInt:data[14]];
        
        // Quaternion
        float q[] = { 0.0f, 0.0f, 0.0f, 0.0f };
        
        q[0] = ((data[6] << 8) | data[7]) / 16384.0f;
        q[1] = ((data[8] << 8) | data[9]) / 16384.0f;
        q[2] = ((data[10] << 8) | data[11]) / 16384.0f;
        q[3] = ((data[12] << 8) | data[13]) / 16384.0f;
        
        for (int i = 0; i < 4; i++) {
        if (q[i] >= 2.0f) {
        q[i] -= 4.0f;
        }
        }
        
        // Raw Acceleration
        GLKVector3 rawAcceleration = GLKVector3Make(0, 0, 0);
        
        rawAcceleration.x = (short)((data[0] << 8) | data[1]);
        rawAcceleration.y = (short)((data[2] << 8) | data[3]);
        rawAcceleration.z = (short)((data[4] << 8) | data[5]);
        
        // Conversion into KneeHapp proprietary model objects
        KHQuaternion *quaternion = [KHQuaternion new];
        
        quaternion.w = [NSNumber numberWithFloat:q[0]];
        quaternion.x = [NSNumber numberWithFloat:q[1]];
        quaternion.y = [NSNumber numberWithFloat:q[2]];
        quaternion.z = [NSNumber numberWithFloat:q[3]];
        
        sensorData.quaternion = quaternion;
        sensorData.gravity = [KHSensorDataHelper gravityFromQuaternion:quaternion];
        sensorData.yawPitchRoll = [KHSensorDataHelper yawPitchRollFromQuaternion:quaternion];
        sensorData.linearAcceleration = [KHSensorDataHelper linearAccelFromRawAcceleration:rawAcceleration gravity:sensorData.gravity quaternion:quaternion];
        
        // Notify delegate
        [self.delegate didReceiveSensorData:sensorData];
        
        */
    }
}

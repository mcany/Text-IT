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
protocol ParserJSExports : JSExport {
    var code: String { get }
    var name: String { get }
    
    static func new() -> Parser
    func change() -> Parser
}

// Custom class must inherit from `NSObject`
@objc(Parser)
class Parser: Component, ParserJSExports {
    static  var myWindowController: ParserWindowController!
    var code: String = ""
    var name: String = ""
    
    override static func new() -> Parser {
        var parser = Parser()
        openParserWindow(parser)
        return parser
    }

    static func openParserWindow(parser : Parser)
    {
        myWindowController = ParserWindowController(windowNibName: "ParserWindow")
        myWindowController.parser = parser
        myWindowController.showWindow(nil)
    }
    
    func change() -> Parser
    {
        Parser.openParserWindow(self)
        return self
    }
    
    func parse(data: UnsafeMutablePointer<UInt8>, length: Int)
    {
        
        println(data)
        
        var shiftedDataX = (data[0] << 8)
        var shiftedDataY = (data[2] << 8)
        var shiftedDataZ = (data[4] << 8)
        
        var linAccelX = (CShort) (shiftedDataX | data[1])
        var linAccelY = (CShort) (shiftedDataY | data[3])
        var linAccelZ = (CShort) (shiftedDataZ | data[5])
        
        
        println(" x: " + linAccelX.description)
        println(" y: " + linAccelY.description)
        println(" z: " + linAccelZ.description)
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

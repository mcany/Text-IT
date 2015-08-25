//
//  GeneralParser.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/24/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class GeneralParser: NSObject {

    
    func parse(data: UnsafeMutablePointer<UInt8>, length: Int) -> [CGFloat]
    {
        var size = length;
        var bufCount = 0;
        var rawValues: [UInt16] = []
        var values: [CGFloat] = []
        
        for (var i = 0; i < size; i++) {//firmata sends as two seven bit bytes
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
}

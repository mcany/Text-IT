//
//  DataLoader.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/1/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa


class DataLoader: NSObject {
    
    func loadAccelerometerData(fileName: String) -> [Int]
    {
        var paths:NSArray  = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentsDirectory:String = paths[0] as! String
        var appFile: String = documentsDirectory.stringByAppendingPathComponent(fileName)
        
        var intArray: [Int] = []

        
        if let content = String(contentsOfFile:appFile, encoding: NSUTF8StringEncoding, error: nil) {
            var array = content.componentsSeparatedByString("\n")
            intArray = map(array) { String($0).toInt() ?? 0 }

            println(array)
        }
        
        
        //var data = NSData(contentsOfFile:appFile)
        
        //var util = Util()
        //util.loadAccelerometerData()
        
        //var count: Int = data!.length
        
        //println(data)
        
        
        //let count = data!.length / sizeof(CMDeviceMotion)
        
        // create array of appropriate length:
        //var array = [CMAcceleration](count: count, repeatedValue: 0)
        
        // copy bytes into array
        //data!.getBytes(&array, length:count * sizeof(CMAcceleration))
        
        //println(data)
        
        //int count = ((int*) data.bytes)[0];
        
        
        //accelerometer
        //var accelerometerData = [Int]()
        //data?.getBytes(accelerometerData, length: sizeof(Int))
        
       // var accelerometerData = [CMAcceleration]  ([int] data.bytes + 1)
        
        //CMAcceleration * accelerometerData = (CMAcceleration*)((int*)data.bytes + 1);
        //[self printAccelerometerData:accelerometerData count:count prefix:'g'];
        
        //var data = NSData()
        return intArray
    }
}

//
//  DataLoader.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/1/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa


class DataLoader: NSObject {
    
    func loadAccelerometerData(fileName: String) -> NSData
    {
        var paths:NSArray  = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentsDirectory:String = paths[0] as! String
        var appFile: String = documentsDirectory.stringByAppendingPathComponent(fileName)
        
        var data = NSData(contentsOfFile:appFile)
        
        //var count: Int = data!.length
        
        //println(data)
        
        
        let count = data!.length / sizeof(CMDeviceMotion)
        
        // create array of appropriate length:
        var array = [CMAcceleration](count: count, repeatedValue: 0)
        
        // copy bytes into array
        data!.getBytes(&array, length:count * sizeof(CMAcceleration))
        
        println(array)
        
        //int count = ((int*) data.bytes)[0];
        
        
        //accelerometer
        //var accelerometerData = [Int]()
        //data?.getBytes(accelerometerData, length: sizeof(Int))
        
       // var accelerometerData = [CMAcceleration]  ([int] data.bytes + 1)
        
        //CMAcceleration * accelerometerData = (CMAcceleration*)((int*)data.bytes + 1);
        //[self printAccelerometerData:accelerometerData count:count prefix:'g'];
        
        
        return data!
    }
}

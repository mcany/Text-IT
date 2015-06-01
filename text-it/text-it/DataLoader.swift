//
//  DataLoader.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/1/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class DataLoader: NSObject {
    
    func loadAccelerometerData(fileName: String) -> String
    {
        var paths:NSArray  = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentsDirectory:String = paths[0] as! String
        var appFile: String = documentsDirectory.stringByAppendingPathComponent(fileName)
        
        var data = NSData(contentsOfFile:appFile)
        
        //var count: Int = data.length
        
        println(data)
        
        return appFile
    }
}

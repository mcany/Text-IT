//
//  FileWriter.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/9/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class FileWriter: NSObject {
    
    func writeToFile(fileName: String, data: [THBandageData]) -> Bool
    {
        println("write to file")
        
        let file = fileName
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            var text = ""
            for aData in data
            {
                text  += aData.printData()
                
            }
            text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
            return true
        }
        return false
    }
}

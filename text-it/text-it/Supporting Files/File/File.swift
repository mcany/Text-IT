//
//  FileHelper.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Foundation

class File {
    
    func checkIfFolderExistIfNotCreate()
    {
        var fullPath = Constants.Path.FullPath
        var isDir : ObjCBool = false
        if NSFileManager.defaultManager().fileExistsAtPath(fullPath, isDirectory:&isDir) {
            if isDir {
                // file exists and is a directory
                println("exists")
            } else {
                // file exists and is not a directory
            }
        } else {
            // file does not exist
            println("does not exist")
            self.createFolder()
        }
    }
    
    func createFolder()
    {
        var error: NSError?
        
        var fullPath = Constants.Path.FullPath
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(fullPath)) {
            NSFileManager.defaultManager().createDirectoryAtPath(fullPath, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
        if(error != nil)
        {
            println(error)
        }
    }
    
    func fileExists(path: String) -> Bool
    {
        return NSFileManager().fileExistsAtPath(path)
    }
    
    func write(fileName: String, data: [THBandageData]) -> Bool
    {
        println("write to file")
        
        let file = fileName
        var error: NSError?

        let dir = Constants.Path.Documents
            let path = dir.stringByAppendingPathComponent(file);
            var text = ""
            for aData in data
            {
                text  += aData.printData()
                
            }
            text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: &error)

        if(error == nil)
        {
            return true
        }
        
        println(error)
        return false
    }
    
    func loadData(fileName: String) -> [CGFloat]
    {
        var appFile: String = Constants.Path.Documents.stringByAppendingPathComponent(fileName)
        var cgFloatArray: [CGFloat] = []
        
        if(self.fileExists(appFile))
        {
            if let content = String(contentsOfFile:appFile, encoding: NSUTF8StringEncoding, error: nil) {
                var array: [String] = content.componentsSeparatedByString(",")
                
                cgFloatArray = array.map {
                    CGFloat(($0 as NSString).doubleValue)
                }
            }
        }
        return cgFloatArray
    }
}
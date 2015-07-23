//
//  FileHelper.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Foundation

class File {
    
    func folderExists() -> Bool
    {
        var fullPath = Constants.Path.FullPath
        var isDir : ObjCBool = false
        if NSFileManager.defaultManager().fileExistsAtPath(fullPath, isDirectory:&isDir) {
            if isDir {
                // file exists and is a directory
                println("exists")
                return true
            } else {
                // file exists and is not a directory
                return false
            }
        } else {
            // file does not exist
            println("does not exist")
            return false
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
    
    func write(filePath: String, data: AnyObject?) -> Bool
    {
        var error: NSError?
        let path = filePath
        var text = ""

        if let myData: AnyObject = data {
            switch myData {
            case let c as [THBandageData]:
                for aData in c
                {
                    text  += aData.printData()
                    
                }
                break
            case let c as String:
                text += c
                break
            default:
                break
            }
        }
       
        text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: &error)
        
        if(error == nil)
        {
            return true
        }
        
        println(error)
        return false
    }
    
    func read (path: String) -> String? {
        if self.fileExists(path) {
            return String(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil)
        }
        return nil
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
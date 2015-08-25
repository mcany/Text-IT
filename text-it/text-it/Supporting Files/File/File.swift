//
//  FileHelper.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Foundation

class File {
    
    func folderExists(path: String) -> Bool
    {
        var isDir : ObjCBool = false
        if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory:&isDir) {
            if isDir {
                // file exists and is a directory
                return true
            } else {
                // file exists and is not a directory
                return false
            }
        } else {
            // file does not exist
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
        var isDir : ObjCBool = false
        if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory:&isDir) {
            if isDir {
                // file exists and is a directory
                return false
            } else {
                // file exists and is not a directory
                return true
            }
        } else {
            // file does not exist
            return false
        }
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
                text += myData.description
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
        var text: String = ""
        // if full path is given open directly
        //if path.rangeOfString(Constants.Path.FolderName) != nil{
        if self.fileExists(path) {
            text = String(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil)!
        }
            //}
        else
        {
            var appFile: String = Constants.Path.FullPath.stringByAppendingPathComponent(path)
            // if only file name is given, check if it is in Documents/Text-It folder
            if self.fileExists(appFile)
            {
                text = String(contentsOfFile:appFile, encoding: NSUTF8StringEncoding, error: nil)!
            }
            //            // if direct path is given
            //            else if self.fileExists(path)
            //            {
            //                text = String(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil)!
            //            }
        }
        
        if(text != "")
        {
            return text
        }
        
        return nil
    }
    
    func sringToBandageData(text: String) -> BandageDataArray?
    {
        if(text != "undefined")
        {
            var textWithoutNewLines: [String] = text.componentsSeparatedByString("\n")
            var bandageDataSession = [THBandageData]()
            var bandageDataArray = BandageDataArray()
            for textLine in textWithoutNewLines
            {
                //X: 0.77734375 Y: 0.69757080078125 Z: 0.090728759765625
                if(textLine != "")
                {
                    var textWithoutCapitalLetters = textLine.componentsSeparatedByString(" ")
                    var linearAcceleration = LinearAcceleration()
                    linearAcceleration.x = CGFloat(((textWithoutCapitalLetters[1] as NSString).doubleValue))
                    linearAcceleration.y = CGFloat(((textWithoutCapitalLetters[3] as NSString).doubleValue))
                    linearAcceleration.z = CGFloat(((textWithoutCapitalLetters[5] as NSString).doubleValue))
                    var bandageData =  THBandageData()
                    bandageData.linearAcceleration = linearAcceleration
                    bandageDataSession.append(bandageData)
                    bandageDataArray.x.append(linearAcceleration.x)
                    bandageDataArray.y.append(linearAcceleration.y)
                    bandageDataArray.z.append(linearAcceleration.z)
                }
            }
            bandageDataArray.bandageDataSession = bandageDataSession
            return bandageDataArray
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
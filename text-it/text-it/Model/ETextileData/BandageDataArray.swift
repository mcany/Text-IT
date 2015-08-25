//
//  BandageDataArray.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/17/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol BandageDataArrayJSExports : JSExport {
    //static func new() -> LowPassFilter
    
    var bandageDataSession: [THBandageData] {get}
    var x: [CGFloat] {get}
    var y: [CGFloat] {get}
    var z: [CGFloat] {get}
}

@objc(BandageDataArray)
class BandageDataArray: NSObject, BandageDataArrayJSExports {
    var bandageDataSession: [THBandageData] = []
    var x: [CGFloat] = []
    var y: [CGFloat] = []
    var z: [CGFloat] = []
}
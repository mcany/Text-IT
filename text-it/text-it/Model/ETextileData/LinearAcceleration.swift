//
//  LinearAcceleration.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/2/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol LinearAccelerationJSExports : JSExport {
    //static func new() -> LowPassFilter
    
    var x: CGFloat {get}
    var y: CGFloat {get}
    var z: CGFloat {get}
}

@objc(LinearAcceleration)
class LinearAcceleration: NSObject, LinearAccelerationJSExports {

    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var z: CGFloat = 0.0
    //var sensorData: THBandageData;
    
    override init() {
        
    }
}

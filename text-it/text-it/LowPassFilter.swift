//
//  LowPassFilter.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/7/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore


// Custom protocol must be declared with `@objc`
@objc
protocol LowPassFilterJSExports : JSExport {
    func lowPass(accData:[CGFloat], kFilteringFactor:CGFloat, frequency: CGFloat) -> [CGFloat]
    func test()
    static func new() -> LowPassFilter
}

// Custom class must inherit from `NSObject`
@objc(LowPassFilter)
class LowPassFilter: NSObject,LowPassFilterJSExports  {
    
    override static func new() -> LowPassFilter {
        return LowPassFilter()
    }
    
    func test()
    {
        println("success!");
    }
    
    func lowPass(accData:[CGFloat], kFilteringFactor:CGFloat, frequency: CGFloat) -> [CGFloat]
    {
        var cgFloatArray: [CGFloat] = []
        let dt = 1.0 / kFilteringFactor;
        let RC = 1.0 / frequency;
        let alpha = dt / (dt + RC);
       
        var index: Int
        for index = 0; index < accData.count; ++index {
            cgFloatArray.append((alpha * accData[index]) + ((1-alpha) * accData[index-1]))
        }
        
        return cgFloatArray
    }
    
}
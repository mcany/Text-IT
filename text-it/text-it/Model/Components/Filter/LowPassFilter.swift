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
    func filter(data:[CGFloat],_ kFilteringFactor:CGFloat,_ frequency: CGFloat) -> [CGFloat]
    func test(acc:[CGFloat],_ asd:Int) -> [CGFloat]
    static func new() -> LowPassFilter
}

// Custom class must inherit from `NSObject`
@objc(LowPassFilter)
class LowPassFilter: Component,LowPassFilterJSExports  {
    
    override static func new() -> LowPassFilter {
        return LowPassFilter()
    }
    
    func test(acc:[CGFloat],_ asd:Int) -> [CGFloat]
    {
        println("success!")
        return acc
    }
    
    func filter(data:[CGFloat],_ kFilteringFactor:CGFloat,_ frequency: CGFloat) -> [CGFloat]
    {
        var filteredData: [CGFloat] = []
        let dt = 1.0 / kFilteringFactor;
        let RC = 1.0 / frequency;
        let alpha = dt / (dt + RC);
       
        var index: Int
        for index = 1; index < data.count; ++index {
            filteredData.append((alpha * data[index]) + ((1-alpha) * data[index-1]))
        }
        return filteredData
    }
}
//
//  RCFilter.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/9/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol RCFilterJSExports : JSExport {
    func filter(data:[CGFloat],_ kFilteringFactor:CGFloat,_ frequency: CGFloat) -> [CGFloat]
    static func new() -> RCFilter
}

// Custom class must inherit from `NSObject`
@objc(RCFilter)
class RCFilter: Component,RCFilterJSExports  {
    
    override static func new() -> RCFilter {
        return RCFilter()
    }
    
    func filter(data:[CGFloat],_ kFilteringFactor:CGFloat,_ frequency: CGFloat) -> [CGFloat]
    {
        var filteredData: [CGFloat] = []

        var index: Int
        for index = 1; index < data.count-1; ++index {
            filteredData.append((data[index-1] / 4) + (data[index] / 2) + (data[index+1] / 4))
        }
        return filteredData
    }
}


//
//  HighPassFilter.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/24/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol HighPassFilterJSExports : JSExport {
    func filter(data:[CGFloat],_ kFilteringFactor:CGFloat,_ frequency: CGFloat) -> [CGFloat]
    static func new() -> HighPassFilter
}

@objc(HighPassFilter)
class HighPassFilter: Component, HighPassFilterJSExports{
    
    override static func new() -> HighPassFilter {
        return HighPassFilter()
    }
    
    // Return RC high-pass filter 
    func filter(data:[CGFloat],_ kFilteringFactor:CGFloat,_ frequency: CGFloat) -> [CGFloat]
    {
        var filteredData: [CGFloat] = []
        let dt = 1.0 / kFilteringFactor;
        let RC = 1.0 / frequency;
        let alpha = RC / (dt + RC);
        
        var index: Int
        filteredData.append(data[0])
        for index = 1; index < data.count; ++index {
            filteredData.append((alpha * filteredData[index-1]) + alpha * (data[index] - data[index-1]))
        }
        return filteredData
    }
}
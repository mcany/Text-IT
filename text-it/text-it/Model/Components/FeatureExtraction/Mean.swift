//
//  Mean.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/24/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol MeanJSExports : JSExport {
    
    func geometricMean(arrayData:[CGFloat]) -> CGFloat
    func arithmeticMean(arrayData:[CGFloat]) -> CGFloat
    static func new() -> Mean
}

@objc(Mean)
class Mean: Component, MeanJSExports {
    
    override static func new() -> Mean {
        return Mean()
    }
    
    func geometricMean(arrayData:[CGFloat]) -> CGFloat
    {
        return pow(arrayData.reduce(1.0,combine:*),1.0/CGFloat(count(arrayData)))
    }
    
    func arithmeticMean(arrayData:[CGFloat]) -> CGFloat
    {
        return arrayData.reduce(0.0,combine:+)/CGFloat(count(arrayData))
    }
}

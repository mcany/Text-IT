//
//  StandardDeviation.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/5/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol StandardDeviationJSExports : JSExport {
    
    func deviation(arrayData:[CGFloat]) -> CGFloat
    static func new() -> StandardDeviation
}

@objc(StandardDeviation)
class StandardDeviation: Component, StandardDeviationJSExports {

    override static func new() -> StandardDeviation {
        return StandardDeviation()
    }
    
    
    func deviation(arrayData:[CGFloat]) -> CGFloat
    {
        let length = CGFloat(arrayData.count)
        let avg = arrayData.reduce(0, combine: {$0 + $1}) / length
        let sumOfSquaredAvgDiff = arrayData.map { pow($0 - avg, 2.0)}.reduce(0, combine: {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
}

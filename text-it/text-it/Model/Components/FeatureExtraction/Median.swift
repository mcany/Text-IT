//
//  Median.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/24/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol MedianJSExports : JSExport {
    
    func median(arrayData:[CGFloat]) -> CGFloat
    static func new() -> Median
}

@objc(Median)
class Median: Component, MedianJSExports {
    
    override static func new() -> Median {
        return Median()
    }
    
    func median(arrayData:[CGFloat]) -> CGFloat
    {
        if(count(arrayData) > 0)
        {
            var data = arrayData
            data.sort(<)
            let l = count(data)
            return l%2==0 ?(data[l/2]+data[l/2+1])/2:data[l/2]
        }
        return 0
    }
}

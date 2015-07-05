//
//  PeakDetection.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/2/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol PeakDetectionJSExports : JSExport {
    var maxPeaks: [CGFloat] {get}
    var minPeaks: [CGFloat] {get}
    var numOfMaxPeaks: Int {get}
    var numOfMinPeaks: Int {get}
    
    func detectPeaks(arrayData:[CGFloat],_ peakThreshold:CGFloat )
    static func new() -> PeakDetection
}

// Custom class must inherit from `NSObject`
@objc(PeakDetection)
class PeakDetection: Component, PeakDetectionJSExports{
    
    //%PEAKDET Detect peaks in a vector
    //      [MAXTAB, MINTAB] = PEAKDET(V, DELTA) finds the local
    //       maxima and minima ("peaks") in the vector V.
    //       MAXTAB and MINTAB consists of two columns. Column 1
    //       contains indices in V, and column 2 the found values.
    //        With [MAXTAB, MINTAB] = PEAKDET(V, DELTA, X) the indices
    //       in MAXTAB and MINTAB are replaced with the corresponding
    //        X-values.
    //
    //       A point is considered a maximum peak if it has the maximal
    //       value, and was preceded (to the left) by a value lower by
    //       DELTA.
    //      Eli Billauer, 3.4.05 (Explicitly not copyrighted).
    //      This function is released to the public domain; Any use is allowed.
    
    var maxPeaks: [CGFloat]{
        didSet{
            self.numOfMaxPeaks = self.maxPeaks.count
        }
    }
    
    var minPeaks: [CGFloat]{
        didSet{
            self.numOfMinPeaks = self.minPeaks.count
        }
    }
    
    var numOfMaxPeaks: Int
    var numOfMinPeaks: Int

    
    override static func new() -> PeakDetection {
        return PeakDetection()
    }
    
    override init() {
        self.maxPeaks = []
        self.minPeaks = []
        self.numOfMaxPeaks = 0
        self.numOfMinPeaks = 0
        super.init()
    }
    
    func detectPeaks(arrayData:[CGFloat],_ peakThreshold:CGFloat )
    {
        self.maxPeaks = []
        self.minPeaks = []
        
        if(peakThreshold <= 0)
        {
            return
        }
        var minimum = CGFloat.max
        var maximum = CGFloat.min
        var mnpos = 0
        var mxpos = 0
        var lookformax = true
        
        
        for var index = 0; index < arrayData.count; ++index {
            var current = arrayData[index]
            
            if (current > maximum)
            {
                maximum = current
            }
            
            if (current < minimum)
            {
                minimum = current
            }
            
            
            if (lookformax)
            {
                if(current < maximum - peakThreshold)
                {
                    self.maxPeaks.append(maximum)
                    minimum = current
                    lookformax = false
                }
            }
            else
            {
                if(current > minimum + peakThreshold)
                {
                    self.minPeaks.append(minimum)
                    minimum = current
                    lookformax = true
                }
            }
        }
        //println(maxPeaks)
    }
}
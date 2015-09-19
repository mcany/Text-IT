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
    var numberOfMaxPeaks: Int {get}
    var numberOfMinPeaks: Int {get}
    var positionOfMaxPeaks: [CGFloat] {get}
    var positionOfMinPeaks: [CGFloat] {get}
    
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
            self.numberOfMaxPeaks = self.maxPeaks.count
        }
    }
    
    var minPeaks: [CGFloat]{
        didSet{
            self.numberOfMinPeaks = self.minPeaks.count
        }
    }
    
    var numberOfMaxPeaks: Int
    var numberOfMinPeaks: Int
    
    var positionOfMaxPeaks = [CGFloat]()
    var positionOfMinPeaks = [CGFloat]()
    
    override static func new() -> PeakDetection {
        return PeakDetection()
    }
    
    override init() {
        self.maxPeaks = []
        self.minPeaks = []
        self.numberOfMaxPeaks = 0
        self.numberOfMinPeaks = 0
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
        var minimumPosition = -1
        var maximumPosition = -1
        var mnpos = 0
        var mxpos = 0
        var lookformax = true
        
        
        for var index = 0; index < arrayData.count; ++index {
            var current = arrayData[index]
            
            if (current > maximum)
            {
                maximum = current
                maximumPosition = index
            }
            
            if (current < minimum)
            {
                minimum = current
                minimumPosition = index
            }
            
            
            if (lookformax)
            {
                if(current < maximum - peakThreshold)
                {
                    if(!contains(self.maxPeaks, maximum))
                    {
                        self.maxPeaks.append(maximum)
                        self.positionOfMaxPeaks.append(CGFloat(maximumPosition))
                        maximum = current
                    }
                    lookformax = false

                }
            }
            else
            {
                if(current > minimum + peakThreshold)
                {
                    if(!contains(self.minPeaks, minimum))
                    {
                        self.minPeaks.append(minimum)
                        self.positionOfMinPeaks.append(CGFloat(minimumPosition))
                        minimum = current
                    }
                    lookformax = true

                }
            }
        }
    }
}
//
//  FastFourierTransform.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/24/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore
import Accelerate

// Custom protocol must be declared with `@objc`
@objc
protocol FastFourierTransformJSExports : JSExport {
    func fft(input: [CGFloat]) -> [CGFloat]
    static func new() -> FastFourierTransform
}

@objc(FastFourierTransform)
class FastFourierTransform: Component, FastFourierTransformJSExports {
    
    override static func new() -> FastFourierTransform {
        return FastFourierTransform()
    }
    
    func fft(input: [CGFloat]) -> [CGFloat] {
        
        var real = input.map {
            Float($0 as CGFloat)
        }
        
        //var real = [Float](input)
        var imaginary = [Float](count: input.count, repeatedValue: 0.0)
        var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
        
        let length = vDSP_Length(floor(log2(Float(input.count))))
        let radix = FFTRadix(kFFTRadix2)
        let weights = vDSP_create_fftsetup(length, radix)
        vDSP_fft_zip(weights, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
        
        var magnitudes = [Float](count: input.count, repeatedValue: 0.0)
        vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
        
        var normalizedMagnitudes = [Float](count: input.count, repeatedValue: 0.0)
        vDSP_vsmul(sqrt(magnitudes), 1, [2.0 / Float(input.count)], &normalizedMagnitudes, 1, vDSP_Length(input.count))
        
        vDSP_destroy_fftsetup(weights)
        
        var returnNormalizedMagnitudes = normalizedMagnitudes.map{
            CGFloat($0 as Float)
        }
        
        return returnNormalizedMagnitudes
    }
    
    func sqrt(x: [Float]) -> [Float] {
        var results = [Float](count: x.count, repeatedValue: 0.0)
        vvsqrtf(&results, x, [Int32(x.count)])
        
        return results
    }
}
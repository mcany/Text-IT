//
//  text_itTests.swift
//  text-itTests
//
//  Created by Mertcan Yigin on 5/29/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import XCTest

class text_itTests: XCTestCase {
    
    let array: [CGFloat] = [5,1,7,21,62,77,1431,6,3,3]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFeatureExtractionMedian()
    {
        var median = Median()
        var calculatedMedian = median.median(array)
        var expectedMedian = CGFloat(14)
        
        XCTAssertEqual(expectedMedian, calculatedMedian, "should be equal")
    }
    
    func testFeatureExtractionStandardDeviation()
    {
        var standard = StandardDeviation()
        var calculatedSTD = standard.deviation(array)
        var expectedSTD = CGFloat(423.90546115849941)
        
        XCTAssertEqual(expectedSTD, calculatedSTD, "should be equal")
    }
    
    func testFeatureExtractionPeakDetection()
    {
        var peakDetector = PeakDetection()
        peakDetector.detectPeaks(array, 10)
        var expectedMaxPeak = 1
        
        XCTAssertEqual(expectedMaxPeak, peakDetector.numberOfMaxPeaks, "should be equal")
    }
    
    func testFeatureExtractionMean()
    {
        var mean = Mean()
        var arithmeticMean = mean.arithmeticMean(array)
        var expectedArithmeticMean = CGFloat(161.59999999999999)
        
        XCTAssertEqual(expectedArithmeticMean, arithmeticMean, "should be equal")
        
        var geometricMean = mean.geometricMean(array)
        var expectedGeometricMean = CGFloat(13.909781716087181)
        
        XCTAssertEqual(expectedGeometricMean, geometricMean, "should be equal")
    }
    
    func testFeatureExtractionFFT()
    {
        var fft = FastFourierTransform()
        var fftValue = fft.fft(array)
        XCTAssert(true, "Pass")
    }
}

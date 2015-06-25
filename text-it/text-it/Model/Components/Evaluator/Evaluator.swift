//
//  Evaluator.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/11/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol EvaluatorJSExports : JSExport {
    var testCases: [TestCase] { get }

    static func new() -> Evaluator
    func addTest(testCase: TestCase) -> [TestCase]
    func removeTest(testCase: TestCase) -> [TestCase]
    func evaluateAllTests()

}

// Custom class must inherit from `NSObject`
@objc(Evaluator)
class Evaluator: NSObject, EvaluatorJSExports {
    lazy var testCases = [TestCase]()

    override static func new() -> Evaluator {
        var evaluator = Evaluator()
        return evaluator
    }
    
    func addTest(testCase: TestCase) -> [TestCase]
    {
        self.testCases.append(testCase)
        return self.testCases
    }
    
    func removeTest(testCase: TestCase) -> [TestCase]
    {
        for var i=0; i < self.testCases.count;i++
        {
            if self.testCases[i] == testCase
            {
                self.testCases.removeAtIndex(i)
            }
        }
        return self.testCases
    }
    
    func evaluateAllTests()
    {
        for testCase in self.testCases
        {
            testCase.evaluate()
        }
    }
}

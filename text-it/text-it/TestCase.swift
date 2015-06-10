//
//  TestCase.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/10/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol TestCaseJSExports : JSExport {
    //var code: String { get set }
    //var name: String { get set }
    
    static func new() -> TestCase
}

// Custom class must inherit from `NSObject`
@objc(TestCase)
class TestCase: NSObject, TestCaseJSExports {
    static  var myWindowController: TestCaseWindowController! = TestCaseWindowController(windowNibName: "TestCaseWindow")

    dynamic var code: String = ""
    dynamic var name: String = ""
    static var context: JSContext!

    override static func new() -> TestCase {
        var testCase = TestCase()
        openTestCaseWindows(testCase)
        return testCase
    }
    
    static func openTestCaseWindows(testCase : TestCase)
    {
        myWindowController.setJSContext(context)
        myWindowController.settestCase(testCase)
        myWindowController.showWindow(nil)

    }
}



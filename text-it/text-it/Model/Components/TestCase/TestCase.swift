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
    var code: String { get }
    var name: String { get }
    static func new() -> TestCase
    func change() -> TestCase
    func evaluate()
}

// Custom class must inherit from `NSObject`
@objc(TestCase)
class TestCase: Component, TestCaseJSExports {
    static  var myWindowController: TestCaseWindowController!

    var code: String = ""
    var name: String = ""
    static var staticContext: JSContext!
    var context: JSContext!
    
    override init()
    {
        self.code = ""
        self.name = ""
    }
    
    override static func new() -> TestCase {
        var testCase = TestCase()
        openTestCaseWindows(testCase)
        testCase.context = staticContext
        return testCase
    }
    
    static func openTestCaseWindows(testCase : TestCase)
    {
        myWindowController = TestCaseWindowController(windowNibName: "TestCaseWindow")
        myWindowController.setJSContext(staticContext)
        myWindowController.settestCase(testCase)
        myWindowController.showWindow(nil)
    }
    
    func change() -> TestCase
    {
        TestCase.openTestCaseWindows(self)
        return self
    }
    
    func evaluate()
    {
        println(self.context.evaluateScript(self.name + "()" ))
    }
}



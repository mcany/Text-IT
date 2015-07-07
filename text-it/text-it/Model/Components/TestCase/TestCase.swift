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
class TestCase: Component, TestCaseJSExports, NSCoding {
    static  var myWindowController: TestCaseWindowController!

    var code: String = ""
    var name: String = ""
    
    override init()
    {
        self.code = ""
        self.name = ""
    }
    
    override static func new() -> TestCase {
        var testCase = TestCase()
        openTestCaseWindow(testCase)
        return testCase
    }
    
    static func openTestCaseWindow(testCase : TestCase)
    {
        myWindowController = TestCaseWindowController(windowNibName: "TestCaseWindow")
        myWindowController.settestCase(testCase)
        myWindowController.showWindow(nil)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObjectForKey("code") as! String;
        name = aDecoder.decodeObjectForKey("name") as! String;
    }

    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(code, forKey: "code")
        aCoder.encodeObject(name, forKey: "name")
    }
    
    func change() -> TestCase
    {
        TestCase.openTestCaseWindow(self)
        return self
    }
    
    func evaluate()
    {
        println(JavascriptRunner.sharedInstance.execute(self.name + "()"))
    }
}



//
//  Parser.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/30/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol ParserJSExports : JSExport {
    var code: String { get }
    var name: String { get }
    
    static func new() -> Parser
    func change() -> Parser
}

// Custom class must inherit from `NSObject`
@objc(Parser)
class Parser: Component, ParserJSExports {
    static  var myWindowController: ParserWindowController!
    static var staticContext: JSContext!
    var context: JSContext!
    var code: String = ""
    var name: String = ""
    
    override static func new() -> Parser {
        var parser = Parser()
        openParserWindow(parser)
        parser.context = staticContext
        return parser
    }

    static func openParserWindow(parser : Parser)
    {
        myWindowController = ParserWindowController(windowNibName: "ParserWindow")
        myWindowController.parser = parser
        myWindowController.context = self.staticContext
        myWindowController.showWindow(nil)
    }
    
    func change() -> Parser
    {
        Parser.openParserWindow(self)
        return self
    }
}

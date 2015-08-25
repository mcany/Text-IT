//
//  Parser.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/30/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

@objc
protocol Parser  {
    func parse(data: UnsafeMutablePointer<UInt8>, length: Int)
}




@objc
protocol CustomParser : JSExport, Parser {
    var code: String { set get }
    var name: String { set get }
    
    static func new() -> CustomParser
    func change() -> CustomParser
    
    func parse(data: UnsafeMutablePointer<UInt8>, length: Int)
}
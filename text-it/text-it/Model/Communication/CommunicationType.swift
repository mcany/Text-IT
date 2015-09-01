//
//  CommunicationType.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol CommunicationTypeJSExports : JSExport {
    //static func new() -> I2CReply
    var name: String {get set}
}

@objc(CommunicationType)
class CommunicationType: NSObject, Printable, CommunicationTypeJSExports {
    var name: String = "NoName"
}

//
//  DigitalMessage.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol DigitalMessageJSExports : JSExport {
    static func new() -> DigitalMessage
    var pin: Int {get set}
    var data:[CGFloat] {get set}
    
}

@objc(DigitalMessage)
class DigitalMessage: CommunicationType, DigitalMessageJSExports{
    var pin: Int = 0
    var data = [CGFloat]()
    
    override static func new() -> DigitalMessage {
        return DigitalMessage()
    }
    
    override var description : String {
        var description = "type: DigitalMessage " + " name: " + self.name + " pin: " + self.pin.description + " data: " + data.description
        return description
    }
}

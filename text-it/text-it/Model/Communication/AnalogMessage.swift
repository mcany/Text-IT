//
//  AnalogMessage.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol AnalogMessageJSExports : JSExport {
    static func new() -> AnalogMessage
    var pin: Int {get set}
    var data:[CGFloat] {get set}
    
}

@objc(AnalogMessage)
class AnalogMessage: CommunicationType, AnalogMessageJSExports {
    var pin: Int = 0
    var data = [CGFloat]()
    
    override static func new() -> AnalogMessage {
        return AnalogMessage()
    }
    
    override var description : String {
        var description = "type: AnalogMessage " + " name: " + self.name + " pin: " + self.pin.description + " data: " + data.description
        return description
    }
}

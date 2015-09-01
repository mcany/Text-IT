//
//  I2CReply.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol I2CReplyJSExports : JSExport {
    static func new() -> I2CReply
    var address: Int {get set}
    var register: Int {get set}
    var size: Int {get set}
    var data:[[CGFloat]] {get set}
    
}

@objc(I2CReply)
class I2CReply: CommunicationType, I2CReplyJSExports {
    var address: Int = 0
    var register: Int = 0
    var size: Int = 0
    var data = [[CGFloat]]()
    
    override static func new() -> I2CReply {
        return I2CReply()
    }
 
    override var description : String {
        var description = "type: I2CReply " + " name: " + self.name + " address: " + self.address.description + " register: " + self.register.description + " data: " + data.description
        return description
    }
}

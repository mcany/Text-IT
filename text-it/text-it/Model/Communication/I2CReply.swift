//
//  I2CReply.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class I2CReply: CommunicationType {
    var address: Int = 0
    var register: Int = 0
    var size: Int = 0
    var data = [[CGFloat]]()
 
    override var description : String {
        var description = "type: I2CReply " + " name: " + self.name + ": address: " + self.address.description + " register: " + self.register.description + " data: " + data.description
        return description
    }
}

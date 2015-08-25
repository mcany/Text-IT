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
}

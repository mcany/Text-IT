//
//  DigitalMessage.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class DigitalMessage: CommunicationType {
    var pin: Int = 0
    var data = [CGFloat]()
    
    override var description : String {
        var description = "type: Digitalmessage " + " name: " + self.name + ": pin: " + self.pin.description + " data: " + data.description
        return description
    }
}

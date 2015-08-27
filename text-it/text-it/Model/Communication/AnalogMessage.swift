//
//  AnalogMessage.swift
//  text-it
//
//  Created by Mertcan Yigin on 8/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class AnalogMessage: CommunicationType {
    var pin: Int = 0
    var data = [CGFloat]()
    
    override var description : String {
        var description = "type: AnalogMessage " + " name: " + self.name + ": pin: " + self.pin.description + " data: " + data.description
        return description
    }
}

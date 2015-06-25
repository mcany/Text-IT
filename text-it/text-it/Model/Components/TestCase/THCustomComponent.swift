//
//  THCustomComponent.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/23/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class THCustomComponent: NSObject, NSCoding {

    
    var code: String = ""
    var name: String = ""

    override init()
    {
        self.code = ""
        self.name = ""
    }
    
    required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObjectForKey("code") as! String;
        name = aDecoder.decodeObjectForKey("name") as! String;
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(code, forKey: "code")
        aCoder.encodeObject(name, forKey: "name")
    }
    

}


//
//  ComponentModel.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/15/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class ComponentModel: NSObject {
    let name: String
    var methodNames: [SubComponentModel] = []

    init(name: String) {
        self.name = name
    }

}

class SubComponentModel: NSObject {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
}
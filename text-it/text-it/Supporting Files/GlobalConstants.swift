//
//  GlobalConstants.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/21/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa


struct Constants {
    struct NotificationKey {
        static let Welcome = "kWelcomeNotif"
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        static let FolderName = "Text-It"
        static let FullPath = Documents.stringByAppendingPathComponent(FolderName)
    }
}
//
//  THBandageData.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/2/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class THBandageData: NSObject {
    
    
    //var creationDate: NSDate?
    //var sensorID: NSNumber?
    //@property (nonatomic, retain) KHGravity *gravity;
    var linearAcceleration:  LinearAcceleration
    //var quaternion: KHQuaternion
    //var session: KHSensorDataSession;
    //var yawPitchRoll: KHYawPitchRoll;
    
    
    var data : Array<AnyObject>
    
    override init(){
        self.linearAcceleration = LinearAcceleration()
        data = [];
        super.init();
    }
    
    func printData() -> String
    {
        var returnString = ""
        returnString += "X: " + self.linearAcceleration.x.description
        returnString += " Y: " + self.linearAcceleration.y.description
        returnString += " Z: " + self.linearAcceleration.z.description
        returnString += "\n"
        return returnString
    }
}

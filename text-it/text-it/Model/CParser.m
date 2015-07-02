//
//  CParser.m
//  text-it
//
//  Created by Mertcan Yigin on 7/2/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

#import "CParser.h"

@implementation CParser


- (void)didReceiveData:(uint8_t *)data length:(NSInteger)length
{
    // Linear Acceleration
    int linAccelX = (short)((data[0] << 8) | data[1]);
    int linAccelY = (short)((data[2] << 8) | data[3]);
    int linAccelZ = (short)((data[4] << 8) | data[5]);
    

    /*
    KHSensorData *sensorData = [KHSensorData new];
    
    sensorData.creationDate = [NSDate date];
    sensorData.sensorID = [NSNumber numberWithInt:data[14]];
    
    // Quaternion
    float q[] = { 0.0f, 0.0f, 0.0f, 0.0f };
    
    q[0] = ((data[6] << 8) | data[7]) / 16384.0f;
    q[1] = ((data[8] << 8) | data[9]) / 16384.0f;
    q[2] = ((data[10] << 8) | data[11]) / 16384.0f;
    q[3] = ((data[12] << 8) | data[13]) / 16384.0f;
    
    for (int i = 0; i < 4; i++) {
        if (q[i] >= 2.0f) {
            q[i] -= 4.0f;
        }
    }
    
    // Raw Acceleration
    GLKVector3 rawAcceleration = GLKVector3Make(0, 0, 0);
    
    rawAcceleration.x = (short)((data[0] << 8) | data[1]);
    rawAcceleration.y = (short)((data[2] << 8) | data[3]);
    rawAcceleration.z = (short)((data[4] << 8) | data[5]);
    
    // Conversion into KneeHapp proprietary model objects
    KHQuaternion *quaternion = [KHQuaternion new];
    
    quaternion.w = [NSNumber numberWithFloat:q[0]];
    quaternion.x = [NSNumber numberWithFloat:q[1]];
    quaternion.y = [NSNumber numberWithFloat:q[2]];
    quaternion.z = [NSNumber numberWithFloat:q[3]];
    
    
    sensorData.quaternion = quaternion;
    sensorData.gravity = [KHSensorDataHelper gravityFromQuaternion:quaternion];
    sensorData.yawPitchRoll = [KHSensorDataHelper yawPitchRollFromQuaternion:quaternion];
    sensorData.linearAcceleration = [KHSensorDataHelper linearAccelFromRawAcceleration:rawAcceleration gravity:sensorData.gravity quaternion:quaternion];
    
    // Notify delegate
    [self.delegate didReceiveSensorData:sensorData];
     */
}

@end

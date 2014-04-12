//
//  CMMotionManager.h
//  Twerk
//
//  Created by William Gu on 4/12/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CMMotionManager : NSObject

//not sure yet
//not sure yet
-(void)startDeviceMotionUpdates;

//hold time in seconds
@property(assign, nonatomic) NSTimeInterval accelerometerUpdateInterval;

@end


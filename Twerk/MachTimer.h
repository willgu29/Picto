//
//  MachTimer.h
//  Picto
//
//  Created by William Gu on 8/24/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <mach/mach_time.h>

@interface MachTimer : NSObject
{
    uint64_t timeZero;
}

+ (id) timer;

- (void) start;
- (uint64_t) elapsed;
- (float) elapsedSeconds;
@end
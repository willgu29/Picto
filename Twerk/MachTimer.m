//
//  MachTimer.m
//  Picto
//
//  Created by William Gu on 8/24/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "MachTimer.h"

static mach_timebase_info_data_t timeBase;

@implementation MachTimer

+ (void) initialize
{
    (void) mach_timebase_info( &timeBase );
}

+ (id) timer
{
#if( __has_feature( objc_arc ) )
    return [[[self class] alloc] init];
#else
    return [[[[self class] alloc] init] autorelease];
#endif
}

- (id) init
{
    if( (self = [super init]) ) {
        timeZero = mach_absolute_time();
    }
    return self;
}

- (void) start
{
    timeZero = mach_absolute_time();
}

- (uint64_t) elapsed
{
    return mach_absolute_time() - timeZero;
}

- (float) elapsedSeconds
{
    return ((float)(mach_absolute_time() - timeZero))
    * ((float)timeBase.numer) / ((float)timeBase.denom) / 1000000000.0f;
}

@end
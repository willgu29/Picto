//
//  HashDisplay.m
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "HashDisplay.h"

@implementation HashDisplay

-(instancetype)initWithName:(NSString *)name andMediaCount:(NSString *)mediaCount
{
    self = [super initWithName:name];
    if (self)
    {
        _mediaCount = mediaCount;
    }
    return self;
}

@end

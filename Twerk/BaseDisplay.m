//
//  BaseDisplay.m
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "BaseDisplay.h"

@implementation BaseDisplay

-(instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        _name = name;
    }
    return self;
}

@end

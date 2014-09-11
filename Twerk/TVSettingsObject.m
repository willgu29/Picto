//
//  TVSettingsObject.m
//  TrackView
//
//  Created by William Gu on 9/3/14.
//  Copyright (c) 2014 tianyu. All rights reserved.
//

#import "TVSettingsObject.h"

@implementation TVSettingsObject

-(instancetype)initWithMainTitle:(NSString *)mainTitle andSubText:(NSString *)subText
{
    self = [super init];
    if (self)
    {
        _mainTitle = mainTitle;
        _subText = subText;
    }
    
    return self;
}

-(instancetype)initWithMainTitle:(NSString *)mainTitle andSubText:(NSString *)subText andOn:(BOOL)on
{
    self = [super init];
    if (self)
    {
        _mainTitle = mainTitle;
        _subText = subText;
        _on = on;
        
    }
    
    return self;
}


@end

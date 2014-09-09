//
//  UserDisplay.m
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "UserDisplay.h"

@implementation UserDisplay

-(instancetype)initWithName:(NSString *)name andID:(NSString *)userID andProfilePicURL:(NSString *)profilePicURL
{
    self = [super initWithName:name];
    if (self)
    {
        _userID = userID;
        _profilePicURL = profilePicURL;
    }
    return self;
}

@end

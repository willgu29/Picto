//
//  UserData.m
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "UserData.h"

@implementation UserData

-(instancetype)initWithUsername:(NSString *)name andID:(NSString *)ID andProfilePicURL:(NSString *)picURL
{
    self = [super init];
    if (self)
    {
        _name = name;
        _userID = ID;
        _profilePicURL = picURL;
    }
    
    return self;
}



@end

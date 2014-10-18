//
//  CommentDataWrapper.m
//  Picto
//
//  Created by William Gu on 10/15/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CommentDataWrapper.h"

@implementation CommentDataWrapper

-(instancetype)initWith:(id)commentData
{
    self = [super init];
    if (self)
    {
        _comment = [commentData valueForKeyPath:@"text"];
        _profileURL = [commentData valueForKeyPath:@"from.profile_picture"];
        _username = [commentData valueForKeyPath:@"from.username"];
        _timeOfPost = [commentData valueForKeyPath:@"created_time"];
//        _estimatedHeight = [self heightForTextLabel:_comment].height;
    }
    return self;
}

-(instancetype)initWithComment:(NSString *)string andTime:(NSString *)time andProfile:(NSString *)profile andUsername:(NSString *)user
{
    self = [super init];
    if (self)
    {
        _comment = string;
        _profileURL = profile;
        _username = user;
        _timeOfPost = time;
    }
    return self;
}



@end

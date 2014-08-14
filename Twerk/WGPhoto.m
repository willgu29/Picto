//
//  WGPhoto.m
//  Picto
//
//  Created by William Gu on 7/15/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "WGPhoto.h"
#import "AppDelegate.h"

@implementation WGPhoto


//Initialize a photo with UIImage, location, and initial setting of the userDid NOT view the photo yet. (we need to find a way to determine whether a user has viewed a photo yet and discard these photo so they don't see it again) (it'll still be in instagram)
-(WGPhoto*)initWithLocation:(CLLocationCoordinate2D)location andImageURL:(NSString *)imageURL andEnlarged:(NSString *)imageURLEnlarged
{
    self = [super init];
    
    if (self)
    {
        _photoURL = imageURL;
        _photoURLEnlarged = imageURLEnlarged;
        _locationOfPicture = location;
        _userDidView = NO;
    }
    
    return self;
}

-(instancetype)initWithLocation:(CLLocationCoordinate2D)location andImageURL:(NSString *)imageURL andEnlarged:(NSString *)imageURLEnlarged andOwner:(NSString *)owner andLikes:(NSString *)likes
{
    self = [super init];
    
    if (self)
    {
        _photoURL = imageURL;
        _photoURLEnlarged = imageURLEnlarged;
        _locationOfPicture = location;
        _userDidView = NO;
        _likes = likes;
        _ownerOfPhoto = owner;
    }
    
    return self;
}


@end

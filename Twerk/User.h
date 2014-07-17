//
//  User.h
//  Picto
//
//  Created by William Gu on 7/13/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "IGRequest.h"


@class Friend;

@interface User : NSObject <IGRequestDelegate>

@property (strong, nonatomic) NSMutableArray *followers; //of Followers
@property (strong, nonatomic) Friend *specificFriend;
@property (strong, nonatomic) MKUserLocation *currentLocation;
@property (strong, nonatomic) UIImage *profilePicture;
@property (strong, nonatomic) NSMutableArray *topMoments;

-(MKUserLocation *)getCurrentLocationOnMap:(MKMapView *)map; //Get location of user
-(Friend*) getFriendInfo; //get friend info like top pics, profile pic, etc
-(void) retrieveFollowersFromIG;


@end

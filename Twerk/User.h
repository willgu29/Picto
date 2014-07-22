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

-(void)getCurrentLocationOnMap:(MKMapView *)map; //Get location of user
-(Friend*) getFriendInfo; //get friend info like top pics, profile pic, etc
-(void) retrieveFollowersFromIG;


@end
//TODO: A user should have a list of people they are FOLLOWING (not sure if we need their followers..) and we will use this data to help do the autocomplete search (autofill a friend etc)  We should also know the user's current location when it is relevant (they are walking by a landmark, an area their friends had a "moment" etc.) We'll also need their array of SAVED IMPORTANT photos. Important/Unimportant/landmark may be the three ways we can mark a specific picture relative to the user. Important pictures will be stored in a SERVER for that user and we'll pull the data if their FOLLOWERS or THEMSELVES want to view their "top" moments.

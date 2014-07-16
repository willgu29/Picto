//
//  SearchData.h
//  Picto
//
//  Created by William Gu on 7/14/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Friend.h"

@interface SearchData : NSObject 

@property (strong, nonatomic) NSMutableArray *autoCompleteSearch;
@property (strong, nonatomic) NSMutableArray *bestFriends;
@property (strong, nonatomic) NSMutableArray *bestPictures;

@property (nonatomic) BOOL shouldDisplayBestOfFriend; //if true, display single best, otherwise display a region of photos of that friend

-(void)determineRegionOrSinglePhotoForFriend:(Friend *) someFriend;

-(void)retrieveBestFriendsFromFacebook; //some algorithm determining best friends
-(void)retrieveBestFriendsFromDatabase;
-(void)retrieveBestPicturesFromFacebook; //some algorithm determing best pictures
-(void)retrieveBestPicturesFromDatabase;

-(void)editObjectsInAutoCompleteSearch; //place objects in autocomplete search array


@end

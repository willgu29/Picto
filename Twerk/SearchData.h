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


__deprecated_msg("We can use this later for search bar probably");
@interface SearchData : NSObject 

@property (strong, nonatomic) NSMutableArray *autoCompleteSearch;
@property (strong, nonatomic) NSMutableArray *bestFriends;
@property (strong, nonatomic) NSMutableArray *bestPictures;

@property (nonatomic) BOOL shouldDisplayBestOfFriend; //if true, display single best, otherwise display a region of photos of that friend

//-(void)determineRegionOrSinglePhotoForFriend:(Friend *) someFriend;
//
//-(void)retrieveBestFriendsFromFacebook; //some algorithm determining best friends
//-(void)retrieveBestFriendsFromDatabase;
//-(void)retrieveBestPicturesFromFacebook; //some algorithm determing best pictures
//-(void)retrieveBestPicturesFromDatabase;
//
//-(void)editObjectsInAutoCompleteSearch; //place objects in autocomplete search array


@end
//TODO: SearchData is all about algorithms.  This doesn't necessarily need to be in a separate class but for clarity and neatness, it should work fine this way.  SearchData will be the main object to determine autocomplete in the search bar, autocomplete for locations, and also the logic for what pictures to display in a specific region or perhaps what region to go to next if the user is asking for a new region to explore/ what picture to show next of a friend etc..  It could also potentially determine important/landmark/unimportant.

//
//  SearchData.h
//  Picto
//
//  Created by William Gu on 7/14/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "IGRequest.h"
#import "HashTagSearch.h"
#import "LocationSearch.h"

@interface SearchData : NSObject <IGRequestDelegate>

@property (strong, nonatomic) LocationSearch *location;
@property (strong, nonatomic) HashTagSearch *hashTag;
@property (strong, nonatomic) NSArray *autoCompleteSearchData; //OF BaseDisplay or class of
@property (strong, nonatomic) NSMutableOrderedSet *searchResultsData; //For IGRequestDelegate (non parsed data)
@property (strong, nonatomic) NSMutableOrderedSet *searchPicturesArray; //Parsed


-(void)fillSearchOptionsAvailable:(NSString *)searchText; //initial 3 (users, hashtags, location)
-(void)fillAutoCompleteSearchData;


-(void)fillAutoCompleteSearchDataWithUsers:(NSString *)searchText withArrayOfFollowing:(NSMutableSet *)parsedFollowing;
-(void)fillAutoCompleteSearchDataWithHashTags:(NSString *)searchText;
-(void)fillAutoCompleteSearchDataWithLocations:(NSString *)searchText;


-(void)searchUsernameWithName:(NSString *)userID;
-(void)searchHashTagWithName:(NSString *)nameOfHashTag;
-(void)searchLocationWithName:(NSString *)nameOfLocation;
-(void)searchLocationWithLocation:(MKMapItem *)item1;
//@property (strong, nonatomic) NSMutableArray *autoCompleteSearch;
//@property (strong, nonatomic) NSMutableArray *bestFriends;
//@property (strong, nonatomic) NSMutableArray *bestPictures;
//
//@property (nonatomic) BOOL shouldDisplayBestOfFriend; //if true, display single best, otherwise display a region of photos of that friend


@end
//TODO: SearchData is all about algorithms.  This doesn't necessarily need to be in a separate class but for clarity and neatness, it should work fine this way.  SearchData will be the main object to determine autocomplete in the search bar, autocomplete for locations, and also the logic for what pictures to display in a specific region or perhaps what region to go to next if the user is asking for a new region to explore/ what picture to show next of a friend etc..  It could also potentially determine important/landmark/unimportant.

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


@interface SearchData : NSObject <IGRequestDelegate>


@property (strong, nonatomic) NSMutableArray *autoCompleteSearchData; //OF NSSTRING * (for tableView)
@property (strong, nonatomic) NSMutableSet *searchResultData; //For IGRequestDelegate (non parsed data)
@property (strong, nonatomic) NSMutableOrderedSet *searchPicturesArray; //Parsed


-(void)fillSearchOptionsAvailable:(NSString *)searchText;
-(void)fillAutoCompleteSearchData;


-(void)loadUserPictures;
-(void)loadHashTagPictures;
-(void)loadLocationPictures;

//@property (strong, nonatomic) NSMutableArray *autoCompleteSearch;
//@property (strong, nonatomic) NSMutableArray *bestFriends;
//@property (strong, nonatomic) NSMutableArray *bestPictures;
//
//@property (nonatomic) BOOL shouldDisplayBestOfFriend; //if true, display single best, otherwise display a region of photos of that friend


@end
//TODO: SearchData is all about algorithms.  This doesn't necessarily need to be in a separate class but for clarity and neatness, it should work fine this way.  SearchData will be the main object to determine autocomplete in the search bar, autocomplete for locations, and also the logic for what pictures to display in a specific region or perhaps what region to go to next if the user is asking for a new region to explore/ what picture to show next of a friend etc..  It could also potentially determine important/landmark/unimportant.

//
//  SearchData.m
//  Picto
//
//  Created by William Gu on 7/14/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "SearchData.h"
#import "AppDelegate.h"
#import "UserData.h"
#import "BaseDisplay.h"
#import "UserDisplay.h"
#import "HashDisplay.h"
#import "LocationDisplay.h"
#import "CustomAnnotation.h"
#import "MapViewController.h"

const NSInteger TIMES_TO_PAGINATE = 0;

@implementation SearchData
{
    int countPaginations;
    NSString *mostRecentMaxTagID;
    NSString *userIDPrivate;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _location = [[LocationSearch alloc] init];
        _hashTag = [[HashTagSearch alloc] init];
    }
    return self;
}


-(void)setAutoCompleteSearchData:(NSArray *)autoCompleteSearchData
{
    if (_autoCompleteSearchData == autoCompleteSearchData)
    {
        return;
    }
    if (_autoCompleteSearchData == nil)
    {
        _autoCompleteSearchData = [[NSArray alloc] init];
    }
    _autoCompleteSearchData = autoCompleteSearchData;
    
    
}

#pragma mark -Fill TableView with entries

-(void)fillSearchOptionsAvailable:(NSString *)searchText
{
    countPaginations = 0;
    
    _searchPicturesArray = nil;
    _searchResultsData = nil;
    
    NSString *user = [NSString stringWithFormat:@"Search for users: \"%@\"", searchText];
    NSString *hashtag = [NSString stringWithFormat:@"Search for hashtags: \"%@\"", searchText];
    NSString *location = [NSString stringWithFormat:@"Search for locations: \"%@\"", searchText];
    
    BaseDisplay *user1 = [[BaseDisplay alloc] initWithName:user];
    BaseDisplay *hashtag1 = [[BaseDisplay alloc] initWithName:hashtag];
    BaseDisplay *location1 = [[BaseDisplay alloc] initWithName:location];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[user1, hashtag1, location1]];
    [self setAutoCompleteSearchData:array];
}


//-(void)fillAutoCompleteSearchData
//{
//    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[@"Los Angeles",@"California", @"Boston", @"UCLA", @"Will Gu", @"willgu29", @"#cars", @"#hot", @"#tfmgirls"]];
//    [self setAutoCompleteSearchData:array];
//    
//}


-(void)fillAutoCompleteSearchDataWithUsers:(NSString *)searchText withArrayOfFollowing:(NSMutableSet *)parsedFollowing
{
    NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
//    NSString *searchAttribute = @"self";
    NSString *searchAttribute = @"self.name";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
    
    //BEGINSWITH, ENDSWITH LIKE MATCHES CONTAINS
    NSArray *array = [NSArray arrayWithArray:[parsedFollowing allObjects]];
//    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
//    for (UserData* user in parsedFollowing)
//    {
//        [nameArray addObject:user.name];
//    }
//    
    [self setAutoCompleteSearchData:[array filteredArrayUsingPredicate:predicate]];
    
    
    if ([_autoCompleteSearchData count] == 0)
    {
//        UserData *nilData = [[UserData alloc] initWithUsername:@"No matches found" andID:nil andProfilePicURL:nil];
        [self setAutoCompleteSearchData:[self createNoMatchesArray]];
        //TODO: add some suggestions
    }
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.mapVC.autoCompleteTableView reloadData];
}

-(void)fillAutoCompleteSearchDataWithHashTags:(NSString *)searchText
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayHashTagData) name:@"done parsing hashtag" object:nil];
//    _hashTag = nil;
//    _hashTag = [[HashTagSearch alloc] init];
    [_hashTag fillAutoCompleteSearchDataWithHashTags:searchText];
}

-(void)displayHashTagData
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"done parsing hashtag" object:nil];
    HashDisplay *display = [_hashTag.hashTagParsed lastObject]; //Only parses 1 hashtag
    if (display.mediaCount == 0)
    {
        //TODO: add some suggestions
        [self setAutoCompleteSearchData:[self createNoMatchesArray]];
    }
    else
    {
//        [self setAutoCompleteSearchData:@[[NSString stringWithFormat:@"%@  %ld",_hashTag.name, (long)_hashTag.mediaCount]]];
        [self setAutoCompleteSearchData:_hashTag.hashTagParsed];
        //TODO: add post count to table view
    }
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.mapVC.autoCompleteTableView reloadData];
}

-(void)fillAutoCompleteSearchDataWithLocations:(NSString *)searchText
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displaySearchResults) name:@"location search done" object:nil];
//    _location = nil;
//    _location = [[LocationSearch alloc] init];
    [_location performSearch:searchText];
    
//    location search done
    
    
    
}

-(void)displaySearchResults
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"location search done" object:nil];
    if ([_location.searchResults count] == 0)
    {
        [self setAutoCompleteSearchData:[self createNoMatchesArray]];
    }
    else
    {
        [self setAutoCompleteSearchData:_location.searchResults];
        
    }
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.mapVC.autoCompleteTableView reloadData];
}


-(NSArray *)createNoMatchesArray
{
    BaseDisplay *baseDisplay = [[BaseDisplay alloc] initWithName:@"No matches found"];
    NSArray *array = @[baseDisplay];
    return array;
}


#pragma mark - Perform IGRequest searches


-(void)searchUsernameWithName:(NSString *)userID
{
    userIDPrivate = userID;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%d/media/recent", userID.intValue], @"method", nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram requestWithParams:params delegate:self];
}

-(void)searchHashTagWithName:(NSString *)nameOfTag
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"tags/%@/media/recent", nameOfTag], @"method", nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram requestWithParams:params delegate:self];
    
}

-(void)searchLocationWithName:(NSString *)nameOfLocation
{
    //We should just do a normal search probably (give name location option and on select we do our normal search)
    //Check performSearch: in MapViewController.m
}

-(void)searchLocationWithLocation:(MKMapItem *)item1
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(item1.placemark.coordinate, [(CLCircularRegion *)item1.placemark.region radius], [(CLCircularRegion *)item1.placemark.region radius]);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = item1.placemark.coordinate;
    annotation.title = item1.name;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate.mapVC.mapView addAnnotation:annotation];
    [appDelegate.mapVC.mapView setRegion:viewRegion animated:YES];

}

-(void)setSearchResultsData:(NSMutableSet *)searchResultsData
{
    if (_searchResultsData == searchResultsData)
    {
        return;
    }
    if (_searchResultsData == nil)
    {
        _searchResultsData = [[NSMutableSet alloc] init];
    }
    _searchResultsData = searchResultsData;
    
}

-(void)setSearchPicturesArray:(NSMutableOrderedSet *)searchPicturesArray
{
    if (_searchPicturesArray == searchPicturesArray)
    {
        return;
    }
    if (_searchPicturesArray == nil)
    {
        _searchPicturesArray = [[NSMutableOrderedSet alloc] init];
    }
    _searchPicturesArray = searchPicturesArray;
    
}

#pragma mark - Parse Data

-(void)parseDataWithSearchType
{
    //TODO: Display error on no pictures or whatever
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (_searchPicturesArray == nil)
    {
        _searchPicturesArray = [[NSMutableOrderedSet alloc] init];
    }
    if (_searchResultsWithLocation == nil)
    {
        _searchResultsWithLocation = [[NSMutableOrderedSet alloc] init];
    }
    
    if ([_searchResultsData count] == 0 && ([_searchPicturesArray count] <= 6) && (_lock == NO) && (mostRecentMaxTagID != nil))
    {
        if (appDelegate.mapVC.searchType == USER)
        {
            [self searchUsernameWithName:userIDPrivate andMaxID:mostRecentMaxTagID];
        }
        else if(appDelegate.mapVC.searchType == HASHTAG)
        {
            [self searchHashTagWithName:appDelegate.mapVC.searchField.text andMaxID:mostRecentMaxTagID];
        }
    }
    else
    {
        [self zoomToNextPicture];
   
    }
//    if ([_searchPicturesArray count] <= 3)
//    {
//        [self zoomToNextPicture];
//        [self parseNextPicture];
//    }
//    else
//    {
//        [self zoomToNextPicture];
//
//    }
    
    
//    if ([_searchResultsWithLocation count] < 5)
//    {
//        [self zoomToNextPicture];
//        [self parseNumber:3 ofImagesInArray:_searchPicturesArray];
//
//    }
//    else
//    {
//        [self zoomToNextPicture];
//    }
//    
//    
    
 
    
 
}

//-(void)parseNumber:(NSInteger)count ofImagesInArray:(NSMutableOrderedSet *)annotationArray
//{
//    for (int i = 0; i < count; i++)
//    {
//        if ([annotationArray count] == 0)
//        {
//            break;
//        }
//        CustomAnnotation *annotation = [annotationArray objectAtIndex:0];
//        [annotation createNewImage]; //TODO: Call this only when we need to preload
//        [annotation parseStringOfLocation:annotation.coordinate];
//        [annotationArray removeObjectAtIndex:0];
//        
//    }
//
//}

-(void)zoomToNextPicture
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if ([_searchPicturesArray count] >= 1)
    {
        CustomAnnotation *myAnnotation = [_searchPicturesArray objectAtIndex:0];
        [delegate.mapVC zoomToRegion:myAnnotation.coordinate withLatitude:50 withLongitude:50 withMap:delegate.mapVC.mapView];
        [delegate.mapVC.mapView addAnnotation:myAnnotation];
        [_searchPicturesArray removeObjectAtIndex:0];
        
    }
    else
    {
    
    }
}

-(void)parseNextPicture
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if (_lock == YES)
    {
        return;
    }
    
    _lock = YES;
    
    //TODO: pagination
    //... Recent requests return 20 pictures (with or without location) and then give pagination.
    if (_searchPicturesArray == nil)
    {
        _searchPicturesArray = [[NSMutableOrderedSet alloc] init];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        int someCounter = 0;

        for (id pictureURL in _searchResultsData)
        {
            
            if ( ! [appDelegate.mapVC shouldWeParseThisPicture:pictureURL])
            {
                continue;
            }
            else
            {
                //We good
            }
            
            CustomAnnotation *annotation = [appDelegate.mapVC parseAndReturnAnnotation:pictureURL];
//            NSInteger resultOfCheck = [appDelegate.mapVC checkAnnotationEnums:annotation];
//            
//            if (resultOfCheck == OVERLAP)
//            {
//                continue;
//            }
//            else if (resultOfCheck == DUPLICATE)
//            {
//                //try next pic
//                continue;
//            }
//            else if (resultOfCheck == FLOOD)
//            {
//                //stop loading pictures ffs
//                break;
//            }
//            else if (resultOfCheck == SUCCESS)
//            {
//                //YASS
//            }
            
            someCounter++;
            [appDelegate.mapVC hasFollowedUser:annotation];
            [annotation createNewImage]; //TODO: Call this only when we need to preload
            [annotation parseStringOfLocation:annotation.coordinate];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (appDelegate.mapVC.searchType == HASHTAG)
                {
                    annotation.isHashTag = YES;
                }
                else
                {
                    annotation.isFriend = YES;
                }
                
                [_searchPicturesArray addObject:annotation];
                
            });
        }
        _lock = NO;
        _searchResultsData = nil;
        
        [self performSelectorOnMainThread:@selector(parseDataWithSearchType) withObject:nil waitUntilDone:YES];
    });
}

-(void)searchUsernameWithName:(NSString *)userID andMaxID:(NSString *)maxID
{
    countPaginations = 0;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%d/media/recent?max_id=%@", userID.intValue, maxID], @"method", nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram requestWithParams:params delegate:self];
}

-(void)searchHashTagWithName:(NSString *)nameOfTag andMaxID:(NSString *)maxID
{
    countPaginations = 0;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"tags/%@/media/recent?max_id=%@", nameOfTag, maxID], @"method", nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram requestWithParams:params delegate:self];
}


//Same as User.m IGRequestDelegate
- (void)request:(IGRequest *)request didLoad:(id)result {
    //NSLog(@"Instagram did load: %@", result);
    if (_searchResultsData == nil)
    {
        _searchResultsData = [[NSMutableSet alloc]init];
    }
    [_searchResultsData addObjectsFromArray:[result objectForKey:@"data"]];

    
//    if ([(NSMutableArray*)[result objectForKey:@"pagination"] count] > 1  && (countPaginations < TIMES_TO_PAGINATE))
//    {
//        countPaginations++;
//        NSString* cursor = [result valueForKeyPath:@"pagination.next_max_tag_id"];
//        mostRecentMaxTagID = cursor;
//        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"tags/%@/media/recent?max_id=%@", appDelegate.mapVC.searchField.text, cursor], @"method", nil];
//        [appDelegate.instagram requestWithParams:params delegate:self];
//    }
    if ([(NSMutableArray*)[result objectForKey:@"pagination"] count] > 1)
    {
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSString* cursor = [[NSString alloc] init];
        if (delegate.mapVC.searchType == USER)
        {
            cursor = [result valueForKeyPath:@"pagination.next_max_id"];
        }
        else
        {
            cursor = [result valueForKeyPath:@"pagination.next_max_tag_id"];
        }
        mostRecentMaxTagID = cursor;
        [self performSelectorOnMainThread:@selector(parseNextPicture) withObject:nil waitUntilDone:YES];

    }
    else
    {
        [self performSelectorOnMainThread:@selector(parseNextPicture) withObject:nil waitUntilDone:YES];
    }
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}



@end

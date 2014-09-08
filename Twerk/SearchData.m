//
//  SearchData.m
//  Picto
//
//  Created by William Gu on 7/14/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "SearchData.h"
#import "AppDelegate.h"

@implementation SearchData

-(void)setAutoCompleteSearchData:(NSMutableArray *)autoCompleteSearchData
{
    if (_autoCompleteSearchData == autoCompleteSearchData)
    {
        return;
    }
    if (_autoCompleteSearchData == nil)
    {
        _autoCompleteSearchData = [[NSMutableArray alloc] init];
    }
    _autoCompleteSearchData = autoCompleteSearchData;
    
    
}

-(void)fillSearchOptionsAvailable:(NSString *)searchText
{
    NSString *user = [NSString stringWithFormat:@"Search for users: \"%@\"", searchText];
    NSString *hashtag = [NSString stringWithFormat:@"Search for hashtags: \"%@\"", searchText];
    NSString *location = [NSString stringWithFormat:@"Search for locations: \"%@\"", searchText];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[user, hashtag, location]];
    [self setAutoCompleteSearchData:array];
}


-(void)fillAutoCompleteSearchData
{
    //TODO: place actual data here
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[@"Los Angeles",@"California", @"Boston", @"UCLA", @"Will Gu", @"willgu29", @"#cars", @"#hot", @"#tfmgirls"]];
    [self setAutoCompleteSearchData:array];
    
}


-(void)fillAutoCompleteSearchDataWithUsers:(NSString *)searchText withArrayOfFollowing:(NSMutableSet *)parsedFollowing
{
    NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
    NSString *searchAttribute = @"self";
//    NSString *searchAttribute = @"username";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
    
    //BEGINSWITH, ENDSWITH LIKE MATCHES CONTAINS
    NSArray *array = [NSArray arrayWithArray:[parsedFollowing allObjects]];
    [self setAutoCompleteSearchData:[array filteredArrayUsingPredicate:predicate]];
    
    if ([_autoCompleteSearchData count] == 0)
    {
        [self setAutoCompleteSearchData:@[@"No matches found"]];
        //TODO: add some suggestions
    }
}

-(void)fillAutoCompleteSearchDataWithHashTags:(NSString *)searchText
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayHashTagData) name:@"done parsing hashtag" object:nil];
    _hashTag = [[HashTagSearch alloc] init];
    [_hashTag fillAutoCompleteSearchDataWithHashTags:searchText];
}

-(void)displayHashTagData
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"done parsing hashtag" object:nil];
    if ([_hashTag mediaCount] == 0)
    {
        //TODO: add some suggestions
        [self setAutoCompleteSearchData:@[@"No matches found"]];
    }
    else
    {
//        [self setAutoCompleteSearchData:@[[NSString stringWithFormat:@"%@  %ld",_hashTag.name, (long)_hashTag.mediaCount]]];
        [self setAutoCompleteSearchData:@[[NSString stringWithFormat:@"%@",_hashTag.name]]];
        //TODO: add post count to table view
    }
}

-(void)fillAutoCompleteSearchDataWithLocations:(NSString *)searchText
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displaySearchResults) name:@"location search done" object:nil];
    
    _location = [[LocationSearch alloc] init];
    [_location performSearch:searchText];
    
//    location search done
    
    
    
}

-(void)displaySearchResults
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"location search done" object:nil];
    if ([_location.searchResults count] == 0)
    {
        [self setAutoCompleteSearchData:@[@"No matches found"]];
    }
    else
    {
        NSMutableSet *names = [[NSMutableSet alloc] init];
        for (MKMapItem* mapItem in _location.searchResults)
        {
            [names addObject:mapItem.name];
        }
        NSArray *array = [NSArray arrayWithArray:[names allObjects]];
        [self setAutoCompleteSearchData:array];
        
    }
}






-(void)searchUsernameWithName:(NSString *)nameOfUser
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/media/recent", nameOfUser], @"method", nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram requestWithParams:params delegate:self];
}

-(void)searchTagWithName:(NSString *)nameOfTag
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



//Same as User.m IGRequestDelegate
- (void)request:(IGRequest *)request didLoad:(id)result {
    //NSLog(@"Instagram did load: %@", result);
    _searchResultsData = (NSMutableSet*)[result objectForKey:@"data"];
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"Load Geo" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Next Array Data Loaded" object:self];
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

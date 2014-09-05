//
//  SearchData.m
//  Picto
//
//  Created by William Gu on 7/14/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "SearchData.h"

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

@end

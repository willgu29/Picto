//
//  LocationSearch.m
//  Picto
//
//  Created by William Gu on 9/7/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "LocationSearch.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "LocationDisplay.h"

@implementation LocationSearch

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _searchResults = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void) performSearch:(NSString *)searchText
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //request a search with words from textField
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;
    // ???: maybe change VV later
    request.region = appDelegate.mapVC.mapView.region; //search results only in currently shown area of map
    //do the search
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         if (response.mapItems.count == 0)
         {
             NSLog(@"No matches");
             //TODO: Give error for no matches
         }
         else
         {
             //loop through all results (note: will only go through roughly 10 (restriction based on apple documentation))
             for (MKMapItem *item in response.mapItems)
             {
                 //add to array
//                 [_searchResults addObject:item];
//                 LocationDisplay *display = [[LocationDisplay alloc] initWithName:item.name andCoordinate:item.placemark.coordinate andURL:item.url andPlacemark:item.placemark];
                 LocationDisplay *display = [[LocationDisplay alloc] initWithName:item.name andItem:item];
                 [_searchResults addObject:display];
                 NSLog(@"name = %@", item.name);
                 NSLog(@"Phone = %@", item.phoneNumber);
                 NSLog(@"URL = %@", item.url);
                 NSLog(@"Placemark = %@", item.placemark);
                 //                 NSLog(@"Coordinate = %@", item.placemark.coordinate);
                 
             }
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"location search done" object:nil];
     }];

    
}


@end

//
//  User.m
//  Picto
//
//  Created by William Gu on 7/13/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "User.h"
#import "MapViewController.h"
#import "AppDelegate.h"

@implementation User



//get user location and set it to currentLocation
-(MKUserLocation *)getCurrentLocationOnMap:(MKMapView *)map
{
    MKUserLocation *userLocation = map.userLocation;
    _currentLocation = userLocation;
    return _currentLocation;
}


-(void)retrieveFollowersFromIG
{
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/followed-by", @"method", nil];
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    NSLog(@"Instagram did load: %@", result);
    self.followers = (NSMutableArray*)[result objectForKey:@"data"];
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

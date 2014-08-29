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
-(void)getCurrentLocationOnMap:(MKMapView *)map
{
    //map.userLocation is an annotation representing the user's location
    MKUserLocation *userLocation = map.userLocation;
    //set the location to our property in .h
    _currentLocation = userLocation;
    //NSLog(@")
    if (!(userLocation == nil))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Zoom to map" object:nil];
    }
    
    
}





-(void)retrieveWhoUserIsFollowingFromIG
{
    //This line of code simply gets a pointer to our appDelegate
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //Based on the instagram iOS SDK, check the Instagram API console for how to format requests
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"100", @"count", nil];

    
    [appDelegate.instagram requestWithMethodName:@"users/self/follows" params:params httpMethod:@"GET" delegate:self];
}

//Based on the IGRequestDelegate (also from iOS SDK)

//If the request loads, set the result to a cast of NSMutableArray* and set it to the proper array.
//You guys will have to change the code to determine which array to place the data in.
//Be careful as to WHAT method is calling the request delegate (parsing info from any of these methods will call request)
- (void)request:(IGRequest *)request didLoad:(id)result {
    //NSLog(@"Instagram did load: %@", result);
    if (self.following == nil)
        self.following = [[NSMutableArray alloc] init];
    [self.following addObjectsFromArray:(NSMutableArray*)[result objectForKey:@"data"]];
    if ([(NSMutableArray*)[result objectForKey:@"pagination"] count] > 1)
    {
        NSString* cursor = [result valueForKeyPath:@"pagination.next_cursor"];
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"100", @"count", cursor, @"cursor", nil];
        [appDelegate.instagram requestWithMethodName:@"users/self/follows" params:params httpMethod:@"GET" delegate:self];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CanParseFollowing" object:self];
    }
}

//If the request failed, we should tell the user.
- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}



-(void)retrieveFollowersFromIG __deprecated
{
    
    //This line of code simply gets a pointer to our appDelegate
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //Based on the instagram iOS SDK, check the Instagram API console for how to format requests
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/followed-by", @"method", nil];
    //tell the property "Instagram" (also part of instagram iOS SDK) the message.. requestWithParams
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
}



@end

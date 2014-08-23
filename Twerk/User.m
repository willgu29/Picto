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
}



-(void)retrieveFollowersFromIG
{
    
    //This line of code simply gets a pointer to our appDelegate
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //Based on the instagram iOS SDK, check the Instagram API console for how to format requests
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/followed-by", @"method", nil];
    //tell the property "Instagram" (also part of instagram iOS SDK) the message.. requestWithParams
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
}

-(void)retrieveWhoUserIsFollowingFromIG
{
    //This line of code simply gets a pointer to our appDelegate
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //Based on the instagram iOS SDK, check the Instagram API console for how to format requests
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/follows", @"method", nil];
    //tell the property "Instagram" (also part of instagram iOS SDK) the message.. requestWithParams
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
}

//Based on the IGRequestDelegate (also from iOS SDK)

//If the request loads, set the result to a cast of NSMutableArray* and set it to the proper array.
//You guys will have to change the code to determine which array to place the data in.
- (void)request:(IGRequest *)request didLoad:(id)result {
    NSLog(@"Instagram did load: %@", result);
    self.following = (NSMutableArray*)[result objectForKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CanParseFollowing" object:self];
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





@end

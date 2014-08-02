//
//  WGMap.m
//  Picto
//
//  Created by William Gu on 7/15/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "WGMap.h"
#import "AppDelegate.h"

static const int ONE_DAY_IN_SECONDS = 86400;

@implementation WGMap



-(void) getCurrentLocationOfMap
{
    //A CLLocationCoordinate2D is made of a latitude and longitude. Every map knows where its centerCoordinate is (where it's currently viewing)
    _currentLocation = self.centerCoordinate;
}

-(CLLocationCoordinate2D) getTopCenterCoordinate
{
    CLLocationCoordinate2D topCenter = [self convertPoint:CGPointMake(self.frame.size.width/2.0f, 0) toCoordinateFromView:self];
    return topCenter;
}

- (void)getRadius
{
    [self getCurrentLocationOfMap];
    // init center location from center coordinate
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:_currentLocation.latitude longitude:_currentLocation.longitude];
    
    CLLocationCoordinate2D topCenterCoor = [self getTopCenterCoordinate];
    CLLocation *topCenterLocation = [[CLLocation alloc] initWithLatitude:topCenterCoor.latitude longitude:topCenterCoor.longitude];
    
    CLLocationDistance radius = [centerLocation distanceFromLocation:topCenterLocation];
    
    _radius = radius;
}

//For finding pictures in the currently show region. We'll have to determine the latitude and longitude (easy since of previous method) but also how many meters the view is currently representing.  (There is probably a method for this too) (Actually there is... but I'm on a plane so I can't search for it.)
//This method only finds pictures posted within 24 hours, searching friends/locations should display pictures regardless of time.
-(void)findAllImagesOnMapInRange:(NSInteger)rangeInMeters inLatitude:(CLLocationDistance)latitude andLongitude:(CLLocationDistance)longitude
{
    
    //Since we'll need to limit our search to only 24 hours, we'll need CFTimeIntervals... these return the times in seconds.  You'll have to format this over to UNIX.
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval yesterday = now - 86400; //Should be yesterday... check this
    
    
    
    
   
    NSLog(@"%f %f",latitude, longitude);
    
    //Ignore this exampleish code
    //NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"media/search?lat=33&lng=-117&distance=20", @"method", nil];
    
    //Creating a NSMutableDictionary, change the 1st @".." to the method you want to call from the instagram API. (Check instagram API console for more formatting)
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/search?lat=%f&lng=%f&distance=%ld",latitude, longitude,(long)rangeInMeters], @"method", nil];
    
    //just creates a pointer to our app delegate. Nothing else to understand in this code
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //send the instagram property in our appdelehate.h this message "reqeustWithParams: delegate" (based on the instagram iOS SDK
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
}

-(void)findPopularImagesOnMapInRange:(NSInteger)rangeInMeters inLatitude:(CLLocationDistance)latitude andLongitude:(CLLocationDistance)longitude; //determine possible pictures in a region and put in an array
{
    
}

//Same as User.m IGRequestDelegate
- (void)request:(IGRequest *)request didLoad:(id)result {
    NSLog(@"Instagram did load: %@", result);
    self.possiblePics = (NSMutableArray*)[result objectForKey:@"data"]; //Notice this is an NSMutableArray
    NSLog(@"%lu",(unsigned long)[self.possiblePics count]);
    //Let everyone know that you've gotten the images loaded
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Images Loaded" object:self];
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

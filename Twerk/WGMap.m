//
//  WGMap.m
//  Picto
//
//  Created by William Gu on 7/15/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "WGMap.h"
#import "AppDelegate.h"

@implementation WGMap

static const int SECONDS_IN_A_DAY = 86400;


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
    //    CLLocationCoordinate2D centerPoint = _mapView.currentLocation;
    //    CLLocationCoordinate2D topPoint = [_mapView getTopCenterCoordinate];
    MKMapPoint centerPoint = MKMapPointForCoordinate([self currentLocation]);
    MKMapPoint topPoint = MKMapPointForCoordinate([self getTopCenterCoordinate]);
    
    
    
    double dist = MKMetersBetweenMapPoints(topPoint, centerPoint);
    
    _radius = dist * 1.6;
}

//For finding pictures in the currently show region. We'll have to determine the latitude and longitude (easy since of previous method) but also how many meters the view is currently representing.  (There is probably a method for this too) (Actually there is... but I'm on a plane so I can't search for it.)
//This method only finds pictures posted within 24 hours, searching friends/locations should display pictures regardless of time.
-(void)findAllImagesOnMapInRange:(NSInteger)rangeInMeters inLatitude:(CLLocationDistance)latitude andLongitude:(CLLocationDistance)longitude
{
    
    NSLog(@"%f %f",latitude, longitude);
    
    //Ignore this exampleish code
    //NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"media/search?lat=33&lng=-117&distance=20", @"method", nil];
    
    //Creating a NSMutableDictionary, change the 1st @".." to the method you want to call from the instagram API. (Check instagram API console for more formatting)
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/search?lat=%f&lng=%f&distance=%ld",latitude, longitude,(long)rangeInMeters], @"method", nil];
    if (rangeInMeters > 5000)
        NSLog(@"Radius %ld is greater than 5000!", (long)rangeInMeters);
    
    //just creates a pointer to our app delegate. Nothing else to understand in this code
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //send the instagram property in our appdelehate.h this message "reqeustWithParams: delegate" (based on the instagram iOS SDK
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
    
}

//Recent is defined as within a day
-(void)findRecentImagesOnMapInRange:(NSInteger)rangeInMeters inLatitude:(CLLocationDistance) latitude andLongitude:(CLLocationDistance) longitude
{
    
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t yesterdayInUnix = todayInUnix - SECONDS_IN_A_DAY;
    
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/search?lat=%f&lng=%f&max_timestamp=%ld&min_timestamp=%ld&distance=%ld",latitude, longitude,todayInUnix, yesterdayInUnix, (long)rangeInMeters], @"method", nil];
    if (rangeInMeters > 5000)
        NSLog(@"Radius %ld is greater than 5000!", (long)rangeInMeters);
    
    //just creates a pointer to our app delegate. Nothing else to understand in this code
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //send the instagram property in our appdelehate.h this message "reqeustWithParams: delegate" (based on the instagram iOS SDK
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
}



//Same as User.m IGRequestDelegate
- (void)request:(IGRequest *)request didLoad:(id)result {
    //NSLog(@"Instagram did load: %@", result);
    self.possiblePics = (NSMutableSet*)[result objectForKey:@"data"];

   // [[NSNotificationCenter defaultCenter] postNotificationName:@"Load Geo" object:self];
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

// ???: This will remove MKUserLocation and MKPointAnnotations as well?
- (void)cleanupMap {
    NSLog(@"Cleaning up the map!");
    NSSet* visible = [self annotationsInMapRect:[self visibleMapRect]];
    NSArray* all = [self annotations];
    NSMutableArray* discard = [NSMutableArray array];
    for (id<MKAnnotation> cur in all)
    {
        if (![visible containsObject:cur])
            [discard addObject:cur];
    }
    [self removeAnnotations:discard];
    
}



@end

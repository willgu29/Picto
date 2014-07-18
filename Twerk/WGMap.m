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

-(CLLocationCoordinate2D) getCurrentLocationOfMap
{
    CLLocationCoordinate2D location = self.centerCoordinate;
    
    
    return location;
}

-(void)findAllImagesOnMapInRange:(NSInteger)rangeInMeters inLatitude:(CLLocationDistance)latitude andLongitude:(CLLocationDistance)longitude
{
    
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval yesterday = now - 86400;
    
    //just creates a pointer to our app delegate. Nothing else to understand in this code
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    //This is how the SDK wants it, so give it this way. Creating an NSMutableDictionary, simply change the 1st @"..." to the method you want to call (Go to instagram API console for how to format)
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"media/search?lat=33.0734296&lng=-117.0934542&distance=10", @"method", nil];
    
    //send the instagram property in our appdelehate.h this message "reqeustWithParams: delegate" (based on the instagram iOS SDK
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    NSLog(@"Instagram did load: %@", result);
    self.possiblePics = (NSMutableArray*)[result objectForKey:@"data"];
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

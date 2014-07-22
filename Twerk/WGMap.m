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
    //A CLLocationCoordinate2D is made of a latitude and longitude. Every map knows where its centerCoordinate is (where it's currently viewing)
    CLLocationCoordinate2D location = self.centerCoordinate;
    return location;
}


//For finding pictures in the currently show region. We'll have to determine the latitude and longitude (easy since of previous method) but also how many meters the view is currently representing.  (There is probably a method for this too) (Actually there is... but I'm on a plane so I can't search for it.)
//This method only finds pictures posted within 24 hours, searching friends/locations should display pictures regardless of time.
-(void)findAllImagesOnMapInRange:(NSInteger)rangeInMeters inLatitude:(CLLocationDistance)latitude andLongitude:(CLLocationDistance)longitude
{
    
    //Since we'll need to limit our search to only 24 hours, we'll need CFTimeIntervals... these return the times in seconds.  You'll have to format this over to UNIX.
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval yesterday = now - 86400; //Should be yesterday... check this
    
    
    //just creates a pointer to our app delegate. Nothing else to understand in this code
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
   
    NSLog(@"%f %f",latitude, longitude);
    
    //Ignore this exampleish code
    //NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"media/search?lat=33&lng=-117&distance=20", @"method", nil];
    
    //Creating a NSMutableDictionary, change the 1st @".." to the method you want to call from the instagram API. (Check instagram API console for more formatting)
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/search?lat=%f&lng=%f&distance=%ld",latitude, longitude,(long)rangeInMeters], @"method", nil];
    
    //send the instagram property in our appdelehate.h this message "reqeustWithParams: delegate" (based on the instagram iOS SDK
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
}

//Same as User.m IGRequestDelegate
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

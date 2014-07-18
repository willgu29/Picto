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
    //DO SOMETHING
    //TODO: NOT WORKING  (params format is not corect..)
    
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval yesterday = now - 86400;
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"media/search", @"method", [NSString stringWithFormat:@"%f",latitude],[NSString stringWithFormat:@"%f",longitude] ,nil,nil, nil];
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

//
//  User.m
//  Picto
//
//  Created by William Gu on 7/13/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "User.h"
#import "MapViewController.h"

@implementation User



//get user location and set it to currentLocation
-(MKUserLocation *)getCurrentLocationOnMap:(MKMapView *)map
{
    MKUserLocation *userLocation = map.userLocation;
    _currentLocation = userLocation;
    return _currentLocation;
}




@end

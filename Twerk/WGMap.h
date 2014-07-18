//
//  WGMap.h
//  Picto
//
//  Created by William Gu on 7/15/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "IGRequest.h"
@class Friend;

@interface WGMap : MKMapView <IGRequestDelegate>


@property (strong, nonatomic) NSMutableArray *possiblePics;


-(void)findAllImagesOnMapInRange:(NSInteger)rangeInMeters inLatitude:(CLLocationDistance)latitude andLongitude:(CLLocationDistance)longitude; //determine possible pictures in a region and put in an array



-(CLLocationCoordinate2D)getCurrentLocationOfMap;

-(CLLocationCoordinate2D)determineBestPhotoLocationOfFriend:(Friend *)someFriend;

-(MKCoordinateRegion)getBestRegionForFriend:(Friend *)someFriend;
-(MKCoordinateRegion)findNextInterestingLocation;


@end

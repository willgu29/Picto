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
#import "Friend.h"

@interface WGMap : NSObject


@property (strong, nonatomic) NSMutableArray *possiblePics;


-(NSMutableArray *) getAllImagesOnMap:(MKMapView *)map inRegion:(CLLocationCoordinate2D) region inLatitude:(CLLocationDistance)latitude andLongitude:(CLLocationDistance)longitude; //determine possible pictures in a region and put in an array
-(CLLocationCoordinate2D)getCurrentLocationOfMap:(MKMapView *)map;
-(CLLocationCoordinate2D)determineBestPhotoLocationOfFriend:(Friend *)someFriend;
-(MKCoordinateRegion)getBestRegionForFriend:(Friend *)someFriend;

-(MKCoordinateRegion)findNextInterestingLocation;


@end

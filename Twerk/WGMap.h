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


//Data Array that stores ALL REQUESTS
@property (strong, nonatomic) NSMutableSet *possiblePics; //in data form



//Data loading methods
-(void)findAllImagesOnMapInRange:(NSInteger)rangeInMeters inLatitude:(CLLocationDistance)latitude andLongitude:(CLLocationDistance)longitude; //determine possible pictures in a region and put in an array
-(void)findRecentImagesOnMapInRange:(NSInteger)rangeInMeters inLatitude:(CLLocationDistance) latitude andLongitude:(CLLocationDistance) longitude;
-(void)findPopularImages;


//Map Centered At Coordinate
@property (nonatomic) CLLocationCoordinate2D currentLocation; //where we are centered at
-(void)getCurrentLocationOfMap; //(Where we are centered) (stores in currentLocation)



//Map Radius (mid to top screen point)
@property (nonatomic) CLLocationDistance radius; //the radius of the current mapview
-(void)getRadius;


//Other Methods
-(CLLocationCoordinate2D)getTopCenterCoordinate;
-(void)cleanupMap;



//Not used
@property (strong, nonatomic) NSMutableArray *actualPics __deprecated;

@end


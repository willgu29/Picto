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
//TODO: WGMap is a subclass of MKMapView so it can do everything a MKMapView can. Make sure not to repeat functions. Check the apple documentation of MKMapView.  WGMap will need custom methods that allow navigating of the map and locations/coordinates.

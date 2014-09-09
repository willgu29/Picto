//
//  LocationDisplay.h
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "BaseDisplay.h"
#import <MapKit/MapKit.h>

@interface LocationDisplay : BaseDisplay

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSURL *url;
@property (strong, nonatomic) MKPlacemark *placemark;

-(instancetype)initWithName:(NSString *)name andCoordinate:(CLLocationCoordinate2D)coordinate andURL:(NSURL *)url andPlacemark:(MKPlacemark *)placemark;

@end

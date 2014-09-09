//
//  LocationDisplay.m
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "LocationDisplay.h"

@implementation LocationDisplay

-(instancetype)initWithName:(NSString *)name andCoordinate:(CLLocationCoordinate2D)coordinate andURL:(NSURL *)url andPlacemark:(MKPlacemark *)placemark
{
    self = [super initWithName:name];
    if (self)
    {
        _coordinate = coordinate;
        _url = url;
        _placemark = placemark;
    }
    
    return self;
}

@end

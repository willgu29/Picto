//
//  CustomAnnotation.m
//  Picto
//
//  Created by William Gu on 7/24/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

-(instancetype)initWithPhoto:(WGPhoto *)photo
{
    _imageURLEnlarged = photo.photoURLEnlarged;
    _coordinate = photo.locationOfPicture;
    _imageURL = photo.photoURL;
    _title = @"Whatever the dick photo says"; //change this to whatever the picture should say
    
    return self;
}


@end

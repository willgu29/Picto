//
//  WGPhoto.h
//  Picto
//
//  Created by William Gu on 7/15/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGPhoto : NSObject

@property (strong, nonatomic) UIImage *photo;
@property (nonatomic) MKCoordinateRegion locationOfPicture;
@property (nonatomic) BOOL didLoad;

-(void)retrievePhotoFromFacebook;
-(void)retrievePhotoFromDatabase;

@end

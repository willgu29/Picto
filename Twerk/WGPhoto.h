//
//  WGPhoto.h
//  Picto
//
//  Created by William Gu on 7/15/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "IGConnect.h"
#import "IGRequest.h"

@interface WGPhoto : NSObject

@property (strong, nonatomic) UIImage *photo;
@property (nonatomic) MKCoordinateRegion locationOfPicture;
@property (nonatomic) BOOL didLoad;
@property (nonatomic) BOOL userDidNotChooseLocation; //We don't want users to CHOOSE their own location... this would defeat the purpose of the app. To keep the data accuracy high, users must check Add picture to map AND not specify their own location.  The problem is we may not be able to do this as they'll need to take pictures in native IG. Alt solution: we keep our own location data independent of IG.



-(void)retrievePhotoFromIG;
-(void)retrievePhotoFromDatabase;

@end

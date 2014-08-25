//
//  CustomAnnotation.h
//  Picto
//
//  Created by William Gu on 7/24/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WGPhoto.h"

//This class manages the DATA pertaining to an annotation.

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite) BOOL userHasLiked;
@property (nonatomic, readonly) NSString *mediaID;
@property (nonatomic, readonly) NSString *imageURL;
@property (nonatomic, readonly) NSString *imageURLEnlarged;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readwrite) UIColor* colorType;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) UIImage *imageEnlarged;
@property (nonatomic, readonly) NSString *ownerOfPhoto;
@property (nonatomic, readonly) NSString *locationOfPhoto;
@property (nonatomic, readonly) NSString *numberOfLikes;
@property (nonatomic, readonly) NSString *timeCreated;
//@property (nonatomic, readonly) type video??

-(instancetype)initWithPhoto:(WGPhoto *)photo;
//-(instancetype)initWithVideo:(WGVideo *)video;
-(void)createNewImage;
-(UIImage *)makeImagePretty:(UIImage *)image;

@end

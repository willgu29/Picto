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

@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, readwrite) NSString *locationString;
@property (nonatomic, readwrite) BOOL isPopular;
@property (nonatomic, readwrite) BOOL userHasLiked;
@property (nonatomic, readwrite) BOOL userHasFollowed;
@property (nonatomic, readonly) NSString *mediaID;
@property (nonatomic, readonly) NSString *imageURL;
@property (nonatomic, readonly) NSString *imageURLEnlarged;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readwrite) UIColor* colorType;
@property (nonatomic, readonly) UIImage *image;
@property (atomic, readwrite) UIImage *imageEnlarged; // atomic because it is being preloaded; we don't want a conflict
@property (nonatomic, readonly) NSString *ownerOfPhoto;
@property (nonatomic, readwrite) NSString *numberOfLikes;
@property (nonatomic, readonly) NSString *timeCreated;
//@property (nonatomic, readonly) type video??

-(instancetype)initWithPhoto:(WGPhoto *)photo;
//-(instancetype)initWithVideo:(WGVideo *)video;
-(void)createNewImage;
-(void)parseStringOfLocation:(CLLocationCoordinate2D) location;
-(BOOL)isEqualToAnnotation:(CustomAnnotation *)annotation;


-(UIImage *)makeImagePretty:(UIImage *)image;

@end

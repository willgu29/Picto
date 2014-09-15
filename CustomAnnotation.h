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

//This class manages the DATA pertaining to an annotation (CustomCallout and MKAnnotationView).

@interface CustomAnnotation : NSObject <MKAnnotation>


//User IDs
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *userID;

//Image URLs
@property (nonatomic, readonly) NSString *imageURL;
@property (nonatomic, readonly) NSString *imageURLEnlarged;

//Image
@property (nonatomic, readonly) UIImage *image;
@property (atomic, readwrite) UIImage *imageEnlarged; // atomic because it is being preloaded; we don't want a conflict


//Bool values
@property (nonatomic, readwrite) BOOL isPopular;
@property (nonatomic, readwrite) BOOL isFriend;
@property (nonatomic, readwrite) BOOL isHashTag;
@property (nonatomic, readwrite) BOOL userHasLiked;
@property (nonatomic, readwrite) BOOL userHasFollowed;
@property (nonatomic, readwrite) BOOL shouldDisplayNow;

//Media ID
@property (nonatomic, readonly) NSString *mediaID;


//UILabel Data (for CustomCallout)
@property (nonatomic, readonly) NSString *ownerOfPhoto;
@property (nonatomic, readwrite) NSString *numberOfLikes;
@property (nonatomic, readonly) NSString *timeCreated;
@property (nonatomic, readwrite) NSString *locationString;
@property (nonatomic, readwrite) NSString *numberOfComments;


//Comment data (i.e. who's commented, the text, etc.)
@property (nonatomic, readonly) NSSet *commentsData; //may be incorrect type... (NSDictionary? Array?)

//MKAnnotation Protocol
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *title;


//Sets border color
@property (nonatomic, readwrite) UIColor* colorType;



//Methods
-(instancetype)initWithPictureData:(id)pictureURL;

-(instancetype)initWithLocation:(CLLocationCoordinate2D)location andImageURL:(NSString *)image andEnlarged:(NSString *)imageURLEnlarged andOwner:(NSString *)owner andLikes:(NSString *)likes andTime:(NSString *)createdTime andMediaID:(NSString *)mediaID andUserLiked:(NSString *)userHasLiked andUserID:(NSString *)userID andUsername:(NSString *)username __deprecated_msg("Use initWIthPictureData Instead");

-(void)parseStringOfLocation:(CLLocationCoordinate2D) location; //Use only with popular photos, not normal ones

//-(instancetype)initWithVideo:(WGVideo *)video;

-(void)createNewImage;
-(BOOL)isEqualToAnnotation:(CustomAnnotation *)annotation;


@end

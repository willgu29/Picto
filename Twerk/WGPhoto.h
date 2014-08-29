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

__deprecated_msg("We're going to use just CustomAnnotation for now as it performs the exact same data as WGPhoto")
//We will expect all photos to have the actual UIImage and location at a minimum. Later on we can add other features to a photo like "type" (friend, location, popular, likes) etc. Feel free to work on this as you want.  A photo should probably have a "show rating" -> the higher the show rating the more "cool" a photo is and the more likely we'll want to show it to the user. (Keep in mind we can store some small specific data about how the user uses the app so we can customize our algorithm for determining "show rating" a little better.) (Things like... how often they use the app perhaps, avg stay, w/e, just ask me with any ideas and i'll tell you if we could store it on the iOS device itself or maybe store it in a server)
@interface WGPhoto : NSObject <MKAnnotation>

//User Ids
@property (nonatomic, weak) NSString *userID;
@property (nonatomic, weak) NSString *username;


//"Boolean" values
@property (nonatomic, weak) NSString *userHasLiked;


//Media ID
@property (nonatomic, weak) NSString *mediaID;

//UILabel Data
@property (nonatomic, weak) NSString *timeCreated;
@property (nonatomic) NSString *locationText;
@property (nonatomic) NSString *likes;
@property (nonatomic) NSString *ownerOfPhoto;


//Image URLs
@property (weak, nonatomic) NSString *photoURL;
@property (weak, nonatomic) NSString *photoURLEnlarged;



//Coordinate
@property (nonatomic) CLLocationCoordinate2D locationOfPicture;//MKCoordinateRegion locationOfPicture;




@property (nonatomic) BOOL userDidView __deprecated;
@property (nonatomic) BOOL didLoad __deprecated;





-(instancetype)initWithLocation:(CLLocationCoordinate2D)location andImageURL:(NSString *)image andEnlarged:(NSString *)imageURLEnlarged andOwner:(NSString *)owner andLikes:(NSString *)likes andTime:(NSString *)createdTime andMediaID:(NSString *)mediaID andUserLiked:(NSString *)userHasLiked andUserID:(NSString *)userID andUsername:(NSString *)username;


//-(void)retrievePhotoFromIG;
//-(void)retrievePhotoFromDatabase;

@end

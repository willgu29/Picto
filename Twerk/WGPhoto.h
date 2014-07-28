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


//We will expect all photos to have the actual UIImage and location at a minimum. Later on we can add other features to a photo like "type" (friend, location, popular, likes) etc. Feel free to work on this as you want.  A photo should probably have a "show rating" -> the higher the show rating the more "cool" a photo is and the more likely we'll want to show it to the user. (Keep in mind we can store some small specific data about how the user uses the app so we can customize our algorithm for determining "show rating" a little better.) (Things like... how often they use the app perhaps, avg stay, w/e, just ask me with any ideas and i'll tell you if we could store it on the iOS device itself or maybe store it in a server)
@interface WGPhoto : NSObject <MKAnnotation>

@property (weak, nonatomic) NSString *photoURL;
@property (weak, nonatomic) NSString *photoURLEnlarged;
@property (nonatomic) CLLocationCoordinate2D locationOfPicture;//MKCoordinateRegion locationOfPicture;
@property (nonatomic) NSString *ownerOfPhoto;
@property (nonatomic) NSString *locationText;
@property (nonatomic) BOOL userDidView;
@property (nonatomic) BOOL didLoad;
@property (nonatomic) BOOL userDidNotChooseLocation; //We don't want users to CHOOSE their own location... this would defeat the purpose of the app. To keep the data accuracy high, users must check Add picture to map AND not specify their own location.  The problem is we may not be able to do this as they'll need to take pictures in native IG. Alt solution: we keep our own location data independent of IG.

-(instancetype)initWithLocation:(CLLocationCoordinate2D)location andImageURL:(NSString *)image andEnlarged:(NSString *)imageURLEnlarged;

-(void)retrievePhotoFromIG;
-(void)retrievePhotoFromDatabase;

@end
//NOTE: we may need methods here on posting the picture to instagram, I'll see how the data flow is later.

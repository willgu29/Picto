//
//  CustomAnnotation.m
//  Picto
//
//  Created by William Gu on 7/24/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CustomAnnotation.h"
#import <QuartzCore/QuartzCore.h>
//#import <CoreGraphics/CoreGraphics.h>
//#import <CoreImage/CoreImage.h>


@implementation CustomAnnotation

-(instancetype)initWithPictureData:(id)pictureURL
{
    self = [super init];
    if (self)
    {
        _imageURL = [pictureURL valueForKeyPath:@"images.thumbnail.url"];
        _imageURLEnlarged = [pictureURL valueForKeyPath:@"images.standard_resolution.url"];
        
        NSString *lat1 = [pictureURL valueForKeyPath:@"location.latitude"];
        NSString *lng1 = [pictureURL valueForKeyPath:@"location.longitude"];
        //Convert to CLLocationDegrees (which is a double)
        CLLocationDegrees lat = [lat1 doubleValue];
        CLLocationDegrees lng = [lng1 doubleValue];
        //CONVERT from CLLocationDegrees TO CLLocationCoordinate2D
        _coordinate = CLLocationCoordinate2DMake(lat, lng);
        _profilePicURL = [pictureURL valueForKeyPath:@"user.profile_picture"];
        _ownerOfPhoto = [pictureURL valueForKeyPath:@"user.full_name"];
        _userID = [pictureURL valueForKeyPath:@"user.id"];
        _numberOfLikes = [pictureURL valueForKeyPath:@"likes.count"];
        _username = [pictureURL valueForKeyPath:@"user.username"];
        
        _timeCreated = [pictureURL valueForKeyPath:@"created_time"];
        _mediaID = [pictureURL valueForKeyPath:@"id"];
        NSString *userHasLiked = [pictureURL valueForKey:@"user_has_liked"];
        _userHasLiked = userHasLiked.boolValue;
        _commentsData = [pictureURL valueForKeyPath:@"comments"];
        _numberOfComments = [pictureURL valueForKeyPath:@"comments.count"];
        _captionData = [pictureURL valueForKeyPath:@"caption"];
    
    }
    return self;
}




-(void)createNewImage
{
    //create a data object with the URL string.
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[self imageURL]]];
    //create the image and assign it to the annotationView
    UIImage *theImage = [[UIImage alloc] initWithData:data scale:3.0];
    //make image annotation look pretty
    
    _image = theImage;
}




-(void)parseStringOfLocation:(CLLocationCoordinate2D) location
{
    CLLocation *coordinate = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:coordinate completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!error)
         {
             //DO SOMETHING HERE
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"Current Location Detected");
            // NSLog(@"placemark %@", placemark);
//            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            // NSString *address = [[NSString alloc] initWithString:locatedAt];
             //NSString *area = [[NSString alloc]initWithString:placemark.locality];
             //NSString *country = [[NSString alloc] initWithString:placemark.country];
             //NSLog(@"%@, %@, %@", address, area, country);
             
             
             if (placemark.locality == nil)
             {
                 [self setLocationString:[NSString stringWithFormat:@"%@, %@", placemark.administrativeArea, placemark.country]];
             }
             else
             {
                 [self setLocationString:[NSString stringWithFormat:@"%@, %@",placemark.locality, placemark.administrativeArea]];
             }
             
             
             NSLog(@"LOCATION: %@",_locationString);
             
         }
         else
         {
             //HANDLE ERROR
             NSLog(@"Geocode failed with error %@", error);
         }
     }];
    
    
}


-(BOOL)isEqualToAnnotation:(CustomAnnotation *)annotation
{
    if (self == annotation)
    {
        return true;
    }
    if ([self.mediaID isEqualToString:annotation.mediaID])
    {
        return true;
    }
    else
    {
        return false;
    }
}


-(instancetype)initWithLocation:(CLLocationCoordinate2D)location andImageURL:(NSString *)imageURL andEnlarged:(NSString *)imageURLEnlarged andOwner:(NSString *)owner andLikes:(NSString *)likes andTime:(NSString *)createdTime andMediaID:(NSString *)mediaID andUserLiked:(NSString *)userHasLiked andUserID:(NSString *)userID andUsername:(NSString *)username
{
    self = [super init];
    
    if (self)
    {
        _imageURL = imageURL;
        _imageURLEnlarged = imageURLEnlarged;
        _coordinate = location;
        _numberOfLikes = likes;
        _ownerOfPhoto = owner;
        _timeCreated = createdTime;
        _mediaID = mediaID;
        _userHasLiked = userHasLiked.boolValue;
        _userID = userID;
        _username = username;
    }
    
    return self;
}




@end

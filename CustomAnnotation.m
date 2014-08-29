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

-(instancetype)initWithPhoto:(WGPhoto *)photo
{
    _imageURL = photo.photoURL;
    _imageURLEnlarged = photo.photoURLEnlarged;
    _image = nil;
    _imageEnlarged = nil;
    _coordinate = photo.locationOfPicture;
    _title = @"Whatever the dick photo says"; //change this to whatever the picture should say
    _ownerOfPhoto = photo.ownerOfPhoto;
    _numberOfLikes = photo.likes;
    _timeCreated = photo.timeCreated;
    _mediaID = photo.mediaID;
    _colorType = nil;
    _userHasLiked = photo.userHasLiked.boolValue;
    _userID = photo.userID;
    _username = photo.username;
    return self;
}

//-(instancetype)initWithVideo:(WGVideo *)video
//{
//    return self;
//}

-(void)createNewImage
{
    //create a data object with the URL string.
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[self imageURL]]];
    //create the image and assign it to the annotationView
    UIImage *theImage = [[UIImage alloc] initWithData:data scale:3.0];
    //make image annotation look pretty
    //theImage = [self makeImagePretty:theImage]; //NOT BEING USED AS NOTHING IS THERE
    
    _image = theImage;
}

//Unfortunately this process takes a while...

//TODO: We'll need to find a better way to do this. Currently we're geoCoding every photo but that's probably not necessary as we can assume that pictures in the same general location will have the same geoData... so don't need to refetch data.
//BTW: The docs say "you should not send more than one geocoding request per minute". So we'll start getting errors after a bit too...


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




-(UIImage *)makeImagePretty:(UIImage *)image
{
    //do some cool shit
    //https://developer.apple.com/library/ios/documentation/uikit/reference/UIImage_Class/Reference/Reference.html
    
    /* NOT WORKING
    
    UIImage *mask = [[UIImage alloc] init];
    mask = [UIImage imageNamed:@"Oval 30.png"];
    
    
    CGImageRef imageReference= mask.CGImage;
    CGImageRef maskReference = image.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference), CGImageGetHeight(maskReference), CGImageGetBitsPerComponent(maskReference), CGImageGetBitsPerPixel(maskReference), CGImageGetBytesPerRow(maskReference), CGImageGetDataProvider(maskReference), NULL, YES);
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference,imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [[UIImage alloc] init];
    maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    
    return maskedImage;
     */
    
    
    
    return image;
}



@end

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
    theImage = [self makeImagePretty:theImage];
    
    _image = theImage;
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

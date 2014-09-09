//
//  Friend.h
//  Picto
//
//  Created by William Gu on 7/7/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

//We may add this later as part of our model
__deprecated_msg("We can use this for moments feature later")
@interface Friend : NSObject;


@property (strong, nonatomic) NSMutableArray *topPictures;


//-(void)loadTopPicturesToArray:(NSMutableArray *)topPictures; //get data from facebook


@end
//NOTE: friend is now referencing a person YOU are following
//TODO: If a person SEARCHES a specific friend, this class should be able to get an array of 50-100 pictureURLs from that friend (or as many pictures as they have) and sort the array in descending order of "show ratibg" (Thus the worst pictures of a person will be last in the array)


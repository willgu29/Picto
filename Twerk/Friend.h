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



@interface Friend : NSObject


@property (strong, nonatomic) NSMutableArray *topPictures;


-(void)loadTopPicturesToArray:(NSMutableArray *)topPictures; //get data from facebook


@end

//TODO: Pull data from facebook
//Methods we'll need include things like... find a specific friend, get specific pictures from a friend, etc.

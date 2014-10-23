//
//  AppDelegate.h
//  Twerk
//
//  Created by William Gu on 4/12/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
 #import "IGConnect.h"
#import "IGRequest.h"
#import "MapViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Instagram *instagram;
@property (strong, nonatomic) MapViewController *mapVC;



@end

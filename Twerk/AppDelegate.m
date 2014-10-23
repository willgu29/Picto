//
//  AppDelegate.m
//  Twerk
//
//  Created by William Gu on 4/12/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "AppDelegate.h"
#import "CameraAppViewController.h"
#import "LoginViewController.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>

#define APP_ID @"3a32660f59734e20ac6c590aecaa1e99"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.instagram = [[Instagram alloc] initWithClientId:APP_ID
                                                delegate:nil];
    
    
    //if logged in go straight to map, otherwise go to login.
    self.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    if ([self.instagram isSessionValid])
    {
        _mapVC = [[MapViewController alloc] init];
        self.window.rootViewController = _mapVC;
    }
    else
    {
        LoginViewController* loginRoot = [[LoginViewController alloc] init];
        self.window.rootViewController = loginRoot;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    
   
//    application.applicationSupportsShakeToEdit = YES; //???: Shake to refresh map?
//    [CLLocationManager authorizationStatus];
//    [CLLocationManager locationServicesEnabled];
//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    [locationManager requestAlwaysAuthorization];

    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.instagram handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.instagram handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}


@end

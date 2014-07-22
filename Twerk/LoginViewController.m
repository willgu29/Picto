//
//  LoginViewController.m
//  Twerk
//
//  Created by William Gu on 6/16/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "LoginViewController.h"
#import "MapViewController.h"
#import "AppDelegate.h"


@interface LoginViewController ()


@end

@implementation LoginViewController

//Will go to map view
-(IBAction)goMainVC:(UIButton *)sender
{
    //create controller CameraController
    MapViewController *mainController = [[MapViewController alloc] init];
    //present this view controller
    [self presentViewController:mainController animated:YES completion:nil];
}


//This is a button on the xib (Login)
-(IBAction)loginToInsta:(UIButton *)sender
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //tell instagram what information we need from the user and have them authorize it
    [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
}

//This is a button on the xib (Logout)
-(IBAction)logOutInsta:(UIButton *)sender
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //logout of instagram (the instagram iOS SDK handles this)
    [appDelegate.instagram logout];
    
}






- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //Look for the accessToken...
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    
    //assign delegate to self (IGSessionDelegate)
    appDelegate.instagram.sessionDelegate = self;
    
    //Later on we'll need to let users sign out of the app... the only problem is we're presenting the view controller modally right now and that only allows you to go "1 layer deep" or so I think... i.e. The presenting vc has to dismiss the presented vc.  If we have a logout in the settings page or something we'll have to somehow dismiss the presented vc controllers twice (one for the settings page and one for the map view main)...
        //TLDR:  We need to switch over to a navigation view controller container. (I think) We'll do this later.
    /*
    if ([appDelegate.instagram isSessionValid])
    {
        MapViewController* mapVC = [[MapViewController alloc] init];
        [self presentViewController:mapVC animated:YES completion:nil];
    }
    */
    /*
    else {
        //[appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
          Authorization
         basic - to read any and all data related to a user (e.g. following/followed-by lists, photos, etc.) (granted by default)
         comments - to create or delete comments on a user’s behalf
         relationships - to follow and unfollow users on a user’s behalf
         likes - to like and unlike items on a user’s behalf
     
    }
    */

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IGSessionDelegate

//These are all IGSessionsDelegate methods

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //Storing the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
    //This line is needed to sync up or something like that... basically it is to make sure the data was actually saved.
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    //Make a mapVC
    MapViewController *mapVC = [[MapViewController alloc] init];
    //present it
    [self presentViewController:mapVC animated:YES completion:nil];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}


@end

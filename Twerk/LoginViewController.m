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
    //modal onto stack
    [self presentViewController:mainController animated:YES completion:nil];
}

-(IBAction)loginToInsta:(UIButton *)sender
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
}

-(IBAction)logOutInsta:(UIButton *)sender
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
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

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    MapViewController *mapVC = [[MapViewController alloc] init];
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

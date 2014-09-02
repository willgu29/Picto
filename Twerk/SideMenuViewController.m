//
//  SideMenuViewController.m
//  Picto
//
//  Created by William Gu on 7/7/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "SideMenuViewController.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SideMenuViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *heart1;
@property (nonatomic, weak) IBOutlet UIImageView *heart2;
@property (nonatomic, weak) IBOutlet UIImageView *heart3;

@end

@implementation SideMenuViewController

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [self displayProperButtonHighlights];
}

-(void)viewDidAppear:(BOOL)animated
{
    

}

-(void)displayProperButtonHighlights
{
    [self displayProperFollowing];
    [self displayProperAllRecent];
    
}

-(void)displayProperAllRecent
{
    if ([(MapViewController *)self.presentingViewController globalType] == ALL)
    {
        _heart1.hidden = NO;
        _heart2.hidden = YES;
    }
    else if ([(MapViewController *)self.presentingViewController globalType] == RECENT)
    {
        _heart1.hidden = YES;
        _heart2.hidden = NO;
    }
}

-(void)displayProperFollowing
{
    if ([(MapViewController *)self.presentingViewController onlyFriends] == YES)
    {
        _heart3.hidden = NO;
    }
    else
    {
        _heart3.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeAllPinsButUserLocation
{
    WGMap *myMap = [(MapViewController *)self.presentingViewController mapView];
    [myMap removeAnnotations:myMap.annotations];
    
    
   // id userLocation = [myMap userLocation];
 
    //if ( userLocation != nil ) {
        //[myMap addAnnotation:userLocation]; // will cause user location pin to blink
        //[myMap setShowsUserLocation:YES];
   // }
}

-(IBAction)presentAll:(id)sender
{
    [self removeAllPinsButUserLocation];
    [(MapViewController *)self.presentingViewController setGlobalType:ALL];
    [[NSUserDefaults standardUserDefaults] setInteger:ALL forKey:@"WGglobalType"];
    [self displayProperAllRecent];
     
}

-(IBAction)presentRecent:(id)sender
{
    [self removeAllPinsButUserLocation];
    [(MapViewController *)self.presentingViewController setGlobalType:RECENT];
    [[NSUserDefaults standardUserDefaults] setInteger:RECENT forKey:@"WGglobalType"];
    [self displayProperAllRecent];
}

-(IBAction)onlyFriends:(id)sender
{
    [self removeAllPinsButUserLocation];
    //Display only friends
    if ([(MapViewController *)self.presentingViewController onlyFriends] == YES)
    {
        [(MapViewController *)self.presentingViewController setOnlyFriends:NO];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WGonlyFriends"];

    }
    else
    {
        [(MapViewController *)self.presentingViewController setOnlyFriends:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WGonlyFriends"];
    }
    [self displayProperFollowing];
}


-(IBAction)backButton:(UIButton *) button
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)logoutButton:(UIButton *)sender
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram logout];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil]; //THIS IS INCORRECT, MAKE AN NAVIGATION CONTROLLER AND REVAMP THE WHOLE APP NAVIGATION.(OR  as long as we let go of views that we no longer use this is ok, but we don't currently...)
}

-(void)igDidLogin
{
    //We shouldn't need to do anything here.. No login should happen when we are logged in already
}

-(void)igDidLogout
{
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated
{
    // ???: We'll probably need to add this to our mapVC in case our session is invalidated there OR we can alloc init this VC so it can catch and handle this
    NSLog(@"Instagram session was invalidated");
}


@end

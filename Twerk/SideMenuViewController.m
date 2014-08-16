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

//TODO: show which is selected...
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
    [self displayProperButtonHighlights];
    
}

-(void)displayProperButtonHighlights
{
    
    if ([(MapViewController *)self.presentingViewController onlyFriends] == YES)
    {
        _heart3.hidden = NO;
    }
    else
    {
        _heart3.hidden = YES;
    }
    
    //TODO: do other buttons
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
    [(MapViewController *)self.presentingViewController setGlobalType:1];
     
}

-(IBAction)presentRecent:(id)sender
{
    [self removeAllPinsButUserLocation];
    [(MapViewController *)self.presentingViewController setGlobalType:2];
}

-(IBAction)onlyFriends:(id)sender
{
    //Display only friends
    if ([(MapViewController *)self.presentingViewController onlyFriends] == YES)
    {
        [(MapViewController *)self.presentingViewController setOnlyFriends:NO];
    }
    else
    {
        [(MapViewController *)self.presentingViewController setOnlyFriends:YES];
    }
    [self displayProperButtonHighlights];
}


-(IBAction)backButton:(UIButton *) button
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)logoutButton:(UIButton *)sender
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram logout];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil]; //THIS IS INCORRECT, MAKE AN NAVIGATION CONTROLLER AND REVAMP THE WHOLE APP NAVIGATION.(OR  as long as we let go of views that we no longer use this is ok, but we don't currently...)
}

@end

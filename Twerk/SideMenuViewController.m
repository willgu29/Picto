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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)presentAll:(id)sender
{
    [(MapViewController *)self.presentingViewController setGlobalType:1];
}

-(IBAction)presentRecent:(id)sender
{
    [(MapViewController *)self.presentingViewController setGlobalType:2];
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

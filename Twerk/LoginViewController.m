//
//  LoginViewController.m
//  Twerk
//
//  Created by William Gu on 6/16/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "LoginViewController.h"

#import "MapViewController.h"

@interface LoginViewController ()

-(void)toggleHiddenState:(BOOL)shouldHide;

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

//hides or shows username, email, and profilePicture
- (void)toggleHiddenState:(BOOL)shouldHide
{
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
}


//set profile pic, username, and email from FBGraphUser data
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"%@", user);
    self.profilePicture.profileID = user.objectID;
    self.lblUsername.text = user.name;
    self.lblEmail.text = [user objectForKey:@"email"];
}

//Hide profile pic, email, and username if logged out, show logged out message
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    self.lblLoginStatus.text = @"You are logged out.";
    [self toggleHiddenState:YES];
}

//
-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

//Show profile pic, email, and username if logged in, show logged in message
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    self.lblLoginStatus.text = @"You are logged in.";
    [self toggleHiddenState:NO];
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
    self.loginButton.delegate = self;
    [self toggleHiddenState:YES];
    self.lblLoginStatus.text = @"";
    
    //These are the permissions we request from a user using our app (these obviously will and can be changed) (there's many more -> google FB permissions) first link
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_hometown", @"user_tagged_places", @"user_work_history", @"user_interests", @"user_videos", @"user_photos", @"user_groups", @"user_likes", @"publish_actions"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

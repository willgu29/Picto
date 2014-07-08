//
//  LoginViewController.h
//  Twerk
//
//  Created by William Gu on 6/16/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>


@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

//@property (weak, nonatomic) IBOutlet UIButton *skipAhead;

@end


//TODO: Make this page look better!
//
//And that's probably it!
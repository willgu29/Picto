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

@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIView *currentPage;
@property (nonatomic, weak) IBOutlet UILabel *text;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;


@end

@implementation LoginViewController


//TODO: implement swipe for iphone viewing pictures change holder text


-(IBAction)tap:(id)sender
{
    if (_pageControl.currentPage == 2)
    {
        //do nothing... no pages left
    }
    else
    {
        [self animateToPage:(_pageControl.currentPage + 1)];
        _pageControl.currentPage++;
    }
}

-(IBAction)swipeRight:(id)sender
{
    if (_pageControl.currentPage == 0)
    {
        //do nothing... no pages left
    }
    else
    {
        [self animateToPage:(_pageControl.currentPage - 1)];
        _pageControl.currentPage--;
    }
    
}

-(IBAction)swipeLeft:(id)sender
{
    if (_pageControl.currentPage == 2)
    {
        //do nothing... no pages left
    }
    else
    {
        [self animateToPage:(_pageControl.currentPage + 1)];
        _pageControl.currentPage++;
    }
}

-(void)animateToPage:(NSUInteger)pageNumber
{
    //TODO: Animations to view and what not
    
    self.text.alpha = 0;
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.text.alpha = 1;}
                     completion:nil];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:_currentPage.bounds];
    UIImage *image = [[UIImage alloc] init];
    if (pageNumber == 0)
    {
        image = [UIImage imageNamed:@"lulsides.png"];
        self.text.text = @"LOL SIDES";
    }
    else if (pageNumber == 1)
    {
        image = [UIImage imageNamed:@"getfucked.png"];
        self.text.text = @"GET FUCKED";
    }
    else if (pageNumber == 2)
    {
        image = [UIImage imageNamed:@"wouldbang.png"];
        self.text.text = @"WOULD BANG";
    }
    else
    {
        //well shit
    }
    
    
    
    [view setImage:image];
    [_currentPage addSubview:view];

    
}




//This is a button on the xib (Login)
-(IBAction)loginToInsta:(UIButton *)sender
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //tell instagram what information we need from the user and have them authorize it
    [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", @"relationships", nil]];
    //WE DON"T USE COMMENTS LUL
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
    appDelegate.instagram.sessionDelegate = self;
    
    
    //Our page controller
    _pageControl.currentPage = 0;
    [self animateToPage:0];
    _pageControl.numberOfPages = 3;

    
    _loginButton.layer.cornerRadius = 15.0;
    _loginButton.layer.borderWidth = 1;
    _loginButton.clipsToBounds = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    
    
    
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
    //Make sure data saved properly
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    //Make a mapVC
    appDelegate.mapVC = [[MapViewController alloc] init];
    //present it
    [self presentViewController:appDelegate.mapVC animated:YES completion:^{
        //Register push notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }];
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

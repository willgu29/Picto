//
//  UserFeedViewController.m
//  Picto
//
//  Created by William Gu on 9/14/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "UserFeedViewController.h"
#import "AppDelegate.h"

@interface UserFeedViewController ()

@end

@implementation UserFeedViewController

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

-(IBAction)backButton:(UIButton *)sender
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.mapVC setZoomToLocationOnLaunch:NO];
    NSLog(@"PRESSED");
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if ([delegate.mapVC.picturesChosenByDrag count] > 1)
        {
            //TODO: can't stop first picture after dismiss
            [delegate.mapVC performSelector:@selector(startAnnotationTimer) withObject:nil afterDelay:.5];
        }
        else
        {
            
        }
    }];
}

@end

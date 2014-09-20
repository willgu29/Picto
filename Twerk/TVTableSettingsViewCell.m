//
//  TVTableSettingsViewCell.m
//  TrackView
//
//  Created by William Gu on 9/3/14.
//  Copyright (c) 2014 tianyu. All rights reserved.
//

#import "TVTableSettingsViewCell.h"
#import "AppDelegate.h"
#import "MapViewController.h"

@implementation TVTableSettingsViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)onOffSwitch:(UISwitch *)sender
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (_workAroundIdentifier == 0) //Allrecent
    {
        if (sender.on)
        {
            [delegate.mapVC setGlobalType:ALL];
            [[NSUserDefaults standardUserDefaults] setInteger:ALL forKey:@"WGglobalType"];
        }
        else
        {
            [delegate.mapVC setGlobalType:RECENT];
            [[NSUserDefaults standardUserDefaults] setInteger:RECENT forKey:@"WGglobalType"];
        }
    }
    else if (_workAroundIdentifier == 1) //friendsOnly
    {
        if (sender.on)
        {
            [delegate.mapVC setOnlyFriends:YES];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WGonlyFriends"];
        }
        else
        {
            [delegate.mapVC setOnlyFriends:NO];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WGonlyFriends"];
        }
    }
    else
    {
        
    }
    
 
}



@end

//
//  TVTableSettingsViewCell.m
//  TrackView
//
//  Created by William Gu on 9/3/14.
//  Copyright (c) 2014 tianyu. All rights reserved.
//

#import "TVTableSettingsViewCell.h"

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
    //TODO: if on, go off, if off, go on (save setting)
}



@end

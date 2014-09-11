//
//  TVTableSettingsViewCell.h
//  TrackView
//
//  Created by William Gu on 9/3/14.
//  Copyright (c) 2014 tianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVTableSettingsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *subText;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;


@end

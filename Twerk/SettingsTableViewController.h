//
//  SettingsTableViewController.h
//  Picto
//
//  Created by William Gu on 9/5/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGRequest.h"
#import "IGConnect.h"
#import <MessageUI/MessageUI.h>


//TODO: change to tableView with navigiation (Still using sidemenu for now)
@interface SettingsTableViewController : UITableViewController <IGSessionDelegate, MFMailComposeViewControllerDelegate>



@end

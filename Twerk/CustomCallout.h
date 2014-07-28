//
//  CustomCallout.h
//  Picto
//
//  Created by William Gu on 7/27/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>


//A custom view on how to present our callout picture
@interface CustomCallout : UIView

@property (weak, nonatomic) IBOutlet UILabel *infoText;
@property (weak, nonatomic) NSString *friendName;
@property (weak, nonatomic) NSString *locationName;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

//
//  CustomCallView.m
//  Picto
//
//  Created by William Gu on 9/14/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CustomCallView.h"

@interface CustomCallView()

@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *commentsButton;
@property (nonatomic, weak) IBOutlet UIButton *followButton;

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *locationText;

@end


@implementation CustomCallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

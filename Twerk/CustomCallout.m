//
//  CustomCallout.m
//  Picto
//
//  Created by William Gu on 7/27/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CustomCallout.h"


@implementation CustomCallout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)like:(id)sender
{
    //TODO: Like this picture!
}


-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image;
{
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",owner];
    _likes.text = [NSString stringWithFormat:@"%@ likes",likes];
    [_image setImage:image];
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

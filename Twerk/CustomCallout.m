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

-(IBAction)like:(id)sender //Action read is Touch Drag Inside
{
    //TODO: Like this picture!
}


-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image;
{
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",owner];
    _likes.text = [NSString stringWithFormat:@"%@ likes",likes];
    [_image setImage:image];
    
}


-(NSString *)formattedTimeSincePost:(NSString *)timeSincePost;
{
    NSString *format = [[NSString alloc] init];
    
    NSInteger seconds = timeSincePost.intValue;
    NSInteger minutes = seconds/60;
    NSInteger hours = minutes/60;
    NSInteger days = hours/24;
    NSInteger weeks = days/7;
    
    //TODO: blah
    
    
    return format;
    
}

-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime
{
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",owner];
    _likes.text = [NSString stringWithFormat:@"%@ likes",likes];
    [_image setImage:image];
    
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - createTime.intValue;
    //TODO: Convert seconds to min, hours, weeks and display proper letter after the rounded time.
    
    _timeSincePost.text = [NSString stringWithFormat:@"ToDO: %ld",timePassedInSeconds];
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

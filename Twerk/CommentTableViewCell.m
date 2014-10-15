//
//  CommentTableViewCell.m
//  Picto
//
//  Created by William Gu on 9/19/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    _comment.lineBreakMode = NSLineBreakByWordWrapping;
    _comment.numberOfLines = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)loadProfilePic:(NSString *)stringProfilePic
{
 
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:stringProfilePic]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    [_profilePic setImage:image];
    
}

-(void)formatCellWith:(NSString *)from andComment:(NSString *)text andTime:(NSInteger)createdTime;
{
    NSString *timeString = [self setUpTime:createdTime];
    
    
    
    NSString *myString =  [NSString stringWithFormat:@"%@: %@\n%@ ago",from, text, timeString];
    [_comment setText:myString];
}

-(NSString *)setUpTime:(NSInteger)createdTime
{
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - createdTime;
    NSString *timeString = [self getTimeString:timePassedInSeconds];
    
    NSArray *timeAndModifier = [timeString componentsSeparatedByString:@" "];
    NSString *theS = @"";

    if ([[timeAndModifier objectAtIndex:0] isEqualToString:@"1"])
    {
        
    }
    else
    {
        theS = @"s";
    }
    NSString *timeFormat = [NSString stringWithFormat:@"%@%@",timeString, theS];

    
    return timeFormat;
    
}

-(NSString*)numberToString:(NSInteger)number
{
    NSString *s = [NSString stringWithFormat:@"%ld", (long)number];
    return s;
}

-(NSString*)getTimeString:(float)postedTime
{
    
    if( postedTime < 60 ) //seconds
        return [NSString stringWithFormat:@"%@ second",[self numberToString:postedTime]];
    else if( postedTime < 3600 ) //minutes
        return [NSString stringWithFormat:@"%@ minute",[self numberToString:ceil(postedTime / 60)]];
    else if( postedTime < 86400 ) //hours
        return [NSString stringWithFormat:@"%@ hour",[self numberToString:ceil(postedTime / 3600)]];
    else if (postedTime < 604800 )  //days
        return [NSString stringWithFormat:@"%@ day",[self numberToString:ceil(postedTime / 86400)]];
    else if( postedTime >= 604800 ) //weeks
        return [NSString stringWithFormat:@"%@ week",[self numberToString:ceil(postedTime / 604800)]];
    else
    {
        NSLog(@"SECONDS COULDNT BE COMPARED TO INT: %ld",(long)postedTime);
        return nil;
    }
    
    
}


@end

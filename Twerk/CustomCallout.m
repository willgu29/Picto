//
//  CustomCallout.m
//  Picto
//
//  Created by William Gu on 7/27/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

//
//  CustomCallout.m
//  Picto
//
//  Created by William Gu on 7/27/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CustomCallout.h"
#import "AppDelegate.h"

@implementation CustomCallout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setUserHasLiked:(BOOL)userHasLiked
{
    _likeButton.selected = userHasLiked;
    _referencedAnnotation.userHasLiked = userHasLiked;
    if(userHasLiked)
        _likeButton.tintColor = [UIColor redColor];
    else
        _likeButton.tintColor = [UIColor blackColor];
}

-(void)makeLikeRequest
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSString* methodName = [NSString stringWithFormat:@"media/%@/likes", _mediaID];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [appDelegate.instagram requestWithMethodName:methodName
                                          params: params
                                      httpMethod:@"POST"
                                        delegate: self];
}

-(void)makeUnlikeRequest
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSString* methodName = [NSString stringWithFormat:@"media/%@/likes", _mediaID];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [appDelegate.instagram requestWithMethodName:methodName
                                          params: params
                                      httpMethod:@"DELETE"
                                        delegate: self];
}

-(void)updateDisplayOfHeart
{
    BOOL userLiked = _referencedAnnotation.userHasLiked;
    _likeButton.selected = userLiked;
    if(userLiked)
        _likeButton.tintColor = [UIColor redColor];
    else
        _likeButton.tintColor = [UIColor blackColor];
}

-(IBAction)like:(id)sender //Action read is Touch Drag Inside
{
    if(_referencedAnnotation.userHasLiked)
    {
        //MAKE DELETE REQUEST
        [self makeUnlikeRequest];
        [self setUserHasLiked: false];
        int numLikes = _referencedAnnotation.numberOfLikes.intValue - 1;
        _referencedAnnotation.numberOfLikes = [self numberToString: numLikes];
        _likes.text = [NSString stringWithFormat:@"%d likes", numLikes];
    }
    else
    {
        //MAKE POST REQUEST
        [self makeLikeRequest];
        [self setUserHasLiked: true];
        int numLikes = _referencedAnnotation.numberOfLikes.intValue + 1;
        _referencedAnnotation.numberOfLikes = [self numberToString: numLikes];
        _likes.text = [NSString stringWithFormat:@"%d likes", numLikes];
    }
}


-(NSString*)numberToString:(NSInteger)number
{
	NSString *s = [NSString stringWithFormat:@"%d", number];
	return s;
}

//TODO: TEST Function
-(NSString*)getTimeString:(float)postedTime
{
    
    if( postedTime < 20 ) //just now
        return @"now";
    else if( postedTime < 60 ) //seconds
        return [NSString stringWithFormat:@"%@s",[self numberToString:postedTime]];
    else if( postedTime < 3600 ) //minutes
        return [NSString stringWithFormat:@"%@m",[self numberToString:ceil(postedTime / 60)]];
    else if( postedTime < 86400 ) //hours
        return [NSString stringWithFormat:@"%@h",[self numberToString:ceil(postedTime / 3600)]];
    else if (postedTime < 604800 )  //days
        return [NSString stringWithFormat:@"%@d",[self numberToString:ceil(postedTime / 86400)]];
    else if( postedTime >= 604800 ) //weeks
        return [NSString stringWithFormat:@"%@w",[self numberToString:ceil(postedTime / 604800)]];
    else
    {
        NSLog(@"SECONDS COULDNT BE COMPARED TO INT: %ld",(long)postedTime);
        return nil;
    }
    
    
}

-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime andMediaID:(NSString *)mediaID andUserLiked:(BOOL)userHasLiked andAnnotation:(CustomAnnotation *)annotation
{
    _userLiked = userHasLiked;
    _mediaID = mediaID;
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",owner];
    _likes.text = [NSString stringWithFormat:@"%@ likes",likes];
    [_image setImage:image];
    
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - createTime.intValue;
    //TODO: Convert seconds to min, hours, weeks and display proper letter after the rounded time.
    
    _timeSincePost.text = [self getTimeString:timePassedInSeconds];
    //_timeSincePost.text = [NSString stringWithFormat:@"ToDO: %ld",timePassedInSeconds];
    _referencedAnnotation = annotation;
    //set liked button
    [self updateDisplayOfHeart];
}

-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime
{
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",owner];
    _likes.text = [NSString stringWithFormat:@"%@ likes",likes];
    [_image setImage:image];
    
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - createTime.intValue;
    //TODO: Convert seconds to min, hours, weeks and display proper letter after the rounded time.
    
    _timeSincePost.text = [self getTimeString:timePassedInSeconds];
    //_timeSincePost.text = [NSString stringWithFormat:@"ToDO: %ld",timePassedInSeconds];
}

-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime andMediaID:(NSString *)mediaID andUserLiked:(BOOL)hasUserLiked
{
    _userLiked = hasUserLiked;
    _mediaID = mediaID;
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",owner];
    _likes.text = [NSString stringWithFormat:@"%@ likes",likes];
    [_image setImage:image];
    
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - createTime.intValue;
    //TODO: Convert seconds to min, hours, weeks and display proper letter after the rounded time.
    
    _timeSincePost.text = [self getTimeString:timePassedInSeconds];
    //_timeSincePost.text = [NSString stringWithFormat:@"ToDO: %ld",timePassedInSeconds];
    
    //set liked button
    [self updateDisplayOfHeart];
}

-(void)request:(IGRequest *)request didLoad:(id)result
{
    
}

-(void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    
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

/*
 
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


-(NSString*)numberToString:(NSInteger)number
{
	NSString *s = [NSString stringWithFormat:@"%d", number];
	return s;
}

//TODO: TEST Function
-(NSString*)getTimeString:(float)postedTime
{

    if( postedTime < 20 ) //just now
        return @"now";
    else if( postedTime < 60 ) //seconds
        return [NSString stringWithFormat:@"%@s",[self numberToString:postedTime]];
    else if( postedTime < 3600 ) //minutes
        return [NSString stringWithFormat:@"%@m",[self numberToString:ceil(postedTime / 60)]];
    else if( postedTime < 86400 ) //hours
        return [NSString stringWithFormat:@"%@h",[self numberToString:ceil(postedTime / 3600)]];
    else if (postedTime < 604800 )  //days
        return [NSString stringWithFormat:@"%@d",[self numberToString:ceil(postedTime / 86400)]];
    else if( postedTime >= 604800 ) //weeks
        return [NSString stringWithFormat:@"%@w",[self numberToString:ceil(postedTime / 604800)]];
    else
    {
        NSLog(@"SECONDS COULDNT BE COMPARED TO INT: %ld",(long)postedTime);
        return nil;
    }
  
    
}


-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime
{
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",owner];
    _likes.text = [NSString stringWithFormat:@"%@ likes",likes];
    [_image setImage:image];
    
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - createTime.intValue;
    //TODO: Convert seconds to min, hours, weeks and display proper letter after the rounded time.
    
    _timeSincePost.text = [self getTimeString:timePassedInSeconds];
    //_timeSincePost.text = [NSString stringWithFormat:@"ToDO: %ld",timePassedInSeconds];
}

-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime andMediaID:(NSString *)mediaID andUserLiked:(BOOL)hasUserLiked
{
    _userLiked = hasUserLiked;
    _mediaID = mediaID;
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",owner];
    _likes.text = [NSString stringWithFormat:@"%@ likes",likes];
    [_image setImage:image];
    
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - createTime.intValue;
    //TODO: Convert seconds to min, hours, weeks and display proper letter after the rounded time.
    
    _timeSincePost.text = [self getTimeString:timePassedInSeconds];
    //_timeSincePost.text = [NSString stringWithFormat:@"ToDO: %ld",timePassedInSeconds];
}


-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime andMediaID:(NSString *)mediaID andUserLiked:(BOOL)userHasLiked andAnnotation:(CustomAnnotation *)annotation
{
    _userLiked = userHasLiked;
    _mediaID = mediaID;
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",owner];
    _likes.text = [NSString stringWithFormat:@"%@ likes",likes];
    [_image setImage:image];
    
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - createTime.intValue;
    //TODO: Convert seconds to min, hours, weeks and display proper letter after the rounded time.
    
    _timeSincePost.text = [self getTimeString:timePassedInSeconds];
    _referencedAnnotation = annotation;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
*/

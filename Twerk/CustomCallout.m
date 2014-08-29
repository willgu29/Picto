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
    {
        _likeButton.tintColor = [UIColor redColor];

    }
    else
    {
        _likeButton.tintColor = [UIColor blackColor];
    }
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
    {
        _likeButton.tintColor = [UIColor redColor];
        [_likeButton setTitle:@"  Liked" forState:UIControlStateNormal];
    }
    else
    {
        _likeButton.tintColor = [UIColor blackColor];
        [_likeButton setTitle:@"  Like" forState:UIControlStateNormal];
    }
}

-(IBAction)like:(id)sender //Action read is Touch Drag Inside
{
    NSLog(@"like button pressed");
    if(_referencedAnnotation.userHasLiked)
    {
        //MAKE DELETE REQUEST
        [self makeUnlikeRequest];
        [self setUserHasLiked: false];
        int numLikes = _referencedAnnotation.numberOfLikes.intValue - 1;
        _referencedAnnotation.numberOfLikes = [self numberToString: numLikes];
        _likes.text = [NSString stringWithFormat:@"%d likes", numLikes];
        [_likeButton setTitle:@"  Like" forState:UIControlStateNormal];
    }
    else
    {
        //MAKE POST REQUEST
        [self makeLikeRequest];
        [self setUserHasLiked: true];
        int numLikes = _referencedAnnotation.numberOfLikes.intValue + 1;
        _referencedAnnotation.numberOfLikes = [self numberToString: numLikes];
        _likes.text = [NSString stringWithFormat:@"%d likes", numLikes];
         [_likeButton setTitle:@"  Liked" forState:UIControlStateNormal];
    }
}


-(NSString*)numberToString:(NSInteger)number
{
	NSString *s = [NSString stringWithFormat:@"%ld", (long)number];
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


-(void)initCalloutWithAnnotation:(CustomAnnotation *)annotation andImage:(UIImage *)image
{
    _referencedAnnotation = annotation;
    [_image setImage:image];
    
    _userHasLiked = annotation.userHasLiked;
    _userHasFollowed = annotation.userHasFollowed;
    _mediaID = annotation.mediaID;
    _userID = annotation.userID;

    
    [self setUpTextLabels];
    [self updateDisplayOfHeart];
    [self updateFollowButton];
    
}

-(void)setUpTextLabels
{
    _infoText.text = [NSString stringWithFormat:@"%@'s Photo",_referencedAnnotation.ownerOfPhoto];
    _likes.text = [NSString stringWithFormat:@"%@ likes",_referencedAnnotation.numberOfLikes];

    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - _referencedAnnotation.timeCreated.intValue;
    _timeSincePost.text = [self getTimeString:timePassedInSeconds];
    
    [self setUpLocationLabel];
}

-(void)setUpLocationLabel
{
    if (_referencedAnnotation.locationString == nil)
    {
        NSLog(@"FUCKED UP");
        _locationString.text = @"";
    }
    else
        _locationString.text = [NSString stringWithFormat:@"%@", _referencedAnnotation.locationString];
}

-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime andMediaID:(NSString *)mediaID andUserLiked:(BOOL)userHasLiked andAnnotation:(CustomAnnotation *)annotation
{
    _userHasLiked = userHasLiked;
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


-(IBAction)followUnFolow:(UIButton *)sender
{
    NSLog(@"Follow button pressed");
    
    [self makeRequestToFollow];
    [self updateVariableUserHasFollowed];
    [self updateFollowButton];
    
}

-(void)updateVariableUserHasFollowed;
{
    if (_userHasFollowed == YES)
    {
        _referencedAnnotation.userHasFollowed = NO;
        _userHasFollowed = NO;
    }
    else
    {
        _referencedAnnotation.userHasFollowed = YES;
        _userHasFollowed = YES;
    }
}

-(void)updateFollowButton
{
    if (_userHasFollowed == YES)
    {
        _followUnfolowButton.selected = YES;
        [_followUnfolowButton setTitle:@"√ Following" forState:UIControlStateNormal];
    }
    else
    {
        _followUnfolowButton.selected = NO;
        [_followUnfolowButton setTitle:@"Follow +" forState:UIControlStateNormal];
    }
}

-(void)makeRequestToFollow
{
    //TODO: Figure this out
    //TEXT, action=follow
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSString* methodName = [NSString stringWithFormat:@"users/%@/relationship", _userID];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"follow", @"action", nil];
    [appDelegate.instagram requestWithMethodName:methodName
                                          params: params
                                      httpMethod:@"POST"
                                        delegate: self];
    
}

-(void)makeRequestToUnfollow
{
    //TODO: Figure this out
    //TEXT, action=unfollow
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSString* methodName = [NSString stringWithFormat:@"users/%@/relationship", _userID];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"unfollow", @"action", nil];
    [appDelegate.instagram requestWithMethodName:methodName
                                          params: params
                                      httpMethod:@"POST"
                                        delegate: self];
}


/* NOT WORKING DO NOT USE
- (IBAction)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Long press on view check for button");
    CGPoint locationOfTouch = [gestureRecognizer locationInView:self];
    if (locationOfTouch.x >= 140 && locationOfTouch.x <= 180 && locationOfTouch.y >= 300 && locationOfTouch.y <= 340)
    {
        NSLog(@"I should like this picture!");
        [self like:_likeButton];
    }
}
*/
 




-(void)request:(IGRequest *)request didLoad:(id)result
{
    NSLog(@"WHAT RESULT: %@", result);
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


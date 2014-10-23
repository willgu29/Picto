//
//  CustomCallView.m
//  Picto
//
//  Created by William Gu on 9/14/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CustomCallView.h"
#import "AppDelegate.h"
#import "UserDisplay.h"
#import "CommentsViewController.h"

@interface CustomCallView()
{
    BOOL getPosterData;
}

@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *commentsButton;
@property (nonatomic, weak) IBOutlet UIButton *followButton;

//@property (nonatomic, weak) IBOutlet UIButton *shareButton; i.e. bucketlist

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *locationText;
@property (nonatomic, weak) IBOutlet UILabel *timeSincePost;

//@property (nonatomic, weak) IBOutlet UILabel *captionText;
@property (nonatomic, weak) IBOutlet UITextView *captionText;
@property (nonatomic, weak) IBOutlet UIButton *infoButton;

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

-(void)initWithAnnotation:(CustomAnnotation *)annotation andImage:(UIImage *)image
{
    _referencedAnnotation = annotation;
    [_image setImage:image];
    [self setUpAll];

    
}

#pragma mark -Initial setup of labels
-(void)setUpAll
{
    [self setUpLikes];
    [self setUpLocation];
    [self setUpFollow];
    [self setUpComments];
    [self setUpTime];
    [self setUpCaption];
}

-(void)setUpCaption
{
    NSString *stringFormat = [NSString stringWithFormat:@"%@",[_referencedAnnotation.captionData valueForKeyPath:@"text"]];
    [_captionText setText:stringFormat];
    [_captionText setTextColor:[UIColor whiteColor]];
    [_captionText setTextAlignment:NSTextAlignmentCenter];
    _captionText.editable = YES;
//    [_captionText setFont:[UIFont fontWithName:@"Helvetica Neue-Italic" size:12]];
    _captionText.editable = NO;
    _captionText.backgroundColor = [UIColor colorWithRed:.549 green:.713 blue:.901 alpha:1.0];

    
}

-(void)setUpLikes
{
    [ _likeButton setTitle:[NSString stringWithFormat:@"%@",_referencedAnnotation.numberOfLikes] forState:UIControlStateNormal];
    if (_referencedAnnotation.userHasLiked)
    {
        UIColor *colorText = [UIColor whiteColor];
        [_likeButton setTitleColor:colorText forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"redButton.png"] forState:UIControlStateNormal];
    }
    else
    {
        UIColor *colorText = [UIColor colorWithRed:0.557 green:0.709 blue:0.919 alpha:1];
        [_likeButton setTitleColor:colorText forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"likeButton.png"] forState:UIControlStateNormal];

    }
    
}
-(void)setUpLocation
{
    [_locationText setText:_referencedAnnotation.locationString];
}
-(void)setUpFollow
{
    NSString *formatStringName = _referencedAnnotation.username;
    if ([formatStringName length] > 22)
        formatStringName = [formatStringName substringToIndex:22];
    
    if (_referencedAnnotation.userHasFollowed)
    {
        UIColor *colorText = [UIColor whiteColor];
        [_followButton setTitleColor:colorText forState:UIControlStateNormal];
        [_followButton setTitle:[NSString stringWithFormat:@"√ @%@",formatStringName] forState:UIControlStateNormal];
        [_followButton setBackgroundImage:[UIImage imageNamed:@"followGreen.png"] forState:UIControlStateNormal];
        

    }
    else
    {
        UIColor *colorText = [UIColor colorWithRed:0.557 green:0.709 blue:0.919 alpha:1];
        [_followButton setTitleColor:colorText forState:UIControlStateNormal];
        [_followButton setTitle:[NSString stringWithFormat:@"+ @%@",formatStringName] forState:UIControlStateNormal];
        [_followButton setBackgroundImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    }
}
-(void)setUpComments
{
    [_commentsButton setTitle:[NSString stringWithFormat:@"%@",_referencedAnnotation.numberOfComments] forState:UIControlStateNormal];
}

-(void)setUpTime
{
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    time_t timePassedInSeconds = todayInUnix - _referencedAnnotation.timeCreated.intValue;
    _timeSincePost.text = [self getTimeString:timePassedInSeconds];
}

-(NSString*)numberToString:(NSInteger)number
{
    NSString *s = [NSString stringWithFormat:@"%ld", (long)number];
    return s;
}

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

#pragma mark - IBAction

-(IBAction)infoButton:(UIButton *)sender
{
    NSString *username = _referencedAnnotation.username;
    NSString *userURL = [NSString stringWithFormat:@"instagram://user?username=%@",username];
    NSURL *instagramURL = [NSURL URLWithString:userURL];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
}

-(IBAction)likeButton:(UIButton *)sender
{
    if (_referencedAnnotation.userHasLiked)
    {
        [self requestUnlike];
    }
    else
    {
        [self requestLike];
    }
}
-(IBAction)commentButton:(UIButton *)sender
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    [self getUserData]; uncomment when posting is available
    CommentsViewController *commentVC = [[CommentsViewController alloc] init];
    
    commentVC.commentsData = self.referencedAnnotation.commentsData;
    commentVC.numberOfComments = self.referencedAnnotation.numberOfComments;
    commentVC.mediaID = self.referencedAnnotation.mediaID;
//    commentVC.posterProfileURL = delegate.mapVC.someUser.profilePictureURL;
//    commentVC.posterUsername = delegate.mapVC.someUser.username;
    
    [delegate.mapVC presentViewController:commentVC animated:YES completion:nil];
    //TODO: display new view for comments
}



-(IBAction)followButton:(UIButton *)sender
{
    if (_referencedAnnotation.userHasFollowed)
    {
        [self requestUnfollow];
    }
    else
    {
        [self requestFollow];
    }
}


#pragma mark - Request Types

-(void)requestLike
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSString* methodName = [NSString stringWithFormat:@"media/%@/likes", _referencedAnnotation.mediaID];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [appDelegate.instagram requestWithMethodName:methodName
                                          params: params
                                      httpMethod:@"POST"
                                        delegate: self];
    
    
    int numberOfLikes = _referencedAnnotation.numberOfLikes.intValue;
    _referencedAnnotation.userHasLiked = YES;
    numberOfLikes++;
    _referencedAnnotation.numberOfLikes = [NSString stringWithFormat:@"%d",numberOfLikes];
    [self setUpLikes];
    
    
}
-(void)requestUnlike
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSString* methodName = [NSString stringWithFormat:@"media/%@/likes", _referencedAnnotation.mediaID];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [appDelegate.instagram requestWithMethodName:methodName
                                          params: params
                                      httpMethod:@"DELETE"
                                        delegate: self];
    
    int numberOfLikes = _referencedAnnotation.numberOfLikes.intValue;
    _referencedAnnotation.userHasLiked = NO;
    numberOfLikes--;
    _referencedAnnotation.numberOfLikes = [NSString stringWithFormat:@"%d",numberOfLikes];
    [self setUpLikes];

    
}
-(void)requestFollow
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSString* methodName = [NSString stringWithFormat:@"users/%@/relationship", _referencedAnnotation.userID];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"follow", @"action", nil];
    [appDelegate.instagram requestWithMethodName:methodName
                                          params: params
                                      httpMethod:@"POST"
                                        delegate: self];
    
    _referencedAnnotation.userHasFollowed = YES;
    UserDisplay *data = [[UserDisplay alloc] initWithName:_referencedAnnotation.username andID:_referencedAnnotation.userID andProfilePicURL:_referencedAnnotation.profilePicURL];
    [appDelegate.mapVC.someUser.parsedFollowing addObject:data];
    [self setUpFollow];
    
}
-(void)requestUnfollow
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSString* methodName = [NSString stringWithFormat:@"users/%@/relationship", _referencedAnnotation.userID];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"unfollow", @"action", nil];
    [appDelegate.instagram requestWithMethodName:methodName
                                          params: params
                                      httpMethod:@"POST"
                                        delegate: self];
    
    _referencedAnnotation.userHasFollowed = NO;
    UserDisplay *data = [[UserDisplay alloc] initWithName:_referencedAnnotation.username andID:_referencedAnnotation.userID andProfilePicURL:_referencedAnnotation.profilePicURL];
    [appDelegate.mapVC.someUser.parsedFollowing removeObject:data];
    [self setUpFollow];


}

-(void)getUserData
{
    getPosterData = YES;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self", @"method", nil];
    //just creates a pointer to our app delegate. Nothing else to understand in this code
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //send the instagram property in our appdelehate.h this message "reqeustWithParams: delegate" (based on the instagram iOS SDK
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
    
}


#pragma mark - Update actual


#pragma mark - Request Delegate
-(void)request:(IGRequest *)request didLoad:(id)result
{
    NSLog(@"CustomCallout - Instagram did load: %@", result);
    if (getPosterData)
    {
        NSLog(@"got poster data");
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.mapVC.someUser.userData = (NSDictionary *)[result objectForKey:@"data"];

    }
}
-(void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"CustomCallout - Instagram ERROR: %@", error);
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

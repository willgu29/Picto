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

@interface CustomCallView()

@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *commentsButton;
@property (nonatomic, weak) IBOutlet UIButton *followButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;

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
    if ([formatStringName length] > 25)
        formatStringName = [formatStringName substringToIndex:25];
    
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

#pragma mark - IBAction

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
    [self getComments];
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

-(IBAction)shareButton:(UIButton *)sender
{
    //TODO: sharing feature
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
-(void)getComments
{
    //TODO:
}
-(void)postComment
{
    //TODO:
}
-(void)deleteComment
{
    //TODO:
}


#pragma mark - Update actual


#pragma mark - Request Delegate
-(void)request:(IGRequest *)request didLoad:(id)result
{
    NSLog(@"CustomCallout - Instagram did load: %@", result);
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

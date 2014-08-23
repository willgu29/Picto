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


@property (weak, nonatomic) IBOutlet UILabel *timeSincePost;
@property (weak, nonatomic) IBOutlet UILabel *infoText;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextPicture;
@property (weak, nonatomic) IBOutlet UIButton *prevPicture;
@property (nonatomic) BOOL userLiked; //TODO: fetch if userLiked picture from WGPhoto to annotation

-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image;
-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime;

@end

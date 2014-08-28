//
//  CustomCallout.h
//  Picto
//
//  Created by William Gu on 7/27/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAnnotation.h"
#import "IGRequest.h"

//A custom view on how to present our callout picture
@interface CustomCallout : UIView <IGRequestDelegate>

@property (strong, nonatomic) CustomAnnotation *referencedAnnotation;

@property (strong, nonatomic) NSString *mediaID;
@property (weak, nonatomic) IBOutlet UILabel *timeSincePost;
@property (weak, nonatomic) IBOutlet UILabel *infoText;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *locationString;


@property (nonatomic) BOOL userHasLiked; //TODO: We have two bools... And we use both in here.. OOPS. 
@property (nonatomic) BOOL userLiked; //TODO: fetch if userLiked picture from WGPhoto to annotation


-(void)initCalloutWithAnnotation:(CustomAnnotation *)annotation andImage:(UIImage *)image;


-(void)setUpAnnotationWith:(NSString *)owner andLikes:(NSString *)likes andImage:(UIImage *)image andTime:(NSString *)createTime andMediaID:(NSString *)mediaID andUserLiked:(BOOL)userHasLiked andAnnotation:(CustomAnnotation *)annotation;


@end

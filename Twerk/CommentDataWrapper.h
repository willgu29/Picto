//
//  CommentDataWrapper.h
//  Picto
//
//  Created by William Gu on 10/15/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentDataWrapper : NSObject

@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *timeOfPost;
@property (strong, nonatomic) NSString *profileURL;
@property (strong, nonatomic) NSString *username;
@property (nonatomic) CGFloat estimatedHeight;

-(instancetype)initWith:(id)commentData;
-(instancetype)initWithComment:(NSString *)string andTime:(NSString *)time andProfile:(NSString *)profile andUsername:(NSString *)user;
//-(CGSize)heightForTextLabel:(NSString *)text;

@end

//
//  CommentTableViewCell.h
//  Picto
//
//  Created by William Gu on 9/19/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *username;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *timeSincePost;

@property (weak, nonatomic) IBOutlet UITextView *commentView;

-(void)formatCellWith:(NSString *)from andComment:(NSString *)text andTime:(NSInteger)createdTime;
-(instancetype)init;
-(void)loadProfilePic:(NSString *)stringProfilePic;


@end

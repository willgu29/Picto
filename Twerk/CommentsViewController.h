//
//  CommentsViewController.h
//  Picto
//
//  Created by William Gu on 9/19/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGRequest.h"
#import "CustomAnnotation.h"

@interface CommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,IGRequestDelegate>

@property (nonatomic, strong) CustomAnnotation *referencedAnnotation;

@property (nonatomic, strong) NSDictionary *commentsData;
@property (nonatomic, strong) NSString *numberOfComments;
@property (nonatomic, strong) NSString *mediaID;
//@property (nonatomic, strong) NSDictionary *captionData;

@property (nonatomic, strong) NSString *posterProfileURL;
@property (nonatomic, strong) NSString *posterUsername;


@end

//
//  TVSettingsObject.h
//  TrackView
//
//  Created by William Gu on 9/3/14.
//  Copyright (c) 2014 tianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVSettingsObject : NSObject

@property (nonatomic, strong) NSString *mainTitle;
@property (nonatomic, strong) NSString *subText;
@property (nonatomic) BOOL on;


-(instancetype)initWithMainTitle:(NSString *)mainTitle andSubText:(NSString *)subText andOn:(BOOL)on;
-(instancetype)initWithMainTitle:(NSString *)mainTitle andSubText:(NSString *)subText;

@end

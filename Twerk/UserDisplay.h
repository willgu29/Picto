//
//  UserDisplay.h
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "BaseDisplay.h"

@interface UserDisplay : BaseDisplay

@property (strong, nonatomic) NSString *profilePicURL;
@property (strong, nonatomic) NSString *userID;

-(instancetype)initWithName:(NSString *)name andID:(NSString *)userID andProfilePicURL:(NSString *)profilePicURL;

@end

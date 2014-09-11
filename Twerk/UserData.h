//
//  UserData.h
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *profilePicURL;

-(instancetype)initWithUsername:(NSString *)name andID:(NSString *)ID andProfilePicURL:(NSString *)picURL;


@end

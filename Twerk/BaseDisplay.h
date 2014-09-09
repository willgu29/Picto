//
//  BaseDisplay.h
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDisplay : NSObject

@property (strong, nonatomic) NSString *name;

-(instancetype)initWithName:(NSString *)name;

@end

//
//  HashDisplay.h
//  Picto
//
//  Created by William Gu on 9/8/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "BaseDisplay.h"

@interface HashDisplay : BaseDisplay

@property (strong, nonatomic) NSString *mediaCount;

-(instancetype)initWithName:(NSString *)name andMediaCount:(NSString *)mediaCount;

@end

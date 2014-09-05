//
//  PictureArray.h
//  Picto
//
//  Created by William Gu on 9/4/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGRequest.h"

@interface PictureArray : NSObject <IGRequestDelegate>


@property (nonatomic, strong) NSMutableSet *nextPicturesData; //not parsed
@property (nonatomic, strong) NSMutableOrderedSet *nextPicturesSet; //parsed


-(void)findPopularImages;
-(instancetype)init;


@end
//TODO: This class will probably handle friend pictures, popular, and tags.
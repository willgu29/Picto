//
//  LocationSearch.h
//  Picto
//
//  Created by William Gu on 9/7/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationSearch : NSObject

@property (nonatomic, strong) NSMutableArray *searchResults;

-(instancetype)init;
-(void)performSearch:(NSString *)searchText;

@end

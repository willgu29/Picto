//
//  HashTagSearch.h
//  Picto
//
//  Created by William Gu on 9/7/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGRequest.h"

@interface HashTagSearch : NSObject <IGRequestDelegate>


@property (strong, nonatomic) NSMutableArray *hashTagData;
@property (strong, nonatomic) NSMutableArray *hashTagParsed;
//@property (nonatomic) NSInteger mediaCount;
//@property (strong, nonatomic) NSString *name;


-(void)fillAutoCompleteSearchDataWithHashTags:(NSString *)searchText;
-(instancetype)init;

@end

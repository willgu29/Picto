//
//  HashTagSearch.m
//  Picto
//
//  Created by William Gu on 9/7/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "HashTagSearch.h"
#import "AppDelegate.h"

@implementation HashTagSearch

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _hashTagData = [[NSArray alloc] init];
    }
    
    return self;
}

-(void)fillAutoCompleteSearchDataWithHashTags:(NSString *)searchText
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseHashTagData) name:@"parse hashtag" object:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"tags/%@", searchText], @"method", nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram requestWithParams:params delegate:self];
}

-(void)parseHashTagData
{
    //_hasTagData will ALWAYS only have 1 return result
    NSLog(@"HASH: %@", _hashTagData);
    
//    NSArray *data = [_hashTagData componentsSeparatedByString:@"\n"];
//    NSLog(@"Object: %@, Object 2: %@", [data objectAtIndex:0], [data objectAtIndex:1]);
//    NSLog(@"COUNT: %lu", (unsigned long)[data count]);
    
    NSString *name = [_hashTagData valueForKeyPath:@"name"];
    NSString *mediaCountString = [_hashTagData valueForKeyPath:@"media_count"];

    _name = name;
    _mediaCount = mediaCountString.intValue;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"done parsing hashtag" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"parse hashtag"];
}


//Same as User.m IGRequestDelegate
- (void)request:(IGRequest *)request didLoad:(id)result {
    //NSLog(@"Instagram did load: %@", result);
    _hashTagData = (NSArray *)[result objectForKey:@"data"];
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"Load Geo" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"parse hashtag" object:self];
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}



@end

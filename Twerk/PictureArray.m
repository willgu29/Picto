//
//  PictureArray.m
//  Picto
//
//  Created by William Gu on 9/4/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "PictureArray.h"
#import "AppDelegate.h"
@implementation PictureArray 


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _nextPicturesSet = [[NSMutableOrderedSet alloc] init];
    }
    
    return self;
}


-(void)findPopularImages //load popular images (regardless of location)
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/media/popular"], @"method", nil];
    //create pointer to app delegate
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //send the instagram property in our appdelehate.h this message "reqeustWithParams: delegate" (based on the instagram iOS SDK
    [appDelegate.instagram requestWithParams:params delegate:self];
}



//Same as User.m IGRequestDelegate
- (void)request:(IGRequest *)request didLoad:(id)result {
    //NSLog(@"Instagram did load: %@", result);
    _nextPicturesData = (NSMutableSet*)[result objectForKey:@"data"];
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"Load Geo" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Next Array Data Loaded" object:self];
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


//
//  CustomCallView.h
//  Picto
//
//  Created by William Gu on 9/14/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAnnotation.h"
#import "IGRequest.h"

@interface CustomCallView : UIView <IGRequestDelegate>

@property (nonatomic, strong) CustomAnnotation *referencedAnnotation;

-(void)initWithAnnotation:(CustomAnnotation *)annotation andImage:(UIImage *)image;

@end

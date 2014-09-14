//
//  THSound.h
//  Picto
//
//  Created by Tim on 9/13/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface THSound : NSObject

-(AVAudioPlayer *)THreadySound:(NSString *)soundPath ofType:(NSString *)fileType;

@end

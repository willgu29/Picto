//
//  THSound.m
//  Picto
//
//  Created by Tim on 9/13/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "THSound.h"
#import <AVFoundation/AVFoundation.h>

@implementation THSound

/**
 Ready a sound file for playing.
 Example usage:
 @code
 AVAudioPlayer clickSound= [self readySound:(NSString *)@"clickSound" ofType: @"WAV"];
 [clickSound play]; //play sound
 [clickSound release]; //release object when done with it
 @endcode
 @param soundPath the path of the sound file to play
 @param fileType the extension of the sound file
 @return the AVAudioPlayer object of the sound provided
 */
-(AVAudioPlayer *)THreadySound:(NSString *)soundPath ofType:(NSString *)fileType
{
    NSLog([NSString stringWithFormat:@"sound path: %@", [[NSBundle mainBundle]
                                                         pathForResource:soundPath
                                                         ofType:fileType]]);
    NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:soundPath
                                              ofType:fileType]];
    NSLog([NSString stringWithFormat:@"FILE PATH IS: %@", [soundURL debugDescription]]);
    AVAudioPlayer *dropSound = [[AVAudioPlayer alloc] initWithContentsOfURL: soundURL error:nil];
    return dropSound;
}

@end

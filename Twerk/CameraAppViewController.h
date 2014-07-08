//
//  CameraAppViewController.h
//  Twerk
//
//  Created by William Gu on 4/12/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface CameraAppViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSOperationQueue *queue;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

//TODO: Don't worry about this yet
//I kept this here since we'll still need to take pictures/videos inside the app, this code will be helpful!
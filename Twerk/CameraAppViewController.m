//
//  CameraAppViewController.m
//  Twerk
//
//  Created by William Gu on 4/12/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CameraAppViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>
#import "MusicViewController.h"
#import "ShareViewController.h"


double accelX;
double accelY;
double accelZ;

@interface CameraAppViewController (){
    
}

- (IBAction)takePhoto:(UIButton *)sender;

- (IBAction)shareApp: (UIButton *)sender;

- (IBAction)chooseMusic: (UIButton *) sender;


//- (IBAction)selectPhoto:(UIButton *)sender;




@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UIView *musicView;

@end

@implementation CameraAppViewController{
    
    CMMotionManager* motionManager;
    UIView *oView;
    UIImage *chosenImage;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark Buttons

- (IBAction)chooseMusic:(UIButton *)sender
{
    
    //TODO:
    //how to present as a subview instead?
    MusicViewController *musicController = [[MusicViewController alloc] init];
    [self presentViewController:musicController animated:YES completion:nil];
    
    
}

- (IBAction)shareApp:(UIButton *)sender
{
    //TODO:
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    oView = [[UIView alloc] init];
    UIImageView* overlayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"butt.png"]];
    [overlayView.layer setOpaque:NO];
    overlayView.opaque = NO;
    [oView addSubview:overlayView];
    oView.frame = CGRectMake(0, 200, 113, 150);
    oView.contentMode = UIViewContentModeScaleAspectFit;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraOverlayView = oView;
    
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

#pragma mark Main Screen
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    //place distortion for image here!  (manipulate *chosenImage)
    //TODO:  (Need to add twerking effect to picture)
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)doSomethingWithData:(CMAcceleration)acceleration
{
    if (acceleration.x > .5)
    {
        NSLog(@"x direction accel!");
    }
    if (acceleration.y > .5)
    {
        NSLog(@"y direction accel!");
    }
}




- (void)viewDidLoad
{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    [super viewDidLoad];
    


    // Do any additional setup after loading the view from its nib.
    motionManager = [[CMMotionManager alloc] init];
    if ([motionManager isAccelerometerAvailable] == YES) {
        motionManager.accelerometerUpdateInterval = .1;
        //[mManager setAccelerometerUpdateInterval:updateInterval];
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            if (accelerometerData.acceleration.y > .5)
            {
                NSLog(@"Shake detected (UP DOWN)");
                //TODO: (do something with data!)
                
                
            }
            if (accelerometerData.acceleration.x > .5)
            {
                NSLog(@"Shake detected (LEFT RIGHT)");
                //TODO: (do something with data!)
            }
            
        }];
    }
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end

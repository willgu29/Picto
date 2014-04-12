//
//  CameraAppViewController.m
//  Twerk
//
//  Created by William Gu on 4/12/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CameraAppViewController.h"
#import "CMMotionManager.h"
#import <CoreMotion/CoreMotion.h>


double accelX;
double accelY;
double accelZ;

@interface CameraAppViewController ()

- (IBAction)takePhoto:(UIButton *)sender;

- (IBAction)selectPhoto:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIImageView *imageView;



@end

@implementation CameraAppViewController


#pragma mark Main Screen
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    UIView* oView = [[UIView alloc] init];
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

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    //place distortion for image here!  (manipulate *chosenImage)
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    //
    workIt();
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Detect Shake Gesture (Core Motion...)
//harder... probably what we are looking for

-(void) workIt
{
CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = .2;
    

if (motionManager.deviceMotionAvailable ) {
    queue = [NSOperationQueue currentQueue];
             /*
    [motionManager startDeviceMotionUpdatesToQueue:queue
                                       withHandler:^ (CMDeviceMotion *motionData, NSError *error) {
                                           
                                           //CMAttitude *attitude = motionData.attitude;
                                           //CMAcceleration gravity = motionData.gravity;
                                           //CMAcceleration userAcceleration = motionData.userAcceleration;
                                           //CMRotationRate rotate = motionData.rotationRate;
                                           //CMCalibratedMagneticField field = motionData.magneticField;
                                           
                                           //...handle data here......
                                       }];
              */
             
             [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData,NSError *error){
                 [self doSomethingWithData:accelerometerData.acceleration ];
        //handle data..
        //example
        //int<-replace type image(someObject)= acceleration.x;
        
    }];
            
             }
             
}

-(void)doSomethingWithData:(CMAcceleration)acceleration
{
    
}

///not done implementing yet
/*
-(void)getData
{
    [CMMotionManager startDeviceMotionUpdates];
    CMDeviceMotion *motion = CMMotionManager.deviceMotion;
    [CMMotionManager stopDeviceMotionUpdates];
}
*/


#pragma mark Detect Shake Gesture (Simple Way... )
//not sure what it even allows us to do

/*
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        //your code
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}


//not sure if two below needed  (supposed to assign this viewcontroller as first responder)
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}
///


-(BOOL)canBecomeFirstResponder
{
    return YES;
}
*/


@end

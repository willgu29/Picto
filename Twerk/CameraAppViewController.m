//
//  CameraAppViewController.m
//  Twerk
//
//  Created by William Gu on 4/12/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CameraAppViewController.h"
#import <CoreMotion/CoreMotion.h>


double accelX;
double accelY;
double accelZ;

@interface CameraAppViewController (){
    
    //CMMotionManager *motionManager;
   // NSOperationQueue *queue;
    
}

- (IBAction)takePhoto:(UIButton *)sender;

- (IBAction)selectPhoto:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation CameraAppViewController

CMMotionManager* motionManager;

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
    //[motionManager?? startAccelerometerUpdates]; // !!!: What are you trying to do? What object are you trying to call this on?
    
    
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
    
    
    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    if ([mManager isAccelerometerAvailable] == YES) {
        mManager.accelerometerUpdateInterval = .1;
        //[mManager setAccelerometerUpdateInterval:updateInterval];
        [mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            NSLog(@"PRAY");
        }];
    }
    //
    //[self workIt];
    /*
    motionManager = [[CMMotionManager alloc] init];
    [motionManager startAccelerometerUpdates];
    motionManager.accelerometerUpdateInterval = .1; //100Hz
     if (motionManager.deviceMotionAvailable) {
         queue = [NSOperationQueue currentQueue];
         
         [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData,NSError *error){
             [self doSomethingWithData:accelerometerData.acceleration ];
             
             //handle data..
             //example
             //int<-replace type image(someObject)= acceleration.x;
             
         }];
         
     }
     */
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

   
    
             
}

-(void)doSomethingWithData:(CMAcceleration)acceleration
{
    if (acceleration.x >0)
    {
        NSLog(@"x direction accel!");
    }
    if (acceleration.y > 0)
    {
        NSLog(@"y direction accel!");
    }
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

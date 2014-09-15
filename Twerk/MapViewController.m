
//  MapViewController.m
//  Picto
//
//  Created by William Gu on 7/2/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//
#include <stdlib.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#import "MapViewController.h"
#import "CameraAppViewController.h"
#import "WGMap.h"
#import "WGPhoto.h"
#import "CustomAnnotation.h"
#import "CustomCallout.h"
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>
#import "BaseDisplay.h"
#import "UserDisplay.h"
#import "LocationDisplay.h"
#import "HashDisplay.h"
#import "THSound.h"

const NSInteger METERS_PER_MILE = 1609.344;
const NSInteger MAX_ALLOWED_PICTURES = 100; //ON SCREEN
const NSInteger POPULAR_PICTURES_IN_ARRAY = 7;
const NSInteger ANNOTATION_RADIUS = 25;

const NSInteger LOAD_DATA_ZOOM_THRESHOLD = 400;
const NSInteger LOAD_GEO_PAN_THRESHOLD = 10000;
const NSInteger LOAD_DATA_PAN_THRESHOLD = 100;

const NSInteger LOAD_DATA_LOWER = 10;
const NSInteger LOAD_DATA_UPPER = 10000;

const double SCALE_FACTOR = 500.0;


//Picture Border Types: (APPLY TO annotationView.layer.borderColor) (Or rather just change colorType and call updateTheBorderColor....)
//******************************
/*
 WHITE BORDER = Unknown/All picture
 YELLOW BORDER = VIEWED/ABOUT TO VIEW
 RED BORDER = LIKED
 BLUE BORDER = POPULAR
 GREEN BORDER = FRIEND
 PURPLE BORDER = SUGGESTED FOR YOU

*/
//******************************


@interface MapViewController ()
{
    int arrayCounter;
    int nextPictureSetCounter;
    CGPoint lastPoint;
    BOOL beganInAnnotation;
    UIImageView *tempImageView;
}

@property (nonatomic, strong) NSMutableArray *paths;

@property (nonatomic) BOOL isMatch;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIImageView *pictoOverlay;

@property (nonatomic) BOOL lockNext;

@end

@implementation MapViewController

#pragma mark - Picto

-(IBAction)swipeRightToBox:(id)sender
{
    NSLog(@"Switch modes!");

    if (_isInBoxMode)
    {
        _isInBoxMode = NO;
        UIImage *image = [UIImage imageNamed:@"Overlay 80"];
        [_pictoOverlay setImage:image];

    }
    else
    {
        _isInBoxMode = YES;
        UIImage *image1 = [UIImage imageNamed:@"Overlay 81"]; //Or 82
        [_pictoOverlay setImage:image1];
        
        
    }
    
    
}

-(IBAction)returnToHome:(UIButton *)sender
{
    MKCoordinateRegion zoomLocation = MKCoordinateRegionMakeWithDistance(_someUser.currentLocation.coordinate, 100, 100);
    [_mapView setRegion:zoomLocation animated:YES];
}

#pragma mark - View Life Cycle


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
    [super viewDidLoad];
    
    _isInBoxMode = NO;
    _zoomToLocationOnLaunch = YES;
    // Do any additional setup after loading the view from its nib.
    _searchField.delegate = self;
    _mapView.delegate = self;
    //there is a hidden TableView in our window for the search later
    _autoCompleteTableView.hidden = YES;
    _autoCompleteTableView.delegate = self;
    _autoCompleteTableView.dataSource = self;
    _autoCompleteTableView.scrollEnabled = YES;
    
    //1.
    _someUser = [[User alloc] init];
    [self loadFollowing];
    [self setUpPicturesArray];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLocationGeo) name:@"Load Geo" object:nil];
    //OR 2.1  One or the either are called (Load Geo segways to We should load data)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMethodForTypeWorkAround) name:@"We should load data" object:nil];
    //3. Allows us to parse data now
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseSelectorMethod) name:@"Images Loaded" object:nil];
    //4.After Popular Photos are loaded and parsed
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoomToPopular) name:@"Can Zoom to Popular" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseNextSelectorMethod) name:@"Next Array Data Loaded" object:nil];
    
    
    [self setUpSavedData];
    
//tim's sound stuff
    [self setUpTHSound];
    _onDropSound = [_THsound THreadySound:@"AirHorn-Reggae" ofType:@"mp3"];
    NSLog(@"AV Object looks like: %@", [_onDropSound debugDescription]);
    [self updateViewConstraints]; // ???: Did I add this? (WG)
}

-(void)setUpTHSound
{
    if(_THsound == nil)
        _THsound = [[THSound alloc] init];
}

-(void)setUpPicturesArray
{
    if (_picturesArray == nil)
    {
        _picturesArray = [[PictureArray alloc] init];
    }
    _isPopularNotFriend = NO;
    _lockNext = YES;
    [_picturesArray findFollowingImages];
}


-(void)setUpSavedData
{
    [self setGlobalType:[[NSUserDefaults standardUserDefaults] integerForKey:@"WGglobalType"]];
    [self setOnlyFriends:[[NSUserDefaults standardUserDefaults] boolForKey:@"WGonlyFriends"]];
    
    if (_globalType == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:ALL forKey:@"WGglobalType"];
        [self setGlobalType:ALL];
    }
    
}


-(void)viewDidAppear:(BOOL)animated
{
    if (_zoomToLocationOnLaunch == NO)
        return;
    
    [_someUser getCurrentLocationOnMap:_mapView]; //get location of user
    //zoom to user location on map
    CLLocationDistance lat = 100;
    CLLocationDistance lng = 100;
    if (_someUser.currentLocation.coordinate.latitude == 0 && _someUser.currentLocation.coordinate.longitude == 0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoomStart) name:@"Zoom to map" object:nil];
        [_someUser performSelector:@selector(getCurrentLocationOnMap:) withObject:_mapView afterDelay:1];
        
    }
    else
    {
        [self zoomToRegion:_someUser.currentLocation.coordinate withLatitude:lat withLongitude:lng withMap:_mapView];
    }

}


-(void)viewDidUnload
{
    //TODO: Set to nil what is needed and remove other observers
    //remove the observers if we leave this view
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"We should load data" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Load Geo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Can Zoom to Popular" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Can Find Location" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Images Loaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CanParseFollowing" object:nil];
    // Clean the map one last time
    [_mapView cleanupMap];
    // Stop the clean timer
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //TODO: Handle memory warning
    // Dispose of any resources that can be recreated.
}

#pragma mark - Call Loading Methods

-(void)loadFollowing
{
    [_someUser retrieveWhoUserIsFollowingFromIG];
}

-(void)loadLocationGeo
{
    [self parseStringOfLocation:_mapView.currentLocation];
}

-(void)selectMethodForTypeWorkAround
{
    if (_globalType == ALL)
    {
        NSLog(@"ALL");
        [_mapView findAllImagesOnMapInRange:(_mapView.radius/1.5) inLatitude:_mapView.currentLocation.latitude andLongitude:_mapView.currentLocation.longitude];
    }
    else if (_globalType == RECENT)
    {
        NSLog(@"RECENT");
        [_mapView findRecentImagesOnMapInRange:(_mapView.radius/1.5) inLatitude:_mapView.currentLocation.latitude andLongitude:_mapView.currentLocation.longitude];
    }
}


#pragma mark - Parse Data

-(void)parseFollowing
{
    _someUser.parsedFollowing = [[NSMutableSet alloc] init];
    for (id userData in _someUser.following)
    {
        NSLog(@"USER: %@", userData);
        NSString *username = [userData valueForKeyPath:@"username"];
        NSString *userID = [userData valueForKeyPath:@"id"];
        NSString *profilePicURL = [userData valueForKeyPath:@"profile_picture"];
        UserDisplay *data = [[UserDisplay alloc] initWithName:username andID:userID andProfilePicURL:profilePicURL];
        [_someUser.parsedFollowing addObject:data]; //valueForKey:@"username"]
    }
    
}

-(void)parseSelectorMethod
{
    if (!_lock)
    {
        [_mapView cleanupMap];
    }
    _lock = YES;
    if (_globalType == ALL || _globalType == RECENT)
    {
        [self parseAll];
    }
    
}

-(void)parseNextSelectorMethod
{
    //if popular and not.. say friends
    [self parsePopularAndPlaceIntoPicturesPopularArray];

    
}

-(void)parseAll
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (id pictureURL in _mapView.possiblePics)
        {
            if ( ! [self shouldWeParseThisPicture:pictureURL])
            {
                continue;
            }
            else
            {
                //We good
            }
            if (_onlyFriends == YES)
            {
                NSString *pictureIDUser = [pictureURL valueForKeyPath:@"user.username"];
                
                NSArray *usernames = [_someUser.parsedFollowing valueForKey:@"name"];
//                if ([_someUser.parsedFollowing containsObject:pictureIDUser] == YES)
                if ([usernames containsObject:pictureIDUser] == YES)
                {
                    
                }
                else
                {
                    continue;
                }
            }
            
            CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithPictureData:pictureURL];
//            CustomAnnotation *annotation = [self parseAndReturnAnnotation:pictureURL];
            
            //We can probably do this right after we check the mediaID (the first thing we should check)
            NSInteger resultOfCheck = [self checkAnnotationEnums:annotation];
            
            if (resultOfCheck == OVERLAP)
            {
                continue;
            }
            else if (resultOfCheck == DUPLICATE)
            {
                //try next pic
                continue;
            }
            else if (resultOfCheck == FLOOD)
            {
                //stop loading pictures ffs
                break;
            }
            else if (resultOfCheck == SUCCESS)
            {
                //YASS
            }
            
            [annotation createNewImage];
            [self hasFollowedUser:annotation];
            [annotation setLocationString:self.currentMapViewGeoLocation];
            
            //do this when done loading.. on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                if (annotation.numberOfLikes.intValue > 1000)
                {
                    annotation.isPopular = YES;
                }
                //TODO: check for friend
                [_mapView addAnnotation:annotation]; //THIS adds an annotation to _mapView.annotations
            });
        }
        _lock = NO;
    });
}

//TODO: move this to separate data object with different array
-(void)parsePopularAndPlaceIntoPicturesPopularArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //Only supporting images right now
        int someCounter = 0;
//        for (id pictureURL in _mapView.possiblePics)
        for (id pictureURL in _picturesArray.nextPicturesData)
        {
            
            
            if (someCounter >= POPULAR_PICTURES_IN_ARRAY)
            {
                break;
            }
            if ( ! [self shouldWeParseThisPicture:pictureURL])
            {
                continue;
            }
            else
            {
                //We good
            }
            
            
           
            CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithPictureData:pictureURL];
//            CustomAnnotation *annotation = [self parseAndReturnAnnotation:pictureURL];
            
            
            //How can we not load the same popular/user feed pictures?
            //TODO: more efficient way?
            
//            //Continues if user has already seen this picture
//            BOOL samePicture = NO;
//            for (int i = 0; i < [_picturesArray.nextPicturesSet count]; i++)
//            {
//                CustomAnnotation *picture = [_picturesArray.nextPicturesSet objectAtIndex:i];
//                if ([picture isEqualToAnnotation:annotation])
//                {
//                    samePicture = YES;
//                    break;
//                }
//            }
            
//            if (samePicture == YES)
//            {
//                continue;
//            }
            
            
//            for (CustomAnnotation* picture in _picturesArray.nextPicturesSet)
//            {
//                //BAD_ACCESS HERE
//            if ([picture isEqualToAnnotation:annotation])
//            {
//                samePicture = YES;
//                break;
//            }
//            }
            
            
            
            //We can probably do this right after we check the mediaID (the first thing we should check)
            NSInteger resultOfCheck = [self checkAnnotationEnums:annotation];
            
            if (resultOfCheck == OVERLAP)
            {
                continue;
            }
            else if (resultOfCheck == DUPLICATE)
            {
                //try next pic
                continue;
            }
            else if (resultOfCheck == FLOOD)
            {
                //stop loading pictures ffs
                break;
            }
            else if (resultOfCheck == SUCCESS)
            {
                //YASS
            }
            
            
            
            someCounter++;
            
            //OR save object as video WGVideo subclass.. (not made yet)
            [annotation createNewImage]; //TODO: Call this only when we need to preload
            [self hasFollowedUser:annotation];
            //[annotation setLocationString:self.currentMapViewGeoLocation];
            [annotation parseStringOfLocation:annotation.coordinate]; //We'll do the parse for popular pictures since we only load a few.
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_isPopularNotFriend == YES)
                {
                    annotation.isPopular = YES;
                }
                else
                {
                    annotation.isFriend = YES;
                }
                [_picturesArray.nextPicturesSet addObject:annotation];
                
            });
        }
//        _lock = NO;
        _lockNext = NO;
    });
}


#pragma mark - Helper Methods for parsing Data


-(BOOL)shouldWeParseThisPicture:(id)picture
{
    //TODO: Add video support
    if (![[picture valueForKey:@"type"] isEqualToString:@"image"])
    {
        return NO;
    }
    
    if ([[picture valueForKeyPath:@"location"] isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    
    return YES;
}


-(void)hasFollowedUser:(CustomAnnotation *)annotation
{
    NSArray *usernames = [_someUser.parsedFollowing valueForKey:@"name"];
    if ([usernames containsObject:annotation.username])
    {
        annotation.userHasFollowed = YES;
    }
    else
    {
        annotation.userHasFollowed = NO;
    }
}


//i.e. Is this a duplicate annotation? etc.
-(NSInteger)checkAnnotationEnums:(CustomAnnotation *)annotation
{
    
    //EXC_BAD_ACCESS here..) (visible was nil)
    // !!!: The problem is when using next button/search we add an extra annotation and idk.. but it's only out of bounds by 1 index so 
    NSSet* visible = [_mapView annotationsInMapRect:[_mapView visibleMapRect]];
//    if (!visible)
    if ([visible count] == 0)
    {
        NSLog(@"CRITICAL ERROR: annotationsInMapRect returned null, continuing even though we shouldn't..");
        return SUCCESS;
    }
    if ([visible count] > MAX_ALLOWED_PICTURES)
    {
        NSLog(@"Detecting flood");
        return FLOOD;
    }
 
    // !!!: NSSetM addobject object can't be nil uncaught exception (on nextButton spam) (on just scrolling...) (on clean up map) (out of bounds as well) (on next Button non spam)
    for (int i = 0; i < [_mapView.annotations count]; i++)
    {
        if (i >= [_mapView.annotations count])
        {
            NSLog(@"ERROR");
            break;
        }
        CustomAnnotation *arrayAnnotation = [_mapView.annotations objectAtIndex:i];
        
        if ([arrayAnnotation isKindOfClass:[MKPointAnnotation class]])
        {
            continue;
        }
        if ([arrayAnnotation isKindOfClass:[MKUserLocation class]])
        {
            continue;
        }
        if ([self annotation:annotation tooCloseTo:arrayAnnotation]) //Change annotation radius for configuring
        {
            return OVERLAP;
        }
        //TODO: Fix Duplicate (cleanUpMap might be cleaning it before we have a chance to detect)
        if ([arrayAnnotation isEqualToAnnotation:annotation])
        {
            NSLog(@"Detecting duplicate");
            return DUPLICATE;
        }
    }
    
    return SUCCESS;
}


#pragma mark - Touches Methods

-(void)tapOutOfSearchBar:(UITouch *)touch
{
    if ([_searchField isFirstResponder] && [touch view] != _searchField) {
        [_searchField resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches began!");
    
    UITouch *touch = [[event allTouches] anyObject];
    
    
    [self tapOutOfSearchBar:touch];
    [super touchesBegan:touches withEvent:event];
    
    if ([[self.view.window hitTest:[touch locationInView:self.view.window] withEvent:event] isKindOfClass:[CustomCallout class]])
    {
        [self stopAnnotationTimer];
        return;
        
    }
    [_picturesChosenByDrag removeAllObjects];
    arrayCounter = 0;
    if([[self.view.window hitTest:[touch locationInView:self.view.window] withEvent:event] isKindOfClass:[MKAnnotationView class]])
    {
        if (tempImageView == nil)
        {
            tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
            [self.view.window addSubview:tempImageView];
        }
        beganInAnnotation = YES;
        lastPoint = [touch locationInView:self.view.window];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (beganInAnnotation)
    {
        UITouch *touch = [[event allTouches] anyObject];
        [self drawLineWithTouch:touch];
    }
    
    
}

-(void)drawLineWithTouch:(UITouch *)touch
{

    CGPoint currentPoint = [touch locationInView:self.view.window];
    
    UIGraphicsBeginImageContext(self.view.window.frame.size);
    [tempImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0 );
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    [tempImageView setAlpha:1];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    beganInAnnotation = NO;
//    tempImageView.image = nil;
    [tempImageView removeFromSuperview];
    tempImageView = nil;

    NSLog(@"Touches ended!");
    UITouch *touch = [[event allTouches] anyObject];
    if ([[self.view.window hitTest:[touch locationInView:self.view.window] withEvent:event] isKindOfClass:[CustomCallout class]])
    {
        [self startAnnotationTimer];
        return;
    }
    arrayCounter = 0;
    if ([_picturesChosenByDrag count] == 1)
    {
        [self displayCallout:[_picturesChosenByDrag objectAtIndex:0]];
    }
    else if ([_picturesChosenByDrag count] > 1)
    {
        [self preloadSingleAnnotation:[[_picturesChosenByDrag firstObject] annotation]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self startPreloadingFrom:_picturesChosenByDrag];
        });
        [self startAnnotationTimer];
    }
    else
    {
        [self deselectAllAnnotations];
    }
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch cancelled!");
    //TODO: Handle phones calls/ interruptions
}


#pragma mark - CalloutView and Timer

-(void)displayCallout:(MKAnnotationView *)view
{
    CustomCallout *calloutView = (CustomCallout *)[[[NSBundle mainBundle] loadNibNamed:@"calloutView" owner:self options:nil] objectAtIndex:0];
    CGRect calloutViewFrame  = calloutView.frame;
    calloutViewFrame.origin = CGPointMake(0,self.view.frame.size.height/6);//CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
    calloutView.frame = calloutViewFrame;
    
    
    CustomAnnotation *someAnnotation = view.annotation;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (someAnnotation.imageEnlarged == nil)
        {
            NSLog(@"Had to load image :(");
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[someAnnotation imageURLEnlarged]]];
            ((CustomAnnotation*)[view annotation]).imageEnlarged = someAnnotation.imageEnlarged = [[UIImage alloc] initWithData:data];
        }
        NSArray *usernames = [_someUser.parsedFollowing valueForKey:@"name"];
        if ([usernames containsObject:someAnnotation.username])
        {
            someAnnotation.userHasFollowed = YES;
        }
        else
        {
            someAnnotation.userHasFollowed = NO;
        }
        NSLog(@"Image was preloaded :)");
        dispatch_async(dispatch_get_main_queue(), ^{
            [calloutView initCalloutWithAnnotation:someAnnotation andImage:someAnnotation.imageEnlarged];
            //[calloutView setUpAnnotationWith:someAnnotation.ownerOfPhoto andLikes:someAnnotation.numberOfLikes andImage:image1 andTime:someAnnotation.timeCreated andMediaID:someAnnotation.mediaID andUserLiked:someAnnotation.userHasLiked andAnnotation:someAnnotation];
            
            //Makes pictures circular
            calloutView.layer.cornerRadius = calloutView.frame.size.height/30;
            calloutView.layer.masksToBounds = YES;
            
            //Makes border
            calloutView.layer.borderWidth = 3.0f;
            calloutView.layer.borderColor = [UIColor purpleColor].CGColor;
            [self animateFadeInAndAddCallOutView:calloutView];
            arrayCounter++;
        });
        
        
    });
    
}

-(void)preloadSingleAnnotation:(CustomAnnotation*)annotation
{
    if (annotation.imageEnlarged == nil)
    {
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[annotation imageURLEnlarged]]];
        annotation.imageEnlarged = [[UIImage alloc] initWithData:data];
    }
}

-(void)startPreloadingFrom:(NSOrderedSet*)source
{
    for (NSUInteger i = 1; i < [source count]; i++)
    {
        MKAnnotationView *curView = [source objectAtIndex:i];
        CustomAnnotation *curAnnotation = curView.annotation;
        [self preloadSingleAnnotation:curAnnotation];
    }
}

dispatch_source_t CreateDispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

- (void)timerFireMethod
{
    // NSDictionary *data = [_myTimer userInfo];
    //NSMutableOrderedSet *myOrderedSet = [data objectForKey:@"WGannotationViewArray"];
    NSLog(@"timerFireMethod called!");
    
    
    if (arrayCounter >= [_picturesChosenByDrag count])
    {
        [self stopAnnotationTimer];
        [self mapView:_mapView didDeselectAnnotationView:[_picturesChosenByDrag lastObject]];
        return;
    }
    
    [self displayCallout:[_picturesChosenByDrag objectAtIndex:arrayCounter]];
    
}

-(void) startAnnotationTimer
{
    if (annotationTimer != nil) // Just in case..
        dispatch_source_cancel(annotationTimer);
    
    annotationTimer = CreateDispatchTimer(SECONDS_PER_PIC * NSEC_PER_SEC, 10ull * NSEC_PER_MSEC, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self performSelectorOnMainThread:@selector(timerFireMethod) withObject:nil waitUntilDone:TRUE];
    });
}

-(void) stopAnnotationTimer
{
    if (annotationTimer != nil)
    {
        dispatch_source_cancel(annotationTimer);
        annotationTimer = nil;
    }
}

#pragma mark - MKAnnotationView methods

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]] || [view.annotation isKindOfClass:[MKPointAnnotation class]])
    {
        //Don't add these types to our array;
        return;
    }
    if (_picturesChosenByDrag == nil)
    {
        _picturesChosenByDrag = [[NSMutableOrderedSet alloc] init];
    }
    NSLog(@"Added to array!");
    [_picturesChosenByDrag addObject:view];
    [(CustomAnnotation *)view.annotation setColorType:[UIColor yellowColor]];
    [self updateTheBorderColorOnViewToMatchTheAnnotationType:view];
}

-(void)deselectAllAnnotations
{
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[CustomCallout class]])
            [subView removeFromSuperview];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    //looping through main view views... only remove of class CustomCallout.
    NSLog(@"DESELECTING ANNOTATION");
    //return;
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[CustomCallout class]])
            [subView removeFromSuperview];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"CustomViewAnnotation";
    
    //MKUserLocation is considered an annotation and we don't want to change that so just return no view
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
        return nil;
    
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        //TODO: Add support for video
        
    }
    else
    {
        //NSLog(@"I must have reused it!");
        annotationView.annotation  = annotation;
    }
    annotationView.image = [(CustomAnnotation *)annotation image];
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO; //Revert to yes later?
    
    //Makes pictures circular
    annotationView.layer.cornerRadius = annotationView.frame.size.height/2;
    annotationView.layer.masksToBounds = YES;
    //TODO: FIX BUG
    //This will turn yellow border back to white should we happen to zoom out too far or scroll the annotation out of view
    annotationView.layer.borderWidth = 3.0f;
    annotationView.layer.borderColor = [UIColor whiteColor].CGColor;
    if ([(CustomAnnotation *)annotation isHashTag] == YES)
    {
        [(CustomAnnotation *)annotationView.annotation setColorType:[UIColor greenColor]];
        annotationView = [self updateTheBorderColorOnViewToMatchTheAnnotationType:annotationView];
        [self.view bringSubviewToFront:annotationView];
    }
    if ([(CustomAnnotation *)annotation isPopular] == YES)
    {
        [(CustomAnnotation *)annotationView.annotation setColorType:[UIColor blueColor]];
        annotationView = [self updateTheBorderColorOnViewToMatchTheAnnotationType:annotationView];
        [self.view bringSubviewToFront:annotationView];
    }
    if ([(CustomAnnotation *)annotation isFriend] == YES)
    {
        [(CustomAnnotation *)annotationView.annotation setColorType:[UIColor redColor]];
        annotationView = [self updateTheBorderColorOnViewToMatchTheAnnotationType:annotationView];
        [self.view bringSubviewToFront:annotationView];
    }
    
    if ([(CustomAnnotation *)annotation shouldDisplayNow] == YES)
    {
        [self displayCallout:annotationView];
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [_mapView getCurrentLocationOfMap];
    if (_mapView.currentLocation.latitude == 0 && _mapView.currentLocation.longitude == 0)
        return;
    
    if (_globalType == POPULAR)
        return; //TODO: Need to recall this method to load
        
    [self performSelector:@selector(loadAnnotationsWhenNecessary) withObject:nil afterDelay:0.3];
    
    //[self loadAnnotationsWhenNecessary];
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    //REVERT HERE FOR NORMAL
    //        [_mapView getCurrentLocationOfMap];
    //        [_mapView getRadius];
    //        NSLog(@"RADIUS: %f", _mapView.radius);
    //
    //        if (_mapView.currentLocation.latitude == 0 && _mapView.currentLocation.longitude == 0)
    //           return;
    //
    //        //if we want all pictures set to all etc etc.
    //        [self selectMethodForType:_globalType];
}


#pragma mark - MKAnnotationView Helper Functions

-(void)updatePicturesBeingDisplayedBasedOnColorOfBorder
{
    //Loop through all our annotation views
    for (MKAnnotationView* annotationView in _mapView.annotations)
    {
        //if our view has a yellow border
        if (annotationView.layer.borderColor == [UIColor yellowColor].CGColor)
        {
            //remove that annotation FOREVER HAHA
            [_mapView removeAnnotation:annotationView.annotation];
        }
    }
}

-(MKAnnotationView *)updateTheBorderColorOnViewToMatchTheAnnotationType:(MKAnnotationView *)annotationView
{
    NSLog(@"Update color");
    annotationView.layer.borderWidth = 3.0f;
    annotationView.layer.borderColor = [(CustomAnnotation *)annotationView.annotation colorType].CGColor;
    
    return annotationView;
}

-(CGPoint)getAnnotationPositionOnMap:(CustomAnnotation *)annotation
{
    return [_mapView convertCoordinate:annotation.coordinate toPointToView:_mapView ];
}

-(CGFloat)getDistanceBetweenCoordinate:(CLLocationCoordinate2D)location1 and:(CLLocationCoordinate2D)location2
{
    CGPoint point1 = [_mapView convertCoordinate:location1 toPointToView:_mapView];
    CGPoint point2 = [_mapView convertCoordinate:location2 toPointToView:_mapView];
    CGFloat dx = point1.x - point2.x;
    CGFloat dy = point1.y - point2.y;
    return sqrt(dx*dx + dy*dy);
}



-(BOOL)annotation:(CustomAnnotation *)annotation1 tooCloseTo:(CustomAnnotation *)annotation2
{
    CGPoint location1 = [self getAnnotationPositionOnMap:annotation1];
    CGPoint location2 = [self getAnnotationPositionOnMap:annotation2];
    CGFloat dx = location1.x - location2.x;
    CGFloat dy = location1.y - location2.y;
    CGFloat distance = sqrt(dx*dx + dy*dy);
    CGFloat maxDistance = ANNOTATION_RADIUS * 1.25;
    return distance < maxDistance;
}

//takes in two annotations and determines if they are too close to eachother
-(BOOL)annotation:(CustomAnnotation *)annotation1 tooCloseTo:(CustomAnnotation *)annotation2 withMaxDistance:(CGFloat)maxDistance
{
    CGPoint location1 = [self getAnnotationPositionOnMap:annotation1];
    CGPoint location2 = [self getAnnotationPositionOnMap:annotation2];
    CGFloat dx = location1.x - location2.x;
    CGFloat dy = location1.y - location2.y;
    CGFloat distance = sqrt(dx*dx + dy*dy);
    return distance < maxDistance;
}



#pragma mark - Formatting UILabel

-(void)configureInfoText:(NSInteger)type
{
    NSString *textType = [self formatTypeToString:type];
    if (_onlyFriends == YES  && ![_type.text isEqualToString:[NSString stringWithFormat:@"• %@   • FRIENDS",textType]])
    {
        NSString *newText = [NSString stringWithFormat:@"• %@   • FRIENDS",textType];
        [self performFadeOnLabel:_type andChangeTextTo:newText withDuration:1.0];
    }
    else if(![_type.text isEqualToString:[NSString stringWithFormat:@"• %@",textType]])
    {
        NSString *newText = [NSString stringWithFormat:@"• %@",textType];
        [self performFadeOnLabel:_type andChangeTextTo:newText withDuration:1.0];
    }
}

- (NSString*)formatTypeToString:(NSInteger)typeInt {
    NSString *result = nil;
    
    switch(typeInt) {
        case 0:
            break;
        case ALL:
            result = @"ALL";
            break;
        case RECENT:
            result = @"RECENT";
            break;
        case POPULAR:
            result = @"POPULAR";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    return result;
}

#pragma mark - Observer Method Selectors

-(void)zoomToRegion:(CLLocationCoordinate2D)coordinate withLatitude:(CLLocationDistance)latitude withLongitude:(CLLocationDistance)longitude withMap:(MKMapView *)map
{
    //Makes a region to zoom into with format of the location with a distance of latitude and longitude... sorry that's a little confusing... Better parameter names would be... (centerLocation, span in lat direction, span in longitude direction)  Make sense now?
    MKCoordinateRegion zoomLocation = MKCoordinateRegionMakeWithDistance(coordinate, latitude, longitude);
    //tell the map to zoom to that location (no animation needed here..)
    [map setRegion:zoomLocation animated:NO];
    [self performSelector:@selector(mapLocationSettled)];
    
}

-(void)zoomStart
{
    [self zoomToRegion:_someUser.currentLocation.coordinate withLatitude:100 withLongitude:100 withMap:_mapView];
    // [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"Zoom to map"];
    
}

-(void)mapLocationSettled
{
    [_mapView getCurrentLocationOfMap];
}












#pragma mark - UITextField (search bar)



-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    _searchData = nil;
    if (_searchData == nil)
    {
        _searchData = [[SearchData alloc] init];

    }
    //TODO: Animate into view
    NSLog(@"Did being editing");
    [self mapView:_mapView didDeselectAnnotationView:nil];
//    _autoCompleteTableView.hidden = NO;
    
}


-(void) textFieldDidEndEditing:(UITextField *)textField
{
    //TODO: Animate out of view
    _autoCompleteTableView.hidden = YES;
}


-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSLog(@"should clear?");
    if (_autoCompleteTableView.hidden == NO)
    {
        [_searchData fillSearchOptionsAvailable:@""];
        [_autoCompleteTableView reloadData];
    }
    else if ([_searchField isFirstResponder])
    {
        textField.text = @"";
    }
    else
    {
        //Clears field without opening keyboard
        textField.enabled = NO;
        [self performSelector:@selector(enableSearchField:) withObject:_searchField afterDelay:.2];
    }
    _searchType = NONE;

    return YES;
}

-(void)enableSearchField:(UITextField *)textField
{
    textField.enabled = YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    _autoCompleteTableView.hidden = YES;
    //TODO: Implement autoCompleteTable (Switch to NO when ready)

    _autoCompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithFormat:_searchField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [_searchData fillSearchOptionsAvailable:substring];
    [_autoCompleteTableView reloadData];

//    [self searchAutoCompleteEntriesWithSubstring:substring];
    
    
    return YES;
}

-(void)searchAutoCompleteEntriesWithSubstring:(NSString *)substring
{
    /*
    [_autoCompleteData removeAllObjects];
    _autoCompleteData = [[NSMutableArray alloc] init];
    _possibleMatches = [[NSMutableArray alloc]init];
    [_possibleMatches addObjectsFromArray:@[@"Sally", @"Will", @"Gautam", @"Tim", @"Lili", @"Theresa"]];
    
    //loop through possible Matches
    for (NSString *curString in _possibleMatches)
    {
        NSRange substringRange = [curString rangeOfString:substring];
    
        if (substringRange.location == 0)
        {
            [_autoCompleteData addObject:curString]; //need to link this to the Table View/CELL
        }
    }
    [_autoCompleteTableView reloadData];
    */
}



-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    [_mapView removeAnnotations:[_mapView annotations]];
//    [self performSearch:textField];
    
    return YES;
}

//Will get an array of locations based on the search prameters.
-(void) performSearch:(UITextField *)textField
{
    //request a search with words from textField
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = textField.text;
    //request.region = _mapView.region; //search results only in currently shown area of map
    
    //make an array to store items of request
    matchingItems = [[NSMutableArray alloc]init];
    
    //do the search
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         if (response.mapItems.count == 0)
         {
             NSLog(@"No matches");
             //TODO: Give error for no matches
         }
         else
         {
             //loop through all results (note: will only go through roughly 10 (restriction based on apple documentation))
             for (MKMapItem *item in response.mapItems)
             {
                 //add to array
                 [matchingItems addObject:item];
                 //place a marker on mapView of location
//                 MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//                 annotation.coordinate = item.placemark.coordinate;
//                 annotation.title = item.name;
//                 [_mapView addAnnotation:annotation];
                 NSLog(@"name = %@", item.name);
                 NSLog(@"Phone = %@", item.phoneNumber);
                 NSLog(@"URL = %@", item.url);
                 NSLog(@"Placemark = %@", item.placemark);
//                 NSLog(@"Coordinate = %@", item.placemark.coordinate);
                 
             }
             //Zoom into the 1st result provided by search
//             MKMapItem *item1 = matchingItems[0];
//             MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(item1.placemark.coordinate, [(CLCircularRegion *)item1.placemark.region radius], [(CLCircularRegion *)item1.placemark.region radius]);
//             [_mapView setRegion:viewRegion animated:YES];
         }
     }];
    
    
}




#pragma mark - Buttons

-(IBAction)nextButton:(UIButton *)button
{
    [self stopAnnotationTimer];
    [_mapView removeAnnotations :_mapView.annotations];
    
    if (_searchType == LOCATION)
    {
        //for now..
        _searchField.text = @"";
        _searchType = 0;
    }
    if (_searchType != 0)
    {
        [_searchData parseDataWithSearchType];
        return;
    }
    
    
    if ([_picturesArray.nextPicturesSet count] > 4)
    {
        [self zoomToPopular];
    }
    else
    {
        [self zoomToPopular];
        
        if (_lockNext == YES)
        {
            return;
        }

        _lockNext = YES;

        
//        int r = arc4random_uniform(2);//Random number 0 or 1
        int r =1; //We'll allows load popular pictures after the 1st 7 pictures that are friends
        if (r == 0)
        {
            _isPopularNotFriend = NO;
            [_picturesArray findFollowingImages];
        }
        else if (r == 1)
        {
            _isPopularNotFriend = YES;
            [_picturesArray findPopularImages];
        }
        //TODO: AND load some more photos
//        [self setGlobalType:POPULAR];
//        [_mapView findPopularImages];
    }
    
    
}

-(void)zoomToPopular //Called by selector in viewDidLoad
{
    if ([_picturesArray.nextPicturesSet count] >= 1)
    {
        CustomAnnotation *myAnnotation = [_picturesArray.nextPicturesSet objectAtIndex:0];
//        CustomAnnotation *myAnnotation = [_picturesArray.nextPicturesSet objectAtIndex:nextPictureSetCounter];
//        nextPictureSetCounter++;
        [self zoomToRegion:myAnnotation.coordinate withLatitude:50 withLongitude:50 withMap:_mapView];
        myAnnotation.shouldDisplayNow = YES;
        [_mapView addAnnotation:myAnnotation];
//        [self mapView:_mapView didSelectAnnotationView:<#(MKAnnotationView *)#>
        [_picturesArray.nextPicturesSet removeObjectAtIndex:0];
    
    }
    else if([_picturesArray.nextPicturesSet count] == 0)
    {
        NSLog(@"No more pictures!");
    }
//    else if ([_picturesPopular count] == 0)
//    {
//        NSLog(@"No more popular photos in my array Load more");
////        _picturesPopular = nil;
////        _picturesPopular = [[NSMutableOrderedSet alloc] init];
//        [self setGlobalType:POPULAR];
//        //[[NSNotificationCenter defaultCenter] postNotificationName:@"We should load data" object:nil];
//        [_mapView findPopularImages];
//        
//    }
//    else if (_picturesPopular == nil)
//    {
//        NSLog(@"No more popular photos in my array Load more");
//        _picturesPopular = [[NSMutableOrderedSet alloc] init];
//        [self setGlobalType:POPULAR];
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"We should load data" object:nil];
//
//        [_mapView findPopularImages];
//    }
//    else
//    {
//        //????
//        NSLog(@"What.");
//    }
    
}


-(IBAction)friendsButton:(UIButton *)button
{
    SideMenuViewController *sideMenu = [[SideMenuViewController alloc] init];
    
    //[self presentViewController:sideMenu animated:YES completion:nil];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.mapVC presentViewController:sideMenu animated:YES completion:nil];
}




//-(void)loadAnnotationsWhenNecessary
//{
//    //    get current location
//    CLLocationCoordinate2D currLocation = [_mapView currentLocation];
//    //    if _prevGeoCoord not initialized, set it equal to the current location
//    if(!CLLocationCoordinate2DIsValid(_prevGeoCoord)){
//        _prevGeoCoord = _prevDataCoord = currLocation;
//        return;
//    }
//    //    get the distance between the previous geo coordinate and the current location
//    //    if this distance is greater than a third the width of the map view, set _prevGeoCoord to currentLocation and search for new annotations
//    //    TODO: figure out a better max distance before searching for new photos, maybe account for vertical and horizontal movement differently too account for scrolling upwards
//    CGFloat distance = [self getDistanceBetweenCoordinate:_prevGeoCoord and:currLocation];
//    if(distance > self.view.frame.size.width/3)
//    {
//        _prevGeoCoord = _prevDataCoord = [_mapView currentLocation];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"We should load data" object:self];
//        //[self selectMethodForType:_globalType];
//    }
//    //    TODO: find a better time/way to call the geocoding service, or work on implementing mapquest/google maps apis with higher limits
//    if(distance > self.view.frame.size.width * 3)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Load Geo" object:self];
//    }
//}


-(void)loadAnnotationsWhenNecessary
{
    if ([_mapView.annotations count] <= 2)
    {
        [_mapView getCurrentLocationOfMap];
        //load some pictures
        [_mapView getRadius];
        NSLog(@"RADIUS: %f", _mapView.radius);
        
        if (_mapView.currentLocation.latitude == 0 && _mapView.currentLocation.longitude == 0)
            return;
        
        //if we want all pictures set to all etc etc.
        //[self selectMethodForType:_globalType];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Load Geo" object:self];
        _prev_zoomLevel = [self getDistanceInMetersFromCenterOfScreenToTop];
        _prevGeoCoord = _prevDataCoord = [_mapView currentLocation];
        return;
    }
    
    [_mapView getCurrentLocationOfMap];
    [_mapView getRadius];
    
    //CLLocationCoordinate2D centerPoint = _mapView.currentLocation;
    double panDelta = fabs([self getMetersBetweenTwoPoints:[_mapView currentLocation] pointTwo:_prevGeoCoord]);
    double temp_panDelta = fabs([self getMetersBetweenTwoPoints:[_mapView currentLocation] pointTwo:_prevDataCoord]);
    double zoomDelta = fabs([self getDistanceInMetersFromCenterOfScreenToTop] - _prev_zoomLevel);
    
    panDelta *= [self getDistanceInMetersFromCenterOfScreenToTop] / SCALE_FACTOR;
    temp_panDelta *= [self getDistanceInMetersFromCenterOfScreenToTop] / SCALE_FACTOR;
    
    
    double currentZoomLevel = [self getDistanceInMetersFromCenterOfScreenToTop];
    NSLog(@"Level of Zoom: %f", currentZoomLevel);
    
    NSLog(@"Difference Pan: %f",panDelta);
    NSLog(@"Difference Zoom: %f ", zoomDelta);
    
    if (_mapView.currentLocation.latitude == 0 && _mapView.currentLocation.longitude == 0)
        return;
    
    //Handle Pan Over Great Distance
    if (panDelta > LOAD_GEO_PAN_THRESHOLD) //&& topToCenter > SOME_RATIO_ZOOM)
    {
        NSLog(@"Loading Geo");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Load Geo" object:self];
        _prev_zoomLevel = [self getDistanceInMetersFromCenterOfScreenToTop];
        _prevGeoCoord = _prevDataCoord = [_mapView currentLocation];
        return;
    }
    
    
    if (currentZoomLevel < 150)
    {
        if (panDelta > LOAD_DATA_LOWER)
        {
            NSLog(@"Loading Pictures on Pan lower");
            _prevDataCoord = [_mapView currentLocation];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"We should load data" object:self];
            return;
        }
    }
    else if (currentZoomLevel > 5000)
    {
        if (panDelta >LOAD_DATA_UPPER)
        {
            NSLog(@"Loading Pictures on Pan lower");
            _prevDataCoord = [_mapView currentLocation];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"We should load data" object:self];
            return;
        }
    }
    
    if (temp_panDelta > LOAD_DATA_PAN_THRESHOLD)
    {
        NSLog(@"Loading Pictures based on Pan");
        _prevDataCoord = [_mapView currentLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"We should load data" object:self];
    }
    //Handle Zoom
    else if (zoomDelta > LOAD_DATA_ZOOM_THRESHOLD) //&& annotationToTop > SOME_RATIO_PAN)
    {
        NSLog(@"Loading Pictures based on Zoom");
        _prev_zoomLevel = [self getDistanceInMetersFromCenterOfScreenToTop];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"We should load data" object:self];
    }
    
}


//Will return an absolute value
-(double)getMetersBetweenTwoPoints:(CLLocationCoordinate2D)coordinate1 pointTwo:(CLLocationCoordinate2D)coordinate2
{
    
    return MKMetersBetweenMapPoints(MKMapPointForCoordinate(coordinate1), MKMapPointForCoordinate(coordinate2));
}


-(double)getDistanceInMetersFromCenterOfScreenToTop
{
    [_mapView getCurrentLocationOfMap];
//    CLLocationCoordinate2D centerPoint = _mapView.currentLocation;
//    CLLocationCoordinate2D topPoint = [_mapView getTopCenterCoordinate];
    MKMapPoint centerPoint = MKMapPointForCoordinate([_mapView currentLocation]);
    MKMapPoint topPoint = MKMapPointForCoordinate([_mapView getTopCenterCoordinate]);
    
    

    double dist = MKMetersBetweenMapPoints(topPoint, centerPoint);
    
    return dist;
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchData.autoCompleteSearchData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //FOR custom cell later
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //TODO: if user.. if hashtag... if location
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    BaseDisplay *baseDisplay = [_searchData.autoCompleteSearchData objectAtIndex:indexPath.row];
    cell.textLabel.text = baseDisplay.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseDisplay *baseDisplay = [_searchData.autoCompleteSearchData objectAtIndex:indexPath.row];
    
    if ([_searchField.text isEqualToString:@""])
    {
        [self textFieldDidEndEditing:_searchField];
        [_searchField resignFirstResponder];
        return;
    }
    if (! ([baseDisplay.name rangeOfString:@"No matches found"].location == NSNotFound))
    {
        _searchField.text = @"";
        [self textFieldDidEndEditing:_searchField];
        [_searchField resignFirstResponder];
        return;
    }
    
    if (! ([baseDisplay.name rangeOfString:@"Search for users"].location == NSNotFound))
    {
        NSLog(@"Search for users selected");
        //TODO: load user possibilities
        
        [_searchData fillAutoCompleteSearchDataWithUsers:_searchField.text withArrayOfFollowing:_someUser.parsedFollowing];
        _searchType = USER;
        
    }
    else if (! ([baseDisplay.name rangeOfString:@"Search for hashtags"].location == NSNotFound))
    {
        NSLog(@"Search for hashtags selected");
        //TODO: load hashtag possibilties
        
        [_searchData fillAutoCompleteSearchDataWithHashTags:_searchField.text];
        _searchType = HASHTAG;
    }
    else if (! ([baseDisplay.name rangeOfString:@"Search for locations"].location == NSNotFound))
    {
        NSLog(@"Search for locations selected");
        //TODO: load location possibilities
        
//        [self performSearch:_searchField];
        [_searchData fillAutoCompleteSearchDataWithLocations:_searchField.text];
        _searchType = LOCATION;
    }
    else
    {
        NSString *string = [self getStringAtRow:indexPath.row];
        [self placeSelectionInSearch:string];
        
        //TODO: hide tableview and keyboard and do search
        [self textFieldShouldReturn:_searchField];
        //use _searchType to determine type for now
        [self selectSearchMethod:_searchType withSearchText:string andRow:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [_autoCompleteTableView performSelector:@selector(reloadData) withObject:nil afterDelay:.5]; //To simulate actually loading
//    [tableView reloadData]; //TODO: do this after data done loading instead

}

-(void)selectSearchMethod:(NSInteger)searchType withSearchText:(NSString *)searchText andRow:(NSInteger)row
{
    if (searchType == USER)
    {
        UserDisplay *display = [_searchData.autoCompleteSearchData objectAtIndex:row];
        [_searchData searchUsernameWithName:display.userID];
    }
    else if (searchType == HASHTAG)
    {
        HashDisplay *display = [_searchData.autoCompleteSearchData objectAtIndex:row];
        [_searchData searchHashTagWithName:display.name];
    }
    else if (searchType == LOCATION)
    {
        LocationDisplay *display = [_searchData.autoCompleteSearchData objectAtIndex:row];
        [_searchData searchLocationWithLocation:display.item];
        // ???: can later make it so next will take them to pictures within that area (currently just zooms there)
    }
}

-(NSString *)getStringAtRow:(NSInteger)row
{
    BaseDisplay *baseDisplay = [_searchData.autoCompleteSearchData objectAtIndex:row];
    NSString *theString = baseDisplay.name;
    return theString;
}

-(void)placeSelectionInSearch:(NSString *) text
{
    _searchField.text = text;
}

#pragma mark -Parse Location

-(void)parseStringOfLocation:(CLLocationCoordinate2D) location
{
    CLLocation *coordinate = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
    
    if(coordinate.coordinate.latitude == 0 && coordinate.coordinate.longitude == 0)
    {
        return;
        //Error protect
    }
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:coordinate completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!error)
         {
             //DO SOMETHING HERE
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"Current Location Detected");
             // NSLog(@"placemark %@", placemark);
            // NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            // NSString *address = [[NSString alloc] initWithString:locatedAt];
             //NSString *area = [[NSString alloc]initWithString:placemark.locality];
            // NSString *country = [[NSString alloc] initWithString:placemark.country];
             //NSLog(@"%@, %@, %@", address, area, country);
             
             if (placemark.locality == nil)
             {
                 _currentMapViewGeoLocation = [NSString stringWithFormat:@"%@, %@", placemark.administrativeArea, placemark.country];
             }
             else
             {
                _currentMapViewGeoLocation = [NSString stringWithFormat:@"%@, %@",placemark.locality, placemark.administrativeArea];
             }
             
             NSLog(@"LOCATION: %@",_currentMapViewGeoLocation);
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"Images Loaded" object:self];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"We should load data" object:self];
             
         }
         else
         {
             //HANDLE ERROR
             NSLog(@"Geocode failed with error %@", error);
             
             //TODO: fix this.. for now we'll just go to loading
             [[NSNotificationCenter defaultCenter] postNotificationName:@"We should load data" object:self];
             //[self selectMethodForType:_globalType];
             
         }
     }];
    
    
}


#pragma mark - Animations

-(void)animateFadeInAndAddCallOutView:(CustomCallout *)calloutView
{
    [calloutView setAlpha:0];
    [self.view addSubview:calloutView];
    [UIView beginAnimations:nil context:nil];
    [calloutView setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        float randomFloat = [self randomFloatBetween:.8 and:1.3];
        [self animateDropFromTop:aV view:views withDuration:randomFloat];
    }
}

-(void)animateLabelFade:(UILabel *)label toAlpha:(float)newAlphaVal withDuration:(float)duration
{
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ _type.alpha = newAlphaVal;}
                     completion:nil];
}

-(void)performFadeOnLabel:(UILabel *)label andChangeTextTo:(NSString *)newText withDuration:(float)duration
{
    [self animateLabelFade:label toAlpha:0 withDuration:duration/2];
    label.text = newText;
    [self animateLabelFade:label toAlpha:1 withDuration:duration/2];
}


-(void)animateFade: (MKAnnotationView *)aV withDuration:(float)duration {
    CGRect endFrame = aV.frame;
    [aV setAlpha:0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [aV setAlpha:1.0];
    [UIView commitAnimations];
    aV.frame = endFrame;
}

-(void)animateDropFromTop: (MKAnnotationView *)aV view:(NSArray *)views withDuration:(float)duration {
    CGRect endFrame = aV.frame;
    
    // Move annotation out of view
    aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
    
    // Animate drop
    [UIView animateWithDuration: duration delay:0.04*[views indexOfObject:aV] options: UIViewAnimationOptionCurveLinear animations:^{
        
        aV.frame = endFrame;
        
        // Animate squash
    }completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.05 animations:^{
                aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                
            }completion:^(BOOL finished){
                if (finished) {
                    [_onDropSound setCurrentTime:0];
                    [_onDropSound play];
                    NSLog(@"SOUND SHOULD HAVE PLAYED");
                    [UIView animateWithDuration:0.1 animations:^{
                        aV.transform = CGAffineTransformIdentity;
                    }];
                }
            }];
        }
    }];
}

#pragma mark - Math Functions

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}



#pragma mark - Setter Methods

//our own custom setters

-(void)setPicturesChosenByDrag:(NSMutableOrderedSet *)picturesChosenByDrag
{
    if (_picturesChosenByDrag == nil)
    {
        _picturesChosenByDrag = [[NSMutableOrderedSet alloc] init];
    }
    _picturesChosenByDrag = picturesChosenByDrag;
}

-(void)setGlobalType:(NSInteger)globalType
{
    _globalType = globalType;
    [self configureInfoText:_globalType];
    
}

-(void)setOnlyFriends:(BOOL)onlyFriends
{
    _onlyFriends = onlyFriends;
    [self configureInfoText:_globalType];
}


#pragma mark- New functions

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}




#pragma mark- NOT BEING USED (Saved for later)


//Start the location manager, get the current location, and then zoom  into that location.
-(void) zoomMapToCurrentRegion
{
    [self startLocationManager];
    CLLocationCoordinate2D zoomLocation = [currentLocation coordinate];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, METERS_PER_MILE, METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
}
//will alloc and init a new Location manager and then start it, there are settings that adjust the distance and accuracy of the manager.  Set delegate to self.
-(void) startLocationManager
{
    //create a CLLocationManager
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; //can change filter distance later
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}


//NOT BEING USED RIGHT NOW. FOR LATER NOTIFICATIONS
//After starting Location manager, this will update locations VERY precisely, use this for things like sending a sound/whatever when a user passes a landmark or moment that another friend has taken
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    currentLocation = [locations objectAtIndex:0];
    NSLog(@"%f",currentLocation.coordinate.latitude);
    NSLog(@"%f",currentLocation.coordinate.longitude);
    [locationManager stopUpdatingLocation];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!error)
         {
             //DO SOMETHING HERE
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"Current Location Detected");
             NSLog(@"placemark %@", placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *address = [[NSString alloc] initWithString:locatedAt];
             NSString *area = [[NSString alloc]initWithString:placemark.locality];
             NSString *country = [[NSString alloc] initWithString:placemark.country];
             NSLog(@"%@, %@, %@", address, area, country);
             
         }
         else
         {
             //HANDLE ERROR
             NSLog(@"Geocode failed with error %@", error);
         }
     }];
    
    
    //FOR REFERENCE: MORE DATA THAT CAN BE OBTAINED
    /*
     placemark.region, placemark.country, .locality, .name, .ocean, .postalCode, .subLocality, .location, etc.
     */
    
}

-(void)selectMethodForType:(NSInteger)type __deprecated_msg("do a postNotification to - We should load data - instead")
{
    // NSLog(@"Radius: %f", _mapView.radius);
    if (type == ALL)
    {
        NSLog(@"ALL");
        [_mapView findAllImagesOnMapInRange:(_mapView.radius/1.5) inLatitude:_mapView.currentLocation.latitude andLongitude:_mapView.currentLocation.longitude];
    }
    else if (type == RECENT)
    {
        NSLog(@"RECENT");
        [_mapView findRecentImagesOnMapInRange:(_mapView.radius/1.5) inLatitude:_mapView.currentLocation.latitude andLongitude:_mapView.currentLocation.longitude];
    }
    
}

-(void)cleanUpTimer __deprecated
{
    //Start the cleanup process on a timer, separate thread
    //    // Create a dispatch source that'll act as a timer on the concurrent queue
    //    dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    //    double interval = 20.0;
    //    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 0);
    //    uint64_t intervalTime = (int64_t)(interval * NSEC_PER_SEC);
    //    dispatch_source_set_timer(dispatchSource, startTime, intervalTime, 0);
    //    // Attach the block you want to run on the timer fire
    //    dispatch_source_set_event_handler(dispatchSource, ^{
    //        [_mapView cleanupMap];
    //    });
    //    dispatch_resume(dispatchSource);
}

//GO UP THESE METHODS ARE NOT BEING USED

@end

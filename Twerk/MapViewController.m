//
//  MapViewController.m
//  Picto
//
//  Created by William Gu on 7/2/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//
#include <mach/mach.h>
#include <mach/mach_time.h>
#import "MapViewController.h"
#import "CameraAppViewController.h"
#import "User.h"
#import "WGMap.h"
#import "WGPhoto.h"
#import "CustomAnnotation.h"
#import "CustomCallout.h"
#import <QuartzCore/QuartzCore.h>

const NSInteger METERS_PER_MILE = 1609.344;

enum {
    ALL = 1,
    RECENT = 2,
    POPULAR = 3,
    
};
typedef NSInteger Type;

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
}


@property (weak, nonatomic) IBOutlet UITableView *autoCompleteTableView;
@property (strong, nonatomic) User *someUser;

@property (strong, nonatomic) WGPhoto *someData; //???
@property (strong, nonatomic) UIImagePickerController *mediaPicker;
@property (strong, nonatomic) UIImage *chosenImage;


@property (nonatomic) BOOL isMatch;

@end

@implementation MapViewController


//Need to change this method to support when pictures go off map and to make it non immediate
//Add method to mapFullyRendered when ready probably
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

-(void)updateTheBorderColorOnViewToMatchTheAnnotationType:(MKAnnotationView *)annotationView
{
    NSLog(@"Update color");
    annotationView.layer.borderWidth = 3.0f;
    annotationView.layer.borderColor = [(CustomAnnotation *)annotationView.annotation colorType].CGColor;
    
    
}


-(void)setPicturesChosenByDrag:(NSMutableOrderedSet *)picturesChosenByDrag
{
    if (_picturesChosenByDrag == nil)
    {
        _picturesChosenByDrag = [[NSMutableOrderedSet alloc] init];
    }
    _picturesChosenByDrag = picturesChosenByDrag;
}




//our own custom setter
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

-(void)configureInfoText:(NSInteger)type
{
    NSString *textType = [self formatTypeToString:type];
    if (_onlyFriends == YES)
    {
        _type.text = [NSString stringWithFormat:@"• %@   • FRIENDS",textType];
    }
    else
    {
        _type.text = [NSString stringWithFormat:@"• %@",textType];
    }
}

#pragma mark -Helper functions

- (NSString*)formatTypeToString:(NSInteger)typeInt {
    NSString *result = nil;
    
    switch(typeInt) {
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

-(void)zoomToRegion:(CLLocationCoordinate2D)coordinate withLatitude:(CLLocationDistance)latitude withLongitude:(CLLocationDistance)longitude withMap:(MKMapView *)map
{
    //Makes a region to zoom into with format of the location with a distance of latitude and longitude... sorry that's a little confusing... Better parameter names would be... (centerLocation, span in lat direction, span in longitude direction)  Make sense now?
    MKCoordinateRegion zoomLocation = MKCoordinateRegionMakeWithDistance(coordinate, latitude, longitude);
    //tell the map to zoom to that location (no animation needed here..)
    [map setRegion:zoomLocation animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Can Find Location" object:self];
    
}

-(void)mapLocationSettled
{
    [_mapView getCurrentLocationOfMap];
}

-(void)selectMethodForType:(NSInteger)type
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
    else if (type == POPULAR)
    {
        NSLog(@"POPULAR");
    }
}

-(void)loadFollowing
{
    [_someUser retrieveWhoUserIsFollowingFromIG];
}

-(void)parseFollowing
{
    _someUser.parsedFollowing = [[NSMutableArray alloc] init];
    for (id userData in _someUser.following)
    {
        NSString *userID = [userData valueForKeyPath:@"username"];
        [_someUser.parsedFollowing addObject:userID];
    }
    
}

-(void)loadPictures
{
    [self loadAll];
}

-(void)loadAll
{
    //do all this stuff in a different thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (id pictureURL in _mapView.possiblePics)
        {
            //TODO: filtering here
            if (_onlyFriends == YES)
            {
                NSString *pictureIDUser = [pictureURL valueForKeyPath:@"user.username"];
                NSLog(@"PICTURE FRIEND: %@",pictureIDUser);
                    
                if ([_someUser.parsedFollowing containsObject:pictureIDUser] == YES)
                {
                    NSLog(@"MATCHED!");
                    
                }
                else
                {
                    continue;
                }
            
            }
            
            
            
            //path find to thumbnail image... might want to do this in the modal.. NOT SURE. Will get back to you guys.
            NSString *stringURL = [pictureURL valueForKeyPath:@"images.thumbnail.url"];
            NSString *stringURLEnlarged = [pictureURL valueForKeyPath:@"images.standard_resolution.url"];
            NSLog(@"url: %@,", stringURLEnlarged);;
            //Apparently instagram API returns strings or some other id to lat and long.  We'll need CLLocationDegrees however...
            NSString *lat1 = [pictureURL valueForKeyPath:@"location.latitude"];
            NSString *lng1 = [pictureURL valueForKeyPath:@"location.longitude"];
            
            //Convert to CLLocationDegrees (which is a double)
            CLLocationDegrees lat = [lat1 doubleValue];
            CLLocationDegrees lng = [lng1 doubleValue];
            
            //CONVERT from CLLocationDegrees TO CLLocationCoordinate2D
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lng);
            
            NSString *owner = [pictureURL valueForKeyPath:@"user.full_name"];
            NSString *likes = [pictureURL valueForKeyPath:@"likes.count"];
            
            NSString *createdTime = [pictureURL valueForKeyPath:@"created_time"];
            NSString *mediaID = [pictureURL valueForKeyPath:@"id"];
            NSString *userHasLiked = [pictureURL valueForKey:@"user_has_liked"];
            NSLog(@"USER LIKED?: %@", userHasLiked);
            //Save this object in an array of currently displayed photos
            WGPhoto *photo = [[WGPhoto alloc] initWithLocation:location andImageURL:stringURL andEnlarged:stringURLEnlarged andOwner:owner andLikes:likes andTime:createdTime andMediaID:mediaID andUserLiked:userHasLiked];
            CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithPhoto:photo];
            //OR save object as video WGVideo subclass.. (not made yet)
            [annotation createNewImage];
            
            //[_mapView.actualPics addObject:photo]; //THIS IS NOT BEING USED RIGHT NOW. WE Probably won't need this as all annotations are placed in _mapView.annotations (an NSArray) anyways..
            //Although we may want to create an array of annotations then add the array of annotations all at once instead of one by one.  addAnnotations:(NSArray *)array
            //annotationsInMapRect:
          /*
           showAnnotations:animated:
            Sets the visible region so that the map displays the specified annotations.
            
            - (void)showAnnotations:(NSArray *)annotations animated:(BOOL)animated
            */
            
            //do this when done loading.. on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView addAnnotation:annotation]; //THIS adds an annotation to _mapView.annotations
                //[self addAnnotationWithWGPhoto:photo]; REVERT HERE 1.0
                //mapView viewForAnnotation should be automatically called now.. -> (JK. )
            });
            
            
            
        }
    });
}

-(void)loadPopular
{
    
}

-(void)placePicturePin:(WGPhoto *)image
{
    //cool animations anytime bro
    
    //place annotation
    
    
}



;
#pragma mark - Main Lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //if holding and on an annotation, call the mapView, didSelectAnnotation method
    //if holding and off annotation, call the mapView, didUnselectAnnotation method
    //... if user taps an annotation it should zoom in. so in didSelectAnnotation (detect if touch is tap to just return)... we'll define our own custom behavior in another method.
    UITouch *touch = [[event allTouches] anyObject];
    
    //if (_displayingPictures == YES)
    //{
     //   return;
    //}
    //[_picturesUserHasSelectedWithDragTouch removeAllObjects]; //CHECK THIS LOGIC
    
    if ([[self.view.window hitTest:[touch locationInView:self.view.window] withEvent:event] isKindOfClass:[CustomCallout class]])
    {
        NSLog(@"Began at Callout!");
        //
        // [self pausePhotoShowing];
        [self pauseTimer];
        return;
        
    }
    
    
    [_picturesChosenByDrag removeAllObjects];
    arrayCounter = 0;
    
    if([[self.view.window hitTest:[touch locationInView:self.view.window] withEvent:event] isKindOfClass:[MKAnnotationView class]])
    {
        //This is MKAnnotation! COOL
        NSLog(@"Began at annotation!");
        //Makes border
        //View Did select annotation view... (so go to that delegate)
        
    }
    
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
    if([[self.view.window hitTest:[touch locationInView:self.view.window] withEvent:event] isKindOfClass:[MKAnnotationView class]])
    {
        //This is MKAnnotation! COOL
        NSLog(@"Moved to annotation");
        //View did select annotation view... (so go to that delegate)
    }
    //if([[self hitTest:[touch locationInView:self] withEvent:event] isKindOfClass:[MyView class]])
    //{
        //hurrraaay! :)
   // }
    
    /*
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:_mapView.annotations];
        
    for (UIView *view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[MyCustomView class]] &&
            CGRectContainsPoint(view.frame, touchLocation))
        {
                
        }
    }
     */
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"Touches ended!");
    
     UITouch *touch = [[event allTouches] anyObject];
    if ([[self.view.window hitTest:[touch locationInView:self.view.window] withEvent:event] isKindOfClass:[CustomCallout class]])
    {
        [self resumeTimer];
        return;
        /*
        NSLog(@"Touch ended at CustomCallout");
        if ([_picturesChosenByDrag count] >= 1) //protection is good
        {
            [self performSelector:@selector(testVersion:) withObject:[_picturesChosenByDrag objectAtIndex:0]];
        }
        return;
        */
    }
    
    //put NSMUtableArray into NSMutableOrderedSet and display that set of pictures
   // NSLog(@"MY ARRAY: %@",_picturesUserHasSelectedWithDragTouch);
   // NSMutableOrderedSet *mySet = [[NSMutableOrderedSet alloc] initWithArray:_picturesUserHasSelectedWithDragTouch];
   // NSLog(@"MY SET: %@",mySet);
    //[self displayAnnotationCalloutWithSetOfAnnotationViews:mySet];
    //[self displayAnnotationCalloutWithSetOfAnnotationViews:_picturesChosenByDrag];
    
    
    //[self determineWhetherToDisplayAnotherAnnotationOrDeselect];
    
    arrayCounter = 0;
    [self timerBasedAnnotationDisplay];
}

-(void)timerBasedAnnotationDisplay
{
    
    //NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              _picturesChosenByDrag, @"WGannotationViewArray",
                              /* ... */
                              //nil];
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    [_myTimer fire]; //Fire the first one immediately
    [_myTimer setTolerance:0];
}

- (void)timerFireMethod:(NSTimer *)timer
{
   // NSDictionary *data = [_myTimer userInfo];
    //NSMutableOrderedSet *myOrderedSet = [data objectForKey:@"WGannotationViewArray"];
    
    
    
    if (arrayCounter == [_picturesChosenByDrag count])
    {
        [_myTimer invalidate];
        _myTimer = nil;
        double delayInSeconds = .25;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           [self mapView:_mapView didDeselectAnnotationView:[_picturesChosenByDrag lastObject]];
        });
        //[self mapView:_mapView didDeselectAnnotationView:[_picturesChosenByDrag lastObject]];
        return;
    }
    
    [self displayCallout:[_picturesChosenByDrag objectAtIndex:arrayCounter]];
    
}

-(void)displayCallout:(MKAnnotationView *)view
{
    CustomCallout *calloutView = (CustomCallout *)[[[NSBundle mainBundle] loadNibNamed:@"calloutView" owner:self options:nil] objectAtIndex:0];
    CGRect calloutViewFrame  = calloutView.frame;
    calloutViewFrame.origin = CGPointMake(0,self.view.frame.size.height/6);//CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
    calloutView.frame = calloutViewFrame;
    
    
    CustomAnnotation *someAnnotation = view.annotation;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[someAnnotation imageURLEnlarged]]];
    UIImage *image1 = [[UIImage alloc] initWithData:data];
    
    
    [calloutView setUpAnnotationWith:someAnnotation.ownerOfPhoto andLikes:someAnnotation.numberOfLikes andImage:image1 andTime:someAnnotation.timeCreated andMediaID:someAnnotation.mediaID andUserLiked:someAnnotation.userHasLiked andAnnotation:someAnnotation];
    
    //Makes pictures circular
    calloutView.layer.cornerRadius = calloutView.frame.size.height/30;
    calloutView.layer.masksToBounds = YES;
    
    //Makes border
    calloutView.layer.borderWidth = 3.0f;
    calloutView.layer.borderColor = [UIColor purpleColor].CGColor;
    
    [self animateFadeInAndAddCallOutView:calloutView];
    
    arrayCounter++;
}

-(void)pauseTimer
{
    [_myTimer invalidate];
    _myTimer = nil;
}

-(void)resumeTimer
{
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    [_myTimer fire]; //Fire the first one immediately
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch cancelled!");
}


-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //make sure there is a camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    }
    
    //assigning delegates and stuff.
    _searchField.delegate = self;
    _mapView.delegate = self;
    
    //there is a hidden TableView in our window for the search later
    _autoCompleteTableView.hidden = YES;
    _autoCompleteTableView.delegate = self;
    _autoCompleteTableView.dataSource = self;
    _autoCompleteTableView.scrollEnabled = YES;

    
    
    //TESTING
    _someUser = [[User alloc] init];
    [self loadFollowing];
    
    //After sending these messages there is a slight delay to when the delegate actually places the data in the array... will need a way to fix this (let user know they can't do anything yet/ tell controller to wait till data has loaded.
  //  [_someUser retrieveFollowersFromIG];
    
    
    /* Data Flow:  1. Wait for map to zoom into our current location, 2. get that location, 3. load the pictures at the position, 4. show those pictures... (continue steps 2-4 as user moves around map (new input)) */
    
    //Tell our VC to watch for a notification called "Can Find Location" and call mapLocationFound when done
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapLocationSettled) name:@"Can Find Location" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseFollowing) name:@"CanParseFollowing" object:nil];
    
    //Tell our VC to watch for a notification called "Location Found" and call findAll... when done
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findAllImagesOnMapInRange:inLatitude:andLongitude:) name:@"Location Found" object:nil];*/ //this operation is assumed to be fast so we probably don't need this
    
    //Tell our VC to watch for a notification called "Images Loaded" and call loadAllPictures when heard.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPictures) name:@"Images Loaded" object:nil];
    
    //By default set the type of pictures to display as all
    _globalType = ALL;
    //TODO: Load the user's last saved state
    _onlyFriends = NO;
    
    
    
    
}

-(void)viewDidUnload
{
    //remove the observers if we leave this view
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Can Find Location" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Images Loaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CanParseFollowing" object:nil];
}



-(void)viewDidAppear:(BOOL)animated
{
    [_someUser getCurrentLocationOnMap:_mapView]; //get location of user
    //zoom to user location on map
    CLLocationDistance lat = 50;
    CLLocationDistance lng = 50;
    
    //TODO: FIX THIS
    //IF LOCATION = 0.00, 0.00 (Lat/lng) WAIT.
    if (_someUser.currentLocation.coordinate.latitude == 0 && _someUser.currentLocation.coordinate.longitude == 0)
    {
        NSLog(@"Tell me something happened");
        _someUser.currentLocation.coordinate = CLLocationCoordinate2DMake(40, -98); //Approx location center USA
        lat = 1000000;
        lng = 1000000;
        
    }
    
    
    //TODO: make so that it only zooms at start of session.
    [self zoomToRegion:_someUser.currentLocation.coordinate withLatitude:lat withLongitude:lng withMap:_mapView];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField (search bar)

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _autoCompleteTableView.hidden = NO;
    /*
    NSString *substring = [NSString stringWithFormat:_searchField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutoCompleteEntriesWithSubstring:substring];
    
     */
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

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    _autoCompleteTableView.hidden = YES;
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
                 MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                 annotation.coordinate = item.placemark.coordinate;
                 annotation.title = item.name;
                 [_mapView addAnnotation:annotation];
                 NSLog(@"name = %@", item.name);
                 NSLog(@"Phone = %@", item.phoneNumber);
                 NSLog(@"Placemark = %@", item.placemark);
                // NSLog(@"Coordinate = %@", item.placemark.coordinate);
                 
             }
             //Zoom into the 1st result provided by search
             MKMapItem *item1 = matchingItems[0];
             MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(item1.placemark.coordinate, [(CLCircularRegion *)item1.placemark.region radius], [(CLCircularRegion *)item1.placemark.region radius]);
             [_mapView setRegion:viewRegion animated:YES];
         }
     }];
    
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_mapView removeAnnotations:[_mapView annotations]];
    [self performSearch:textField];
    
    return YES;
}


#pragma mark - Buttons

-(IBAction)nextButton:(UIButton *)button
{
    //TODO: Implement next button!
    //Bring user to next relevant location to explore more pictures;
}

-(IBAction)friendsButton:(UIButton *)button
{
    SideMenuViewController *sideMenu = [[SideMenuViewController alloc] init];
    [self presentViewController:sideMenu animated:YES completion:nil];
}


#pragma mark - Display Annotation View/Callout


-(void)determineWhetherToDisplayAnotherAnnotationOrDeselect
{
    if ([_picturesChosenByDrag count] >= 1)
    {
        [self performSelector:@selector(testVersion:) withObject:[_picturesChosenByDrag objectAtIndex:0] afterDelay:1];
    }
}

-(void)fireOffTimer
{
   
}

-(void)pausePhotoShowing
{
    NSLog(@"TRYING TO PAUSE: ");
    
    //Targets all NSObject so be careful with using selectors now.
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //Give user some UI feedback as to paused
    
    
    
    /*
     
    //touches will NSNotify to here
    if ([_picturesChosenByDrag count] == 1)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    else
    {
        //[NSObject cancelPreviousPerformRequestsWithTarget:[_picturesChosenByDrag objectAtIndex:0]];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        //[NSObject cancelPreviousPerformRequestsWithTarget:[_picturesChosenByDrag objectAtIndex:0] selector:@selector(testVersion:) object:[_picturesChosenByDrag objectAtIndex:0]];
    }
    */
    //touches ended will handle pushing to next picture
}

-(void)testVersion:(MKAnnotationView *)view
{
    CustomCallout *calloutView = (CustomCallout *)[[[NSBundle mainBundle] loadNibNamed:@"calloutView" owner:self options:nil] objectAtIndex:0];
    CGRect calloutViewFrame  = calloutView.frame;
    calloutViewFrame.origin = CGPointMake(0,self.view.frame.size.height/6);//CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
    calloutView.frame = calloutViewFrame;
    
    
    CustomAnnotation *someAnnotation = view.annotation;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[someAnnotation imageURLEnlarged]]];
    UIImage *image1 = [[UIImage alloc] initWithData:data];
    
    
    [calloutView setUpAnnotationWith:someAnnotation.ownerOfPhoto andLikes:someAnnotation.numberOfLikes andImage:image1 andTime:someAnnotation.timeCreated andMediaID:someAnnotation.mediaID andUserLiked:someAnnotation.userHasLiked andAnnotation:someAnnotation];
    
    //Makes pictures circular
    calloutView.layer.cornerRadius = calloutView.frame.size.height/30;
    calloutView.layer.masksToBounds = YES;
    
    //Makes border
    calloutView.layer.borderWidth = 3.0f;
    calloutView.layer.borderColor = [UIColor purpleColor].CGColor;
    
    [self animateFadeInAndAddCallOutView:calloutView];
    
    
    if ([_picturesChosenByDrag count] >= 2)
    {
        [_picturesChosenByDrag removeObjectAtIndex:0];
        [self performSelectorOnMainThread:@selector(determineWhetherToDisplayAnotherAnnotationOrDeselect) withObject:nil waitUntilDone:NO];
    }
    else if ([_picturesChosenByDrag count] == 1)
    {
        [self performSelectorOnMainThread:@selector(workaroundDeselect) withObject:nil waitUntilDone:NO];
        //Put NSNotificationHere to desel;ect
        /*
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [self mapView:_mapView didDeselectAnnotationView:[_picturesChosenByDrag objectAtIndex:0]];
        });
         */
    }
    else
    {
        
    }
    
}

-(void)selectDeselectNoDelay
{
    [self mapView:_mapView didDeselectAnnotationView:[_picturesChosenByDrag objectAtIndex:0]];
}

-(void)workaroundDeselect
{
    [self performSelector:@selector(selectDeselectNoDelay) withObject:nil afterDelay:1
     ];
}


//TODO: can I make this recursive? Or... is there a way for me to determine what the next annotationView I should display is without a for loop?
-(void)displayAnnotationCalloutWithSetOfAnnotationViews:(NSMutableOrderedSet *)myOrderedSet
{
    NSLog(@"DISPLAYING");
    NSLog(@"SET: %@",myOrderedSet);
    
    for (int i = 0; i< [myOrderedSet count]; i++)
    {
       // _displayingPictures = YES;
        MKAnnotationView* annotationView = [myOrderedSet objectAtIndex:i];
        //[self performSelector:@selector(displayAnnotationCalloutWithAnnotationView:) withObject:annotationView afterDelay:(1*i)];
        [self shouldWeDisplayAnnotation:annotationView afterDelayOf:(1*i)];
        //SET vvv variable, if false break;
        //[self displayAnnotationCalloutWithAnnotationView:annotationView withDelay:1]; //time in seconds
        //TODO: Change this to a NSTimer implementation?
        //Currently there is no way for us to skip pictures by tapping since once this is set... it can't be changed. NSTimer should allow us to fire whenever we need to.
        //maybe put a dispatch_after here?
        
        //*********
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(<#delayInSeconds#> * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //<#code to be executed after a specified delay#>
        //});
        
      
        
    }
    
    
}

-(BOOL)shouldWeDisplayAnnotation:(MKAnnotationView *)annotationView afterDelayOf:(NSInteger)timeToDelay
{
    
    //NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:timeToDelay target:self selector:@selector(something) userInfo:nil repeats:NO];
    [self performSelector:@selector(displayAnnotationCalloutWithAnnotationView:) withObject:annotationView afterDelay:timeToDelay];
    
    
    //PUT ANOTHER SELECOR HERE... goToNextPicture afterDelay:xxx
    //If user taps, we'll call this method and invalidate the timer (if user doesn't tap, method is called anyways)
    //In which case this method should display the next Picture.
    
    return YES;
}

-(BOOL)cancelDisplayOfQueuedAnnotation:(MKAnnotationView *)annotationView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(displayAnnotationCalloutWithAnnotationView:) object:annotationView];
    
    return YES;
}

-(void)displayAnnotationCalloutWithAnnotationView:(MKAnnotationView *)view
{
    
    //add timer and time to delay... (return BOOL 0 = no click, 1 = click (cancel queue of pictures) )
    
    CustomCallout *calloutView = (CustomCallout *)[[[NSBundle mainBundle] loadNibNamed:@"calloutView" owner:self options:nil] objectAtIndex:0];
    CGRect calloutViewFrame  = calloutView.frame;
    calloutViewFrame.origin = CGPointMake(0,self.view.frame.size.height/6);//CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
    calloutView.frame = calloutViewFrame;
    
    
    CustomAnnotation *someAnnotation = view.annotation;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[someAnnotation imageURLEnlarged]]];
    UIImage *image1 = [[UIImage alloc] initWithData:data];
    
    
    [calloutView setUpAnnotationWith:someAnnotation.ownerOfPhoto andLikes:someAnnotation.numberOfLikes andImage:image1 andTime:someAnnotation.timeCreated andMediaID:someAnnotation.mediaID andUserLiked:someAnnotation.userHasLiked];
    
    //Makes pictures circular
    calloutView.layer.cornerRadius = calloutView.frame.size.height/30;
    calloutView.layer.masksToBounds = YES;
    
    //Makes border
    calloutView.layer.borderWidth = 3.0f;
    calloutView.layer.borderColor = [UIColor purpleColor].CGColor;
    
    [self animateFadeInAndAddCallOutView:calloutView];
    //[self.view addSubview:calloutView]; //added it to the main view so it will always display picture at center of screen... can change this (replace self.view with view (the MKAnnotationView)
    //NEED A PLACE FOR NOT DISPLAYING
    NSLog(@"displaying");
    //_displayingPictures = NO; //THIS IS INCORRECT
}

-(void)animateFadeInAndAddCallOutView:(CustomCallout *)calloutView
{
    [calloutView setAlpha:0];
    [self.view addSubview:calloutView];
    [UIView beginAnimations:nil context:nil];
    [calloutView setAlpha:1.0];
    [UIView commitAnimations];
}

#pragma mark - Map view delegates/methods

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
    
    
    //DO ANIMATION HERE
    //Makes border
    [(CustomAnnotation *)view.annotation setColorType:[UIColor yellowColor]];
    [self updateTheBorderColorOnViewToMatchTheAnnotationType:view];
    
    return;
    //REVERT TO HERE
    NSLog(@"Tapped it!");
    if (![view.annotation isKindOfClass:[MKUserLocation class]] && ![view.annotation isKindOfClass:[MKPointAnnotation class]])
    {
        //[self displayAnnotationCalloutWithAnnotationView:view];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //loops through the MKAnnotationView views..
    /*
    for (UIView *subview in view.subviews )
    {
        [subview removeFromSuperview];
    }
     */
    
    //looping through main view views... only remove of class CustomCallout.
    NSLog(@"DESELECTING ANNOTATION");
    //return;
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[CustomCallout class]])
            [subView removeFromSuperview];
    }
}

-(id<MKAnnotation>)addAnnotationWithWGPhoto:(WGPhoto *)photo
{
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithPhoto:photo];
    
    //background queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //DO THIS
        [annotation createNewImage];
        //And when it's finished
        dispatch_async(dispatch_get_main_queue(), ^{
            //do this (on main queue)
            [_mapView addAnnotation:annotation];
        });
    });
    
  //  [_mapView addAnnotation:annotation];
    
    return annotation;
    //^^^ This is not being used currently...
}

//This delegate method is called EVERYTIME WE call [_mapView addAnnotation].. so think data flow... we'll only addAnnotation to pictures we want to display. BINGO.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Include logic here to choose correct view of appropriate type of annotation object (Later on we'll highlight specific icons (red for liked, yellow for popular, blue for etc.)
    
    //Based on apple documentation... an annotation view is either an annotation (a pin/custom) or an overlay (think traffic lines/w/e) I have no idea what this means to us.
    
    static NSString *identifier = @"CustomViewAnnotation";

    //MKUserLocation is considered an annotation and we don't want to change that so just return no view
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
         return nil;
   // dispatch_queue_t queue;
    //queue = dispatch_queue_create("com.example.MyQueue", NULL);
    
    //if possible, reuse annotation views from before (with the same identifier) (I think for most of our cases.. we'll have to recreate a new annotationView (if I'm interpreting how its being used correctly..)
    MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    //MKAnnotationView *annotationView = nil;
    
    
    //If we don't have any annotationView... create one.
    if (!annotationView)
    {
            
        NSLog(@"making new MKAnnotationView");
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        //if (![(CustomAnnotation *)annotation imageURLEnlarged]) //means this annotation is a picture.
        //{
        
       // }
       // else //video
       // {
       
       // }
        
    }
    else
    {
        //else reuse it
        NSLog(@"I must have reused it!");
        annotationView.annotation  = annotation;
    }
    
    /*
    //We create some data object from the stringURL of the picture. (we cast to type customaAnnotation because we KNOW FOR CERTAIN that the only object we'll have is of CustomAnnotion so cast is ok)
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[(CustomAnnotation *)annotation imageURL]]];
    //create the image and assign it to the annotationView
    UIImage *theImage = [[UIImage alloc] initWithData:data scale:2.0];
    //make image annotation look pretty
    theImage = [self makeImagePretty:theImage];
     //My attempt at asychronous work
     dispatch_queue_t backgroundQueue;
     backgroundQueue = dispatch_queue_create("anythingbro.hope.it.works", NULL);
     
     dispatch_async(backgroundQueue, ^(void){
     [annotation createNewImage];
     
     });
     
     */
   
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
    
    
    
   // annotationView.backgroundColor = [UIColor clearColor];
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
}


-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    //We need some way to detect when the user has clicked the "Allow our map to use location services.." B/c currently we always try to get the location and load pictures (in viewWillAppear then mapViewDidFinishRenderingMap), but if have no location, we can't load anything. Or find another solution... something like if lat/lng = 0 reload coordinates and zoom to user location.
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    //god damn: https://developer.apple.com/library/ios/documentation/General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008091-CH1-SW1
    
    
    [_mapView getCurrentLocationOfMap];
    
    //This happens if we couldn't load the map properly (user didn't allow location), so rezoom to user location.
    
    
    [_mapView getRadius];
    NSLog(@"RADIUS: %f", _mapView.radius);
    
    //if we want all pictures set to all etc etc.
    
    
    
    [self selectMethodForType:_globalType];
    
    //[_mapView findAllImagesOnMapInRange:(_mapView.radius/2) inLatitude:_mapView.currentLocation.latitude andLongitude:_mapView.currentLocation.longitude];
    
    //[self loadAllPictures];
    
    //How to concur/
   // dispatch_async(dispatch_get_main_queue(), ^{
    //Need to say... after data loaded then loadAllPictures. and do that concurrently
       
    
       
   // });
    
    
}

-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    
}


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




#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;//_autoCompleteData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //FOR custom cell later
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //since we don't have one yet, we'll create a generic one
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    //fill each row with data
    //TODO: still need data... simply place data in array and place in.
    cell.textLabel.text = @"Hello";//[_autoCompleteData objectAtIndex:indexPath.row];
    return cell;
}

/* NOT SURE ABOUT THIS YET
#pragma mark -IGRequest Delegate
-(void)request:(IGRequest *)request didLoad:(id)result
{
    NSLog(@"MapView got some result!");
    if ([result isKindOfClass:[WGMap class]])
    {
        [self performSelector:@selector(loadAllPictures)];
    }
}
*/
@end

//
//  MapViewController.m
//  Picto
//
//  Created by William Gu on 7/2/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "MapViewController.h"
#import "CameraAppViewController.h"
#import "User.h"
#import "WGMap.h"
#import "WGPhoto.h"
#import "CustomAnnotation.h"
#import "CustomCallout.h"

const NSInteger METERS_PER_MILE = 1609.344;

enum {
    ALL = 1,
    POPULAR = 2,
    
};
typedef NSInteger Type;

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet UITableView *autoCompleteTableView;
@property (strong, nonatomic) User *someUser;

@property (strong, nonatomic) WGPhoto *someData;
@property (strong, nonatomic) UIImagePickerController *mediaPicker;
@property (strong, nonatomic) UIImage *chosenImage;


@end

@implementation MapViewController

#pragma mark -Helper functions


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
    if (type == ALL)
    {
        [_mapView findAllImagesOnMapInRange:(_mapView.radius/2) inLatitude:_mapView.currentLocation.latitude andLongitude:_mapView.currentLocation.longitude];
    }
    else if (type == POPULAR)
    {
        
    }
}

/*
-(void)loadPicturePinWithURL:(NSString *)stringURL onMap:(MKMapView *)mapView withLocation:(CLLocationCoordinate2D)location
{
    //This is making it asynchronous I believe.  Don't quote me on that. Still need to test.
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        //Make a type of NSData from the contents of a URL... this URL is the stringURL.
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:stringURL]];
        //if this data didn't work then it has to be nil so just return
        if ( data == nil )
            return;
        
        //otherwise do stuff
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point?? //I can't explain this comment... it was placed here from stackoverflow
            //LOAD IMAGE INTO PIN HERE
            
            //Make a new WGPhoto with the data we have... init with the location and the image
            
            //CustomAnnotation *new2 = [[CustomAnnotation alloc] initWithPhoto:photo];
            //MKAnnotationView *new = [[MKAnnotationView alloc] init];
            //new.image = [UIImage imageNamed:@"butt.png"];
            //[_mapView addAnnotation:new2];
            //a custom method for placing the new WGPhoto
            //[self placePicturePin:photo];
            
        
        });
        
    });
    //animations blah
    
}
*/

//Load all the pictures in a specific map region. _mapView.possiblePics should always have the possible pictures in a region as the method to get all the possiblePictures is called everytime the map finishes rendering (i.e. everytime the user moves the map.)

/*  PRE ASYNC.  REVERT HERE FOR WORKING VERSION.
-(void)loadAllPictures
{
    
    
    
    for (id pictureURL in _mapView.possiblePics)
    {
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
        
        //Save this object in an array of currently displayed photos
        WGPhoto *photo = [[WGPhoto alloc] initWithLocation:location andImageURL:stringURL andEnlarged:stringURLEnlarged];
        
        //OR save object as video WGVideo subclass.. (not made yet)
        
        [_mapView.actualPics addObject:photo];
        
        
        [self addAnnotationWithWGPhoto:photo];
        
        //mapView viewForAnnotation should be automatically called now.. ->
        
        //load the picture onto map
        //[self loadPicturePinWithURL:stringURL onMap:_mapView withLocation:location];
        
    }
    
}
*/

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
            
            //Save this object in an array of currently displayed photos
            WGPhoto *photo = [[WGPhoto alloc] initWithLocation:location andImageURL:stringURL andEnlarged:stringURLEnlarged];
            
            //OR save object as video WGVideo subclass.. (not made yet)
            
            [_mapView.actualPics addObject:photo]; //THIS IS NOT BEING USED RIGHT NOW.
            
            //do this when done loading.. on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addAnnotationWithWGPhoto:photo];
                //mapView viewForAnnotation should be automatically called now.. ->
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
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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
    
    //After sending these messages there is a slight delay to when the delegate actually places the data in the array... will need a way to fix this (let user know they can't do anything yet/ tell controller to wait till data has loaded.
  //  [_someUser retrieveFollowersFromIG];
    
    
    /* Data Flow:  1. Wait for map to zoom into our current location, 2. get that location, 3. load the pictures at the position, 4. show those pictures... (continue steps 2-4 as user moves around map (new input)) */
    
    //Tell our VC to watch for a notification called "Can Find Location" and call mapLocationFound when done
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapLocationSettled) name:@"Can Find Location" object:nil];
    
    //Tell our VC to watch for a notification called "Location Found" and call findAll... when done
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findAllImagesOnMapInRange:inLatitude:andLongitude:) name:@"Location Found" object:nil];*/ //this operation is assumed to be fast so we probably don't need this
    
    //Tell our VC to watch for a notification called "Images Loaded" and call loadAllPictures when heard.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPictures) name:@"Images Loaded" object:nil];
    
    
}

-(void)viewDidUnload
{
    //remove the observers if we leave this view
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Can Find Location" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Images Loaded" object:nil];
    
}

//don't worry about this, this is for me.
-(IBAction)testStuff:(UIButton *)sender
{
    //TEST STUFF
    int i = 0;
    
    //the objects in this array is of an unknown type BUT we know it subclasses from NSMutableDictionary so feel free to use those methods (Documentation says data is in form of Dictionary or List.
    /*
    for (id obj in _someUser.followers)
    {
        BOOL isClass = [obj isKindOfClass:[NSMutableDictionary class]];
        NSLog(@"%hhd Username: %@",isClass,[obj objectForKey:@"username"]);
        NSLog(@"Full-Name: %@",[obj objectForKey:@"full_name"]);
        NSLog(@"Data: %@ ",obj);
        i++;
    }
    */
   // CLLocationCoordinate2D location = [_mapView getCurrentLocationOfMap];
    
    NSLog(@"%lu", (unsigned long)[_mapView.possiblePics count]);
    for (id obj in _mapView.possiblePics)
    {
        NSLog(@"Something happened");
        NSLog(@"PICTURE URL??:: %@", [obj valueForKeyPath:@"images.thumbnail.url"]); //WzOOOTT
        //NSLog(@"%@", obj);
    }
    [self loadPictures];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [_someUser getCurrentLocationOnMap:_mapView]; //get location of user
    //zoom to user location on map
    [self zoomToRegion:_someUser.currentLocation.coordinate withLatitude:50 withLongitude:50 withMap:_mapView];
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

-(IBAction)friendsButton:(UIButton *)button
{
    SideMenuViewController *sideMenu = [[SideMenuViewController alloc] init];
    [self presentViewController:sideMenu animated:YES completion:nil];
}


-(IBAction)cameraButtonPress:(UIButton *)sender
{
    //TODO: Implement taking a picture/video
    //After taking a picture/video this will be uploaded to the cloud/facebook automatically
    [self takePhoto];
    
}

#pragma mark - UIImagePickerController delegate/methods

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.mediaTypes = availableTypes;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.videoMaximumDuration = 10; //10 seconds... only stops SHARING however.. not actual video length
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //handle video and pictures here
    
    NSURL *mediaURL  = info[UIImagePickerControllerMediaURL]; //video
    if (mediaURL)
    {
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([mediaURL path]))
        {
            //Save video somewhere in album?
        }
        //save video somewhere...
        //TODO: Save video
        
        //remove video from tempory directory
        [[NSFileManager defaultManager] removeItemAtPath:[mediaURL path] error:nil];
        
    }
    
    
    
    _chosenImage = info[UIImagePickerControllerEditedImage];
    if (_chosenImage)
    {
        //store image or something
        //TODO: Save photo
    }
    
    //TODO: Display the just taken photo/video on map
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - Map view delegates/methods

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Tapped it!");
    if (![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        CustomCallout *calloutView = (CustomCallout *)[[[NSBundle mainBundle] loadNibNamed:@"calloutView" owner:self options:nil] objectAtIndex:0];
        CGRect calloutViewFrame  = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(0,self.view.frame.size.height/6);//CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        [calloutView.infoText setText:@"BLAHBLAHBLAHFRIENDLOC"]; //TODO: Grab user name and location
        
        CustomAnnotation *someAnnotation = view.annotation;
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[someAnnotation imageURLEnlarged]]];
        UIImage *image1 = [[UIImage alloc] initWithData:data];
        [calloutView.image setImage:image1];
        [self.view addSubview:calloutView]; //added it to the main view so it will always display picture at center of screen... can change this (replace self.view with view (the MKAnnotationView)
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
    NSInteger type = ALL;
    
    
    [self selectMethodForType:type];
    
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

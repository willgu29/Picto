//
//  MapViewController.h
//  Picto
//
//  Created by William Gu on 7/2/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SideMenuViewController.h"
#import "IGRequest.h"
#import "IGConnect.h"
#import "WGMap.h"
#import "User.h"
#import "WGTimer.h"

@class User;

const unsigned long long SECONDS_PER_PIC =  1.2;

enum {
    ALL = 1,
    RECENT = 2,
    POPULAR = 3,
    
};
typedef NSInteger Type;


//That's a lot of delegates!  Check out the protocols in apple documentation! Weee
@interface MapViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, IGRequestDelegate>
{
    //Ignore these for now
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSMutableArray *matchingItems;
    dispatch_source_t dispatchSource;
    dispatch_source_t annotationTimer;
}

//Our map view will have the actual map and a search bar.
@property (strong, atomic) IBOutlet WGMap *mapView; //custom map view with new methods to use!

@property (strong, nonatomic) IBOutlet UITextField *searchField; //There's actually a UISearchBar class (oops)... we can switch this out later. Should be simple since UISearchBar is a subclass of UITextField...
@property (nonatomic) NSInteger globalType;
@property (nonatomic) BOOL displayingPictures;
@property (nonatomic) BOOL onlyFriends; //TODO: remember state (default no)
@property (strong, nonatomic) IBOutlet UILabel *type; //TODO: set default to current type (at launch)

@property (nonatomic, strong) NSMutableOrderedSet *picturesChosenByDrag; //of annotation views
@property (nonatomic, strong) NSMutableOrderedSet *picturesPopular;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic) int arrayPosition;
@property (nonatomic, strong) NSString *currentMapViewGeoLocation;
@property (strong, nonatomic) User *someUser;

@property (nonatomic) float previousPanMeter;
@property (nonatomic) float previousPanMeterGeo;
@property (nonatomic) float previousPanMeterData;
@property (nonatomic) float previousZoomDegree;

@end


//TODO: Implement auto-complete on search
//TODO: Add a button to transition to taking picture and the code for taking a picture
//TODO: After taking picture, push picture to facebook
//TODO: 

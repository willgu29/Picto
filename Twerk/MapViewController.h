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
#import "WGTimer.h"

//That's a lot of delegates!  Check out the protocols in apple documentation! Weee
@interface MapViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, IGRequestDelegate>
{
    //Ignore these for now
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSMutableArray *matchingItems;
}

//Our map view will have the actual map and a search bar.
@property (strong, nonatomic) IBOutlet WGMap *mapView; //custom map view with new methods to use!

@property (strong, nonatomic) IBOutlet UITextField *searchField; //There's actually a UISearchBar class (oops)... we can switch this out later. Should be simple since UISearchBar is a subclass of UITextField...
@property (nonatomic) NSInteger globalType;
@property (nonatomic) BOOL displayingPictures;
@property (nonatomic) BOOL onlyFriends; //TODO: remember state (default no)
@property (strong, nonatomic) IBOutlet UILabel *type; //TODO: set default to current type (at launch)

@property (nonatomic, strong) NSMutableOrderedSet *picturesChosenByDrag; //of annotation views
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic) int arrayPosition;

@end


//TODO: Implement auto-complete on search
//TODO: Add a button to transition to taking picture and the code for taking a picture
//TODO: After taking picture, push picture to facebook
//TODO: 

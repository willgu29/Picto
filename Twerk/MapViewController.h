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

@interface MapViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, IGRequestDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSMutableArray *matchingItems;
}

@property (strong, nonatomic) IBOutlet WGMap *mapView; //custom map view with new methods to use!
//@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;


@end


//TODO: Implement auto-complete on search
//TODO: Add a button to transition to taking picture and the code for taking a picture
//TODO: After taking picture, push picture to facebook
//TODO: 

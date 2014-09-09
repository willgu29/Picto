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
#import "PictureArray.h"
#import "SearchData.h"
#import "CustomAnnotation.h"
@class User;
@class SearchData;

static const unsigned long long SECONDS_PER_PIC =  1.3;

enum {
    ALL = 1,
    RECENT = 2,
    POPULAR = 3,
    
};
typedef NSInteger Type;


enum {
    NONE = 0,
    USER = 1,
    HASHTAG = 2,
    LOCATION = 3,
    
};
typedef NSInteger Search;

enum {
    DUPLICATE = 1, //trying to add duplicate annotation
    FLOOD = 2, //... too many annotations being displayed
    OVERLAP = 3, //annotation views high chance of overlap (i.e. same location)
    SUCCESS = 69
    
};
typedef NSInteger AnnotationCheck;

//That's a lot of delegates!  Check out the protocols in apple documentation! Weee
@interface MapViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, IGRequestDelegate>
{
    //Ignore these for now
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSMutableArray *matchingItems;
    dispatch_source_t annotationTimer;
}
@property (atomic) BOOL lock;

//Our map view will have the actual map and a search bar.
@property (weak, nonatomic) IBOutlet UITableView *autoCompleteTableView;
@property (strong, atomic) IBOutlet WGMap *mapView; //custom map view with new methods to use!
@property (strong, nonatomic) IBOutlet UITextField *searchField; //There's actually a UISearchBar class (oops)... we can switch this out later. Should be simple since UISearchBar is a subclass of UITextField...
@property (nonatomic) NSInteger globalType; //All vs recent
@property (nonatomic) NSInteger searchType; //User vs hashtag vs location
@property (nonatomic) BOOL displayingPictures;
@property (nonatomic) BOOL onlyFriends;
@property (strong, nonatomic) IBOutlet UILabel *type;

@property (strong, atomic) PictureArray *picturesArray;
@property (strong, nonatomic) SearchData *searchData;


@property (nonatomic, strong) NSMutableOrderedSet *picturesChosenByDrag; //of annotation views
@property (nonatomic, strong) NSMutableOrderedSet *picturesPopular;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic) int arrayPosition;
@property (nonatomic, strong) NSString *currentMapViewGeoLocation;
@property (strong, nonatomic) User *someUser;

@property (nonatomic) CLLocationCoordinate2D prevGeoCoord;
@property (nonatomic) CLLocationCoordinate2D prevDataCoord;
@property (nonatomic) double prev_zoomLevel;

@property (nonatomic) BOOL isPopularNotFriend;

-(BOOL)shouldWeParseThisPicture:(id)picture;
-(CustomAnnotation *)parseAndReturnAnnotation:(id)pictureURL;
-(NSInteger)checkAnnotationEnums:(CustomAnnotation *)annotation;
-(void)hasFollowedUser:(CustomAnnotation *)annotation;
-(void)zoomToRegion:(CLLocationCoordinate2D)coordinate withLatitude:(CLLocationDistance)latitude withLongitude:(CLLocationDistance)longitude withMap:(MKMapView *)map;
@end


//TODO: Implement auto-complete on search
//TODO: Add a button to transition to taking picture and the code for taking a picture
//TODO: After taking picture, push picture to facebook
//TODO: 

//
//  WeatherMapViewController.h
//  Weather Watcher
//
//  Created by Christopher Corea on 6/11/14.
//  Copyright (c) 2014 BamBamProd. All rights reserved.
//

#import "BaseUIViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherMapViewController : BaseUIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    MKMapView *districtMapView;
    UITableView *districtTableView;
    UIView *infoPage;
    
    CLLocationManager *locationManager;
    double myLatitude;
    double myLongitude;
    
    UISearchDisplayController *searchBarDisplayController;
    
    BOOL toggleSelectionIsList;
    BOOL finishedUpdatingLocation;
}

@property (nonatomic, strong) UISearchBar *locationSearchBar;
@property (nonatomic, strong) UIButton *nearMeButton;
@property (nonatomic, strong) UIBarButtonItem *viewToggleButton;
@property (nonatomic, strong) UIBarButtonItem *infoButton;
@property (nonatomic, strong) NSDate *gpsStartTime;

@end

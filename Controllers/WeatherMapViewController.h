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

@interface WeatherMapViewController : BaseUIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
{
    MKMapView *districtMapView;
    
    CLLocationManager *locationManager;
    NSDate *gpsStartTime;
    double myLatitude;
    double myLongitude;
    
    UISearchDisplayController *searchBarDisplayController;
}

@property (nonatomic, strong) UISearchBar *locationSearchBar;
@property (nonatomic, strong) UIButton *nearMeButton;

@end

//
//  WeatherMapViewController.m
//  Weather Watcher
//
//  Created by Christopher Corea on 6/11/14.
//  Copyright (c) 2014 BamBamProd. All rights reserved.
//

#import "WeatherMapViewController.h"
#import "UIView+ViewAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking.h>
#import "WeatherWatcherInfoPageViewController.h"

#define kLocationsTimeout 60
#define nearMeButtonSize 52

@interface WeatherMapViewController ()
@end

@implementation WeatherMapViewController

#pragma mark - life cycle

- (void)loadView {
    [super loadView];
    self.navigationItem.title = NSLocalizedString(@"MapPageTitle", @"");
    
    [self createSearchDisplayController];
    
    CGRect frame = CGRectMake(0, self.locationSearchBar.height, screenWidth, heightWithNavBar - self.locationSearchBar.height);
    districtTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    districtTableView.delegate = self;
    districtTableView.dataSource = self;
    districtTableView.bounces = YES;
    districtTableView.tableFooterView = [[UIView alloc] init];
    districtTableView.backgroundColor = [UIColor clearColor];
    
    districtMapView = [[MKMapView alloc] initWithFrame:frame];
    districtMapView.scrollEnabled = YES;
    districtMapView.zoomEnabled = YES;
    districtMapView.showsUserLocation = YES;
    districtMapView.backgroundColor = [UIColor clearColor];
    districtMapView.alpha = 1.0f;
    
    self.nearMeButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - (nearMeButtonSize + 4), frame.size.height - nearMeButtonSize, nearMeButtonSize, nearMeButtonSize)];
    [self.nearMeButton setImage:[UIImage imageNamed:@"near-me-off"] forState:UIControlStateNormal];
    [self.nearMeButton setImage:[UIImage imageNamed:@"near-me"] forState:UIControlStateSelected];
    [self.nearMeButton addTarget:self action:@selector(nearMeAction) forControlEvents:UIControlEventTouchUpInside];

    [self createBarButtons];

    [self.view addSubview:districtMapView];
    [districtMapView addSubview:_nearMeButton];
    [self.view addSubview:self.locationSearchBar];

    [self startLocationServices];
    [searchBarDisplayController setActive:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef __IPHONE_7_0 
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    
    [self setupPanGesture];
    [self fetchWeatherInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    districtMapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    districtMapView.delegate = nil;
    [super viewWillDisappear:animated];
}

#pragma mark - setup

- (void)createSearchDisplayController {
    self.locationSearchBar = [[UISearchBar alloc] init];
    self.locationSearchBar.delegate = self;
    self.locationSearchBar.placeholder = NSLocalizedString(@"MapSearchBarPlaceholderText", @"");
    self.locationSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.locationSearchBar.isAccessibilityElement = YES;
    self.locationSearchBar.accessibilityLabel = NSLocalizedString(@"MapSearchBarAccessibilityLabel", @"");
    [self.locationSearchBar sizeToFit];
    
    searchBarDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.locationSearchBar contentsController:self];
    searchBarDisplayController.delegate = self;
    searchBarDisplayController.searchResultsDataSource = self;
    searchBarDisplayController.searchResultsDelegate = self;
}

- (void)createBarButtons {
    self.viewToggleButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ToggleBarButtonTitleList", @"")
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(toggleView)];
    self.navigationItem.rightBarButtonItem = _viewToggleButton;
    toggleSelectionIsList = YES;
    
    self.infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info"] style:UIBarButtonItemStylePlain target:self action:@selector(showInfoPage)];
    self.navigationItem.leftBarButtonItem = _infoButton;
}

#pragma mark - tableview datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (tableView == searchBarDisplayController.searchResultsTableView) {
        // possibly handle this case if api sends back multiple results for a query
    } else {
        rows = 1;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (tableView == searchBarDisplayController.searchResultsTableView) {
        // possibly handle this case if api sends back multiple results for a query
        cell = [tableView dequeueReusableCellWithIdentifier:NSLocalizedString(@"SearchResultCellIdentifier", @"")];
        
    } else { // we're in the district list
        cell = [tableView dequeueReusableCellWithIdentifier:NSLocalizedString(@"DistrictCellIdentifier", @"")];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSLocalizedString(@"DistrictCellIdentifier", @"")];
        }
        cell.textLabel.text = @"hello";
    }
    
    return cell;
}

#pragma mark - SearchBar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _nearMeButton.selected = NO;
}

#pragma mark - SearchDisplayController delegate methods


#pragma mark - MKMapView Delegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    region.center = mapView.userLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.1, 0.1);
    region = [mapView regionThatFits:region];
    
    [mapView setRegion:region animated:YES];
}


#pragma mark - helper methods
- (void)toggleView {
    [UIView transitionFromView:(toggleSelectionIsList ? districtMapView : districtTableView)
                        toView:(toggleSelectionIsList ? districtTableView : districtMapView)
                      duration:0.6
                       options:(toggleSelectionIsList ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight)
                    completion:^(BOOL finished) {
                        if (finished) {
                            _viewToggleButton.title = (toggleSelectionIsList ?
                                                       NSLocalizedString(@"ToggleBarButtonTitleList", @"") : NSLocalizedString(@"ToggleBarButtonTitleMap", @""));
                            _nearMeButton.hidden = !_nearMeButton.hidden;
                            toggleSelectionIsList = !toggleSelectionIsList;
                        }
    }];
}

- (void)showInfoPage {
    [self.navigationController presentViewController:[[WeatherWatcherInfoPageViewController alloc] init] animated:YES completion:nil];
}

- (void)nearMeAction {
    [self clearSearchBarText];
    [self startLocationServices];
}

- (void)clearSearchBarText {
    self.locationSearchBar.text = @"";
}

- (void)startLocationServices {
    if ([CLLocationManager locationServicesEnabled]) {
        _nearMeButton.selected = !_nearMeButton.selected;
        
        if (_nearMeButton.selected) {
            DLog(@"starting location services");
            // start updating the user's location
            if (!locationManager) {
                locationManager = [[CLLocationManager alloc] init];
            }
            locationManager.delegate = self;
            self.gpsStartTime = [NSDate date];
            [locationManager startUpdatingLocation];
            [NSThread detachNewThreadSelector:@selector(locationTimer) toTarget:self withObject:nil];
        } else {
            [locationManager stopUpdatingLocation];
            locationManager.delegate = NO;
        }
        
    } else {
        //TODO: show a message saying locations is turned off
        DLog(@"Locations is turned off or disallowed on this device");
    }
}

- (void)locationTimer {
    @autoreleasepool {
        NSDate *startTimer = [NSDate date];
        while ([[NSDate date] timeIntervalSinceDate:startTimer] < kLocationsTimeout && !finishedUpdatingLocation) {
            [NSThread sleepForTimeInterval:1.0];
        }
        if (!finishedUpdatingLocation) {
            [self performSelectorOnMainThread:@selector(locationServicesTimedOut) withObject:self waitUntilDone:NO];
        }
    }
}

- (void)locationServicesTimedOut {
    finishedUpdatingLocation = YES;
    //TODO: show a banner with error message
}

- (void)didPanMap:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        DLog(@"map region changed");
        _nearMeButton.selected = NO;
    }
}

- (void)zoomMapToFitAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    
}


- (void)setupPanGesture {
    UIPanGestureRecognizer *panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanMap:)];
    panGestureRec.delegate = self;
    [districtMapView addGestureRecognizer:panGestureRec];
}

- (void)fetchWeatherInfo {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://localhost:8080" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
}

#pragma mark - gesture recognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

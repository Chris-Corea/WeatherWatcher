//
//  WeatherMapViewController.m
//  Weather Watcher
//
//  Created by Christopher Corea on 6/11/14.
//  Copyright (c) 2014 BamBamProd. All rights reserved.
//

#import "WeatherMapViewController.h"
#import "UIView+ViewAdditions.h"

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
    
    self.nearMeButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - (nearMeButtonSize + 4), heightWithNavBar - nearMeButtonSize, nearMeButtonSize, nearMeButtonSize)];
    
    CGRect frame = CGRectMake(0, self.locationSearchBar.height, screenWidth, heightWithNavBar - self.locationSearchBar.height);
    districtTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    districtTableView.delegate = self;
    districtTableView.dataSource = self;
    districtTableView.hidden = YES;
    districtTableView.bounces = YES;
    districtTableView.tableFooterView = [[UIView alloc] init];
    districtTableView.backgroundColor = [UIColor clearColor];
    
    districtMapView = [[MKMapView alloc] initWithFrame:frame];
    districtMapView.scrollEnabled = YES;
    districtMapView.zoomEnabled = YES;
    districtMapView.showsUserLocation = YES;
    districtMapView.backgroundColor = [UIColor clearColor];

    [self createBarButton];

    [self.view addSubview:districtMapView];
    [self.view addSubview:districtTableView];
    [self.view addSubview:_nearMeButton];
    [self.view addSubview:_locationSearchBar];

    [self startLocationServices];
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
    
    searchBarDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.locationSearchBar contentsController:self];
    searchBarDisplayController.delegate = self;
    searchBarDisplayController.searchResultsDataSource = self;
    searchBarDisplayController.searchResultsDelegate = self;
}

- (void)createBarButton {
    self.viewToggleButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ToggleBarButtonTitleList", @"")
                                                             style:UIBarButtonItemStylePlain target:self action:@selector(toggleView)];
    self.navigationItem.rightBarButtonItem = _viewToggleButton;

    toggleSelectionIsList = YES;
}

#pragma mark - tableview datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (tableView == searchBarDisplayController.searchResultsTableView) {
        // possibly handle this case if api sends back multiple results for a query
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
    }
    
    return cell;
}

#pragma mark - helper methods
- (void)toggleView {
    [UIView transitionFromView:(toggleSelectionIsList ? districtMapView : districtTableView)
                        toView:(toggleSelectionIsList ? districtTableView : districtMapView)
                      duration:0.6
                       options:(toggleSelectionIsList ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight)
                    completion:^(BOOL finished) {
                        if (finished) {
                            toggleSelectionIsList = !toggleSelectionIsList;
                            _viewToggleButton.title = NSLocalizedString(@"ToggleBarButtonTitleMap", @"");
                        }
    }];
}

- (void)startLocationServices {

}

#pragma mark - memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

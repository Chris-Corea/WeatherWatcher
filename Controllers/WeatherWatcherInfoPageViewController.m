//
//  WeatherWatcherInfoPageViewController.m
//  WeatherWatcher
//
//  Created by Chris Corea on 8/4/14.
//  Copyright (c) 2014 BamBamProd. All rights reserved.
//

#import "WeatherWatcherInfoPageViewController.h"

@interface WeatherWatcherInfoPageViewController ()

@end

@implementation WeatherWatcherInfoPageViewController

- (void)loadView {
    [super loadView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navBackToMapView) forControlEvents:UIControlEventTouchUpInside];
    [backButton setCenter:CGPointMake(screenWidth/2, screenHeight-40)];
    [self.view addSubview:backButton];
    
    UITableView *infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, heightWithNavBar)
                                                              style:UITableViewStyleGrouped];
    infoTableView.dataSource = self;
    infoTableView.delegate = self;
    infoTableView.bounces = NO;
    infoTableView.rowHeight = 40.0f;
    infoTableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:infoTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Info about Weather Underground
    // Info about Icons8
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"];
    }
    
    return cell;
}

- (void)navBackToMapView {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

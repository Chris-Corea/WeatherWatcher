//
//  BackgroundUIViewController.m
//  Weather Watcher
//
//  Created by Christopher Corea on 6/9/14.
//  Copyright (c) 2014 BamBamProd. All rights reserved.
//

#import "BaseUIViewController.h"

@interface BaseUIViewController ()

@end

@implementation BaseUIViewController

- (id)init {
    if ((self = [super init])) {
        CGRect screenbounds = [UIScreen mainScreen].bounds;
        screenHeight = screenbounds.size.height;
        screenWidth = screenbounds.size.width;
        heightWithNavBar = screenHeight - 64;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    myView.backgroundColor = offWhiteColor;
    self.view = myView;
}

- (void)viewWillAppear:(BOOL)animated {
    DLog(@"\n\n=============%@=============\n\n", self);
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  PPRNavigationController.m
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRNavigationController.h"

#import "PPRActionBar.h"

#import "UIColor+PPRStyle.h"

@interface PPRNavigationController ()

@property (strong, nonatomic, readwrite) PPRActionBar *actionBar;

@end

@implementation PPRNavigationController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBarHidden:YES animated:NO];

    self.view.backgroundColor = [UIColor ppr_chocolateColor];

    [self setupActionBar];
}

#pragma mark - Setup

- (void)setupActionBar {
    self.actionBar = [[PPRActionBar alloc] init];
    self.actionBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.actionBar];

    self.actionBar.backgroundColor = [UIColor ppr_toffeeColor];

    self.actionBarHeight = [self.actionBar.heightAnchor constraintEqualToConstant:50.0f];
    self.actionBarHeight.active = YES;
    [self.actionBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.actionBar.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.actionBar.trailingAnchor].active = YES;
}

@end

@implementation UIViewController (PPRNavigationController)

- (PPRNavigationController *)pprNavigationController {
    PPRNavigationController *navigationController = nil;

    if ([self.navigationController isKindOfClass:[PPRNavigationController class]]) {
        navigationController = (PPRNavigationController *)self.navigationController;
    }

    return navigationController;
}

@end

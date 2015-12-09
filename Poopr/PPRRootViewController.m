//
//  PPRRootViewController.m
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRRootViewController.h"
#import "PPRNavigationController.h"
#import "PPRPoopListViewController.h"
#import "PPRStatsViewController.h"
#import "PPRMapViewController.h"
#import "PPRPermissionViewController.h"
#import "PPRTabBarController.h"

#import "PPRPoopListViewModel.h"

#import "PPRErrorView.h"
#import "PPRErrorManager.h"

#import "UIColor+PPRStyle.h"

#import "PPRSettings.h"

#import <pop/POP.h>

static const CGFloat kPPRErrorViewHeight = 100.0f;
//static const NSTimeInterval kPPRErrorViewAnimationDuration = 0.3;
//static const CGFloat kPPRErrorViewAnimationSpringDamping = 0.75f;
//static const NSInteger kPPRErrorViewShowTime = 3;

@interface PPRRootViewController () <PPRPermissionDelegate>

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) PPRErrorView *errorView;
@property (strong, nonatomic) UIViewController *currentViewController;

@property (strong, nonatomic) NSLayoutConstraint *errorViewTop;

@property (assign, nonatomic) BOOL errorViewShown;

@end

@implementation PPRRootViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor ppr_cocoaColor];

    [self setupErrorView];
    [self setupContainerView];
    [self setupObservers];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    if ([PPRSettings hasPromptedPermissions]) {
        [self showTabBarController];
    }
    else {
        [PPRSettings setHasPromptedPermissions:YES];

        PPRPermissionViewController *permissionViewController = [[PPRPermissionViewController alloc] init];
        permissionViewController.delegate = self;
        [self showViewController:permissionViewController];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPPRNotificationDidReceiveError object:nil];
}

#pragma mark - Setup

- (void)setupErrorView {
    self.errorView = [[PPRErrorView alloc] init];
    self.errorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.errorView];

    [self.errorView addTarget:self action:@selector(didTapErrorView)];

    [self.errorView.heightAnchor constraintEqualToConstant:kPPRErrorViewHeight].active = YES;
    self.errorViewTop = [self.errorView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:-kPPRErrorViewHeight];
    self.errorViewTop.active = YES;
    [self.errorView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.errorView.trailingAnchor].active = YES;
}

- (void)setupContainerView {
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];

    [self.containerView.topAnchor constraintEqualToAnchor:self.errorView.bottomAnchor].active = YES;
    [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
}

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveError:) name:kPPRNotificationDidReceiveError object:nil];
}

#pragma mark - Actions

- (void)showViewController:(UIViewController *)viewController {
    if (self.currentViewController) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
    }

    self.currentViewController = viewController;

    [self addChildViewController:viewController];
    [self.containerView addSubview:viewController.view];
    viewController.view.frame = self.containerView.frame;
    [viewController didMoveToParentViewController:self];
}

- (void)showTabBarController {
    PPRTabBarController *tabBarController = [[PPRTabBarController alloc] init];

    PPRPoopListViewModel *poopListViewModel = [[PPRPoopListViewModel alloc] init];

    PPRPoopListViewController *poopListViewController = [[PPRPoopListViewController alloc] initWithViewModel:poopListViewModel];
    PPRNavigationController *poopListNavigationController = [[PPRNavigationController alloc] initWithRootViewController:poopListViewController];

    PPRStatsViewController *statsViewController = [[PPRStatsViewController alloc] init];
    PPRNavigationController *statsNavigationController = [[PPRNavigationController alloc] initWithRootViewController:statsViewController];

    PPRMapViewController *mapViewController = [[PPRMapViewController alloc] initWithViewModel:poopListViewModel];
    PPRNavigationController *mapNavigationController = [[PPRNavigationController alloc] initWithRootViewController:mapViewController];

    [tabBarController setViewControllers:@[poopListNavigationController, statsNavigationController, mapNavigationController] animated:YES];

    [self showViewController:tabBarController];
}

- (void)didReceiveError:(NSNotification *)notification {
    NSError *error = notification.userInfo[kPPRNotificationDidReceiveErrorKeyError];
    [self.errorView setupWithError:error];

    [self showErrorView];
}

- (void)didTapErrorView {
    [self hideErrorView];
}

#pragma mark - Permission Delegate

- (void)permissionViewControllerDidFinish:(PPRPermissionViewController *)permissionViewController {
    [self showTabBarController];
}

#pragma mark - Animations

- (void)showErrorView {
    [self animateErrorViewTop:0.0f];
}

- (void)hideErrorView {
    [self animateErrorViewTop:-kPPRErrorViewHeight];
}

- (void)animateErrorViewTop:(CGFloat)top {
    POPSpringAnimation *animation = [self.errorViewTop pop_animationForKey:@"spring"];
    if (!animation) {
        animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    }

    animation.toValue = @(top);

    [self.errorViewTop pop_addAnimation:animation forKey:@"spring"];
}

@end

//
//  PPRTabBarController.m
//  Poopr
//
//  Created by Bradley Smith on 12/2/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRTabBarController.h"

#import "PPRTabAnimationController.h"

#import "UIColor+PPRStyle.h"

#import <pop/POP.h>

@interface PPRTabBarController () <UITabBarControllerDelegate, PPRTabBarDelegate>

@property (strong, nonatomic, readwrite) PPRTabBar *pprTabBar;

@end

@implementation PPRTabBarController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    self.view.backgroundColor = [UIColor ppr_chocolateColor];

    [self setupPPRTabBar];
}

#pragma mark - Setup

- (void)setupPPRTabBar {
    self.pprTabBar = [[PPRTabBar alloc] init];
    self.pprTabBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.pprTabBar];

    self.pprTabBar.delegate = self;
    self.pprTabBar.backgroundColor = [UIColor ppr_toffeeColor];
    self.pprTabBar.tintColor = [UIColor ppr_frostingColor];
    self.pprTabBar.selectionViewColor = [UIColor ppr_cocoaColor];

    [self.pprTabBar.heightAnchor constraintEqualToConstant:50.0f].active = YES;
    [self.pprTabBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.pprTabBar.bottomAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.pprTabBar.trailingAnchor].active = YES;
}

#pragma mark - Actions

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];

    for (PPRTabBarItem *item in self.pprTabBar.tabBarItems) {
        [self.pprTabBar removeTabBarItem:item];
    }

    for (UIViewController *viewController in viewControllers) {
        UIImage *image = [viewController.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        PPRTabBarItem *item = [PPRTabBarItem tabBarItemWithImage:image];

        [self.pprTabBar addTabBarItem:item];
    }
}

#pragma mark - Tab Bar Controller Delegate

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    NSUInteger fromIndex = [self.viewControllers indexOfObject:fromVC];
    NSUInteger toIndex = [self.viewControllers indexOfObject:toVC];
    PPRTabAnimationDirection direction = (toIndex < fromIndex) ? PPRTabAnimationDirectionLeft : PPRTabAnimationDirectionRight;

    PPRTabAnimationController *animationController = [[PPRTabAnimationController alloc] init];
    animationController.direction = direction;

    return animationController;
}

#pragma mark - PPR Tab Bar Delegate

- (void)PPRTabBar:(PPRTabBar *)tabBar didSelectItemAtIndex:(NSUInteger)index {
    if (self.selectedIndex != index) {
        self.selectedIndex = index;
    }
}

@end

@implementation UIViewController (PPRTabBarController)

- (PPRTabBarController *)pprTabBarController {
    PPRTabBarController *tabBarController = nil;

    if ([self.tabBarController isKindOfClass:[PPRTabBarController class]]) {
        tabBarController = (PPRTabBarController *)self.tabBarController;
    }

    return tabBarController;
}

@end

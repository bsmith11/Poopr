//
//  PPRStatsViewController.m
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRStatsViewController.h"

@implementation PPRStatsViewController

- (instancetype)init {
    self = [super init];

    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"chart_icon"] selectedImage:nil];
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
}

@end

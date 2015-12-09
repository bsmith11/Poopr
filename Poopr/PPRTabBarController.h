//
//  PPRTabBarController.h
//  Poopr
//
//  Created by Bradley Smith on 12/2/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

#import "PPRTabBar.h"

@interface PPRTabBarController : UITabBarController

@property (strong, nonatomic, readonly) PPRTabBar *pprTabBar;

@end

@interface UIViewController (PPRTabBarController)

@property (strong, nonatomic, readonly) PPRTabBarController *pprTabBarController;

@end

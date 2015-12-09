//
//  PPRNavigationController.h
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

#import "PPRActionBar.h"

@interface PPRNavigationController : UINavigationController

@property (strong, nonatomic, readonly) PPRActionBar *actionBar;
@property (strong, nonatomic) NSLayoutConstraint *actionBarHeight;

@end

@interface UIViewController (PPRNavigationController)

@property (strong, nonatomic, readonly) PPRNavigationController *pprNavigationController;

@end

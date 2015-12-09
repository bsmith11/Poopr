//
//  PPRPermissionViewController.h
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class PPRPermissionViewController;

@protocol PPRPermissionDelegate <NSObject>

- (void)permissionViewControllerDidFinish:(PPRPermissionViewController *)permissionViewController;

@end

@interface PPRPermissionViewController : UIViewController

@property (weak, nonatomic) id <PPRPermissionDelegate> delegate;

@end

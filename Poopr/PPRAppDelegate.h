//
//  PPRAppDelegate.h
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

OBJC_EXTERN NSString * const kPPRNotificationPermissionDidChangeNotification;

typedef void (^PPRNotificationPermissionBlock)(BOOL granted);

@interface PPRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)notificationPermissionEnabled;
- (void)requestNotificationPermissionWithCompletion:(PPRNotificationPermissionBlock)completion;

@end

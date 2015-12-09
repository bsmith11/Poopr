//
//  UIAlertController+PPRSettings.h
//  Poopr
//
//  Created by Bradley Smith on 9/17/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface UIAlertController (PPRExtensions)

+ (instancetype)ppr_alertControllerForNotificationSettings;
+ (instancetype)ppr_alertControllerForSettingsWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)ppr_alertControllerWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)ppr_alertControllerWithError:(NSError *)error;

@end

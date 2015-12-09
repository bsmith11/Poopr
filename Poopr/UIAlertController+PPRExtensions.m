//
//  UIAlertController+PPRSettings.m
//  Poopr
//
//  Created by Bradley Smith on 9/17/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UIAlertController+PPRExtensions.h"

static NSString * const kPPRAlertControllerSettingsNotificationTitle = @"Notifications Disabled";
static NSString * const kPPRAlertControllerSettingsNotificationMessage = @"To enable notifications, go to Settings.";
static NSString * const kPPRAlertControllerSettingsActionTitle = @"Settings";
static NSString * const kPPRAlertControllerOKActionTitle = @"OK";
static NSString * const kPPRAlertControllerErrorTitle = @"Error";
static NSString * const kPPRAlertControllerErrorMessageDefault = @"The request failed, please try again later";

@implementation UIAlertController (PPRExtensions)

+ (instancetype)ppr_alertControllerForNotificationSettings {
    return [self ppr_alertControllerForSettingsWithTitle:kPPRAlertControllerSettingsNotificationTitle message:kPPRAlertControllerSettingsNotificationMessage];
}

+ (instancetype)ppr_alertControllerForSettingsWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:kPPRAlertControllerSettingsActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            [[UIApplication sharedApplication] openURL:URL];
        }
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kPPRAlertControllerOKActionTitle style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:settingsAction];
    [alertController addAction:okAction];

    return alertController;
}

+ (instancetype)ppr_alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kPPRAlertControllerOKActionTitle style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];

    return alertController;
}

+ (instancetype)ppr_alertControllerWithError:(NSError *)error {
    NSString *message = error.localizedDescription ?: kPPRAlertControllerErrorMessageDefault;

    return [self ppr_alertControllerWithTitle:kPPRAlertControllerErrorTitle message:message];
}

@end

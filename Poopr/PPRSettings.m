//
//  PPRSettings.m
//  Poopr
//
//  Created by Bradley Smith on 9/14/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import CoreGraphics;

#import "PPRSettings.h"

#import "NSNumber+PPRCGFloat.h"

static NSString * const kPPRSettingsUserDefaultsKeyRadius = @"com.poopr.settings.radius";
static NSString * const kPPRSettingsUserDefaultsKeyPoopNotificationsEnabled = @"com.poopr.settings.poopNotificationsEnabled";
static NSString * const kPPRSettingsUserDefaultsKeyCommentNotificationsEnabled = @"com.poopr.settings.commentNotificationsEnabled";
static NSString * const kPPRSettingsUserDefaultsKeyHasPromptedPermissions = @"com.poopr.settings.hasPromptedPermissions";
static NSString * const kPPRSettingsUserDefaultsKeyDidSkipNotificationPermission = @"com.poopr.settings.didSkipNotificationPermission";

static CGFloat const kPPRSettingsDefaultValueRadius = 1000.0f;

@implementation PPRSettings

+ (NSNumber *)radius {
    NSNumber *radius = [[NSUserDefaults standardUserDefaults] objectForKey:kPPRSettingsUserDefaultsKeyRadius];

    if (!radius) {
        radius = @(kPPRSettingsDefaultValueRadius);
        [self setRadius:radius];
    }

    return radius;
}

+ (void)setRadius:(NSNumber *)radius {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:radius forKey:kPPRSettingsUserDefaultsKeyRadius];
    [userDefaults synchronize];
}

+ (BOOL)poopNotificationsEnabled {
    NSNumber *enabled = [[NSUserDefaults standardUserDefaults] objectForKey:kPPRSettingsUserDefaultsKeyPoopNotificationsEnabled];

    if (!enabled) {
        enabled = @(NO);
        [self setPoopNotificationsEnabled:enabled.boolValue];
    }

    return enabled.boolValue;
}

+ (void)setPoopNotificationsEnabled:(BOOL)poopNotificationsEnabled {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(poopNotificationsEnabled) forKey:kPPRSettingsUserDefaultsKeyPoopNotificationsEnabled];
    [userDefaults synchronize];
}

+ (BOOL)commentNotificationsEnabled {
    NSNumber *enabled = [[NSUserDefaults standardUserDefaults] objectForKey:kPPRSettingsUserDefaultsKeyCommentNotificationsEnabled];

    if (!enabled) {
        enabled = @(NO);
        [self setCommentNotificationsEnabled:enabled.boolValue];
    }

    return enabled.boolValue;
}

+ (void)setCommentNotificationsEnabled:(BOOL)commentNotificationsEnabled {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(commentNotificationsEnabled) forKey:kPPRSettingsUserDefaultsKeyCommentNotificationsEnabled];
    [userDefaults synchronize];
}

+ (BOOL)hasPromptedPermissions {
    NSNumber *status = [[NSUserDefaults standardUserDefaults] objectForKey:kPPRSettingsUserDefaultsKeyHasPromptedPermissions];

    if (!status) {
        status = @(NO);
        [self setHasPromptedPermissions:status.boolValue];
    }

    return status.boolValue;
}

+ (void)setHasPromptedPermissions:(BOOL)hasPromptedPermissions {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(hasPromptedPermissions) forKey:kPPRSettingsUserDefaultsKeyHasPromptedPermissions];
    [userDefaults synchronize];
}

+ (BOOL)didSkipNotificationPermission {
    NSNumber *status = [[NSUserDefaults standardUserDefaults] objectForKey:kPPRSettingsUserDefaultsKeyDidSkipNotificationPermission];

    if (!status) {
        status = @(NO);
        [self setDidSkipNotificationPermission:status.boolValue];
    }

    return status.boolValue;
}

+ (void)setDidSkipNotificationPermission:(BOOL)didSkipNotificationPermission {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(didSkipNotificationPermission) forKey:kPPRSettingsUserDefaultsKeyDidSkipNotificationPermission];
    [userDefaults synchronize];
}

@end

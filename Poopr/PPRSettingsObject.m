//
//  PPRSettingsObject.m
//  Poopr
//
//  Created by Bradley Smith on 9/16/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRSettingsObject.h"

#import "PPRSettings.h"
#import "PPRAppDelegate.h"

static NSString * const kPPRSettingsObjectNotificationTitlePoop = @"Poop Notifications";
static NSString * const kPPRSettingsObjectNotificationTitleComment = @"Comment Notifications";

@interface PPRSettingsObject ()

@property (copy, nonatomic, readwrite) NSString *title;

@property (assign, nonatomic, readwrite) PPRSettingsObjectType type;

@end

@implementation PPRSettingsObject

+ (instancetype)settingsObjectWithType:(PPRSettingsObjectType)type {
    PPRSettingsObject *settingsObject = [[PPRSettingsObject alloc] init];

    settingsObject.type = type;
    settingsObject.title = [self titleForType:type];

    return settingsObject;
}

+ (NSString *)titleForType:(PPRSettingsObjectType)type {
    NSString *title = nil;

    switch (type) {
        case PPRSettingsObjectTypeRadius:
            title = nil;
            break;

        case PPRSettingsObjectTypeNotificationPoop:
            title = kPPRSettingsObjectNotificationTitlePoop;
            break;

        case PPRSettingsObjectTypeNotificationComment:
            title = kPPRSettingsObjectNotificationTitleComment;
            break;
    }

    return title;
}

- (CGFloat)min {
    CGFloat min = 0.0f;

    if (self.type == PPRSettingsObjectTypeRadius) {
        min = 1000.0f;
    }

    return min;
}

- (void)setMin:(CGFloat)min {
    if (self.type == PPRSettingsObjectTypeRadius) {

    }
}

- (CGFloat)max {
    CGFloat max = 0.0f;

    if (self.type == PPRSettingsObjectTypeRadius) {
        max = 10000.0f;
    }

    return max;
}

- (void)setMax:(CGFloat)max {
    if (self.type == PPRSettingsObjectTypeRadius) {

    }
}

- (CGFloat)value {
    CGFloat value = 0.0f;

    if (self.type == PPRSettingsObjectTypeRadius) {
        value = [PPRSettings radius].CGFloatValue;
    }

    return value;
}

- (void)setValue:(CGFloat)value {
    if (self.type == PPRSettingsObjectTypeRadius) {
        [PPRSettings setRadius:@(value)];
    }
}

- (BOOL)enabled {
    BOOL enabled = NO;

    if (self.type == PPRSettingsObjectTypeNotificationPoop) {
        enabled = [PPRSettings poopNotificationsEnabled];
    }
    else if (self.type == PPRSettingsObjectTypeNotificationComment) {
        enabled = [PPRSettings commentNotificationsEnabled];
    }

    return enabled;
}

- (void)setEnabled:(BOOL)enabled {
    if (self.type == PPRSettingsObjectTypeNotificationPoop) {
        [PPRSettings setPoopNotificationsEnabled:enabled];
    }
    else if (self.type == PPRSettingsObjectTypeNotificationComment) {
        [PPRSettings setCommentNotificationsEnabled:enabled];
    }
}

- (void)setEnabled:(BOOL)enabled completion:(void (^)(BOOL granted, BOOL displayAlert))completion {
    if (self.type == PPRSettingsObjectTypeNotificationPoop || self.type == PPRSettingsObjectTypeNotificationComment) {
        PPRAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

        if (appDelegate.notificationPermissionEnabled) {
            [self setEnabled:enabled];

            if (completion) {
                completion(YES, NO);
            }
        }
        else {
            if ([PPRSettings didSkipNotificationPermission]) {
                [PPRSettings setDidSkipNotificationPermission:NO];

                [appDelegate requestNotificationPermissionWithCompletion:^(BOOL granted) {
                    if (granted) {
                        [self setEnabled:enabled];
                    }
                    else {
                        [self setEnabled:NO];
                    }

                    if (completion) {
                        completion(granted, NO);
                    }
                }];
            }
            else {
                [self setEnabled:NO];

                if (completion) {
                    completion(NO, YES);
                }
            }
        }
    }
    else {
        if (completion) {
            completion(NO, NO);
        }
    }
}

@end

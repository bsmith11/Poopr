//
//  PPRSettings.h
//  Poopr
//
//  Created by Bradley Smith on 9/14/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import Foundation;

#import "NSNumber+PPRCGFloat.h"

@interface PPRSettings : NSObject

+ (NSNumber *)radius;
+ (void)setRadius:(NSNumber *)radius;

+ (BOOL)poopNotificationsEnabled;
+ (void)setPoopNotificationsEnabled:(BOOL)poopNotificationsEnabled;

+ (BOOL)commentNotificationsEnabled;
+ (void)setCommentNotificationsEnabled:(BOOL)commentNotificationsEnabled;

+ (BOOL)hasPromptedPermissions;
+ (void)setHasPromptedPermissions:(BOOL)hasPromptedPermissions;

+ (BOOL)didSkipNotificationPermission;
+ (void)setDidSkipNotificationPermission:(BOOL)didSkipNotificationPermission;

@end

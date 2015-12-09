//
//  PPRPermissionObject.m
//  Poopr
//
//  Created by Bradley Smith on 9/16/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPermissionObject.h"

static NSString * const kPPRPermissionRequestTitleLocationServices = @"Location Services";
static NSString * const kPPRPermissionRequestTitleNotifications = @"Notifications";

@interface PPRPermissionObject ()

@property (copy, nonatomic, readwrite) NSString *request;

@property (assign, nonatomic, readwrite) PPRPermissionObjectType type;

@end

@implementation PPRPermissionObject

+ (instancetype)permissionObjectWithType:(PPRPermissionObjectType)type {
    PPRPermissionObject *permissionObject = [[PPRPermissionObject alloc] init];

    permissionObject.type = type;
    permissionObject.request = [self titleForType:type];

    return permissionObject;
}

+ (NSString *)titleForType:(PPRPermissionObjectType)type {
    NSString *title = nil;

    switch (type) {
        case PPRPermissionObjectTypeLocationServices:
            title = kPPRPermissionRequestTitleLocationServices;
            break;

        case PPRPermissionObjectTypeNotifications:
            title = kPPRPermissionRequestTitleNotifications;
            break;
    }

    return title;
}

@end

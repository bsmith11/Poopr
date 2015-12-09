//
//  PPRPermissionObject.h
//  Poopr
//
//  Created by Bradley Smith on 9/16/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, PPRPermissionObjectType) {
    PPRPermissionObjectTypeLocationServices,
    PPRPermissionObjectTypeNotifications
};

@interface PPRPermissionObject : NSObject

+ (instancetype)permissionObjectWithType:(PPRPermissionObjectType)type;

@property (copy, nonatomic, readonly) NSString *request;

@property (assign, nonatomic, readonly) PPRPermissionObjectType type;

@end

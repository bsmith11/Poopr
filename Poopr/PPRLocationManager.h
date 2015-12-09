//
//  PPRLocationManager.h
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import Foundation;

@class CLLocation;

typedef NS_ENUM(NSInteger, PPRLocationServicesPermissionState) {
    PPRLocationServicesPermissionStateNotDetermined,
    PPRLocationServicesPermissionStateDisabled,
    PPRLocationServicesPermissionStateUnauthorized,
    PPRLocationServicesPermissionStateAuthorizedWhenInUse,
    PPRLocationServicesPermissionStateAuthorizedAlways
};

typedef void (^PPRLocationManagerPermissionBlock)(PPRLocationServicesPermissionState state);

@interface PPRLocationManager : NSObject

+ (instancetype)sharedInstance;
+ (PPRLocationServicesPermissionState)state;

- (void)requestWhenInUsePermissionWithCompletion:(PPRLocationManagerPermissionBlock)completion;
- (void)requestAlwaysPermissionWithCompletion:(PPRLocationManagerPermissionBlock)completion;

- (void)requestLocationWithCompletion:(void (^)(CLLocation *location))completion;
- (void)checkForRecentNearbyPoops;

@property (strong, nonatomic, readonly) CLLocation *lastKnownLocation;

@end

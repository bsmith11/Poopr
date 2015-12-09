//
//  PPRLocationManager.m
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import CoreLocation;

#import "PPRLocationManager.h"

#import "PPRPoop+Parse.h"

#import "PPRErrorManager.h"
#import "PPRLog.h"
#import "PPRSettings.h"

#import <INTULocationManager/INTULocationManager.h>

static NSTimeInterval const kPPRLocationManagerTimeoutInterval = 5.0;

@interface PPRLocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic, readwrite) CLLocation *lastKnownLocation;

@property (copy, nonatomic) PPRLocationManagerPermissionBlock permissionBlock;

@property (assign, nonatomic) BOOL isInitialStatusUpdate;

@end

@implementation PPRLocationManager

#pragma mark - Lifecycle

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _isInitialStatusUpdate = YES;

        [self setupLocationManager];
    }

    return self;
}

#pragma mark - Setup

- (void)setupLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
}

#pragma mark - Permission State

+ (PPRLocationServicesPermissionState)state {
    PPRLocationServicesPermissionState state;

    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            state = PPRLocationServicesPermissionStateNotDetermined;
            break;

        case kCLAuthorizationStatusRestricted:
            state = PPRLocationServicesPermissionStateUnauthorized;
            break;

        case kCLAuthorizationStatusDenied:
            state = [CLLocationManager locationServicesEnabled] ? PPRLocationServicesPermissionStateDisabled : PPRLocationServicesPermissionStateUnauthorized;
            break;

        case kCLAuthorizationStatusAuthorizedWhenInUse:
            state = PPRLocationServicesPermissionStateAuthorizedWhenInUse;
            break;

        case kCLAuthorizationStatusAuthorizedAlways:
            state = PPRLocationServicesPermissionStateAuthorizedAlways;
            break;
    }
    
    return state;
}

#pragma mark - Actions

- (void)requestWhenInUsePermissionWithCompletion:(PPRLocationManagerPermissionBlock)completion {
    if ([PPRLocationManager state] == PPRLocationServicesPermissionStateNotDetermined) {
        self.permissionBlock = completion;
        [self.locationManager requestWhenInUseAuthorization];
    }
    else {
        if (completion) {
            completion([PPRLocationManager state]);
        }
    }
}

- (void)requestAlwaysPermissionWithCompletion:(PPRLocationManagerPermissionBlock)completion {
    if ([PPRLocationManager state] == PPRLocationServicesPermissionStateNotDetermined ||
        [PPRLocationManager state] == PPRLocationServicesPermissionStateAuthorizedWhenInUse) {
        self.permissionBlock = completion;
        [self.locationManager requestAlwaysAuthorization];
    }
    else {
        if (completion) {
            completion([PPRLocationManager state]);
        }
    }
}

- (void)requestLocationWithCompletion:(void (^)(CLLocation *location))completion {
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:kPPRLocationManagerTimeoutInterval block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        self.lastKnownLocation = currentLocation;

        if (completion) {
            completion(currentLocation);
        }
    }];
}

- (void)checkForRecentNearbyPoops {
    [self requestLocationWithCompletion:^(CLLocation *location) {
        [PPRPoop downloadPoopsNearLocation:location radius:[PPRSettings radius].CGFloatValue timeInterval:3600 completion:^(NSArray *poops, NSError *error) {
            [PPRErrorManager handleError:error];

            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date];

            NSString *alertBody;
            if (poops.count == 1) {
                alertBody = @"One person is pooping near you right now!";
            }
            else {
                alertBody = [NSString stringWithFormat:@"%@ people are pooping near you right now!", @(poops.count)];
            }

            notification.alertBody = alertBody;

            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }];
    }];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    DDLogInfo(@"Location Manager Authorization Status: %@", [self stringForAuthorizationStatus:status]);

    if (self.isInitialStatusUpdate) {
        self.isInitialStatusUpdate = NO;
    }
    else {
        if (self.permissionBlock) {
            self.permissionBlock([PPRLocationManager state]);
            self.permissionBlock = nil;
        }
    }
}

#pragma mark - Helper

- (NSString *)stringForAuthorizationStatus:(CLAuthorizationStatus)status {
    NSString *string = nil;

    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            string = @"Not Determined";
            break;

        case kCLAuthorizationStatusRestricted:
            string = @"Restricted";
            break;

        case kCLAuthorizationStatusDenied:
            string = @"Denied";
            break;

        case kCLAuthorizationStatusAuthorizedWhenInUse:
            string = @"Authorized When In Use";
            break;

        case kCLAuthorizationStatusAuthorizedAlways:
            string = @"Authorized Always";
            break;
    }

    return string;
}

@end

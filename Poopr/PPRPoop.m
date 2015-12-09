//
//  PPRPoop.m
//  Poopr
//
//  Created by Bradley Smith on 9/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import MapKit;

#import "PPRPoop.h"
#import "PPRPlacemark.h"

#import "PPRLocationManager.h"

@implementation PPRPoop

- (NSString *)distanceFromCurrentLocation {
    NSString *distanceString = nil;

    if (self.placemark.latitude && self.placemark.longitude) {
        CLLocation *currentLocation = [PPRLocationManager sharedInstance].lastKnownLocation;
        CLLocation *poopLocation = [[CLLocation alloc] initWithLatitude:self.placemark.latitude.doubleValue longitude:self.placemark.longitude.doubleValue];

        CLLocationDistance distance = [currentLocation distanceFromLocation:poopLocation];
        distanceString = [NSString stringWithFormat:@"%ld m", lround(distance)];
    }
    else {
        distanceString = @"N/A";
    }

    return distanceString;
}

@end

//
//  PFObject+PPRExtensions.m
//  Poopr
//
//  Created by Bradley Smith on 9/13/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import ObjectiveC.runtime;
@import CoreLocation;

#import "PFObject+PPRExtensions.h"

#import "PPRParseConstants.h"

#import <RZDataBinding/RZDBMacros.h>

@implementation PFObject (PPRExtensions)

+ (NSArray *)ppr_arrayFromObjects:(NSArray *)objects {
    NSMutableArray *array = [NSMutableArray array];

    for (PFObject *object in objects) {
        [array addObject:[object ppr_dictionary]];
    }

    return array;
}

- (NSDictionary *)ppr_dictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.objectId) {
        dictionary[kPPRParseResponseKeyObjectID] = self.objectId;
    }

    if (self.createdAt) {
        dictionary[kPPRParseResponseKeyCreatedAt] = self.createdAt;
    }

    if (self.updatedAt) {
        dictionary[kPPRParseResponseKeyUpdatedAt] = self.updatedAt;
    }

    for (NSString *key in [self allKeys]) {
        id value = [self objectForKey:key];

        if (value) {
            if ([value isKindOfClass:[NSString class]] ||
                [value isKindOfClass:[NSNumber class]] ||
                [value isKindOfClass:[NSDate class]]) {
                dictionary[key] = value;
            }
            else if ([value isKindOfClass:[PFGeoPoint class]]) {
                PFGeoPoint *geoPoint = (PFGeoPoint *)value;
                dictionary[key] = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
            }
            else if ([value isKindOfClass:[PFObject class]]) {
                dictionary[key] = [value ppr_dictionary];
            }
            else if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [NSMutableArray array];

                for (id object in value) {
                    if ([object isKindOfClass:[PFObject class]]) {
                        [array addObject:[object ppr_dictionary]];
                    }
                }

                dictionary[key] = array;
            }
        }
    }

    return dictionary;
}

- (void)ppr_setupWithPlacemark:(CLPlacemark *)placemark location:(CLLocation *)location {
    if (placemark.name) {
        self[RZDB_KP_OBJ(placemark, name)] = placemark.name;
    }

    if (placemark.thoroughfare) {
        self[RZDB_KP_OBJ(placemark, thoroughfare)] = placemark.thoroughfare;
    }

    if (placemark.subThoroughfare) {
        self[RZDB_KP_OBJ(placemark, subThoroughfare)] = placemark.subThoroughfare;
    }

    if (placemark.locality) {
        self[RZDB_KP_OBJ(placemark, locality)] = placemark.locality;
    }

    if (placemark.subLocality) {
        self[RZDB_KP_OBJ(placemark, subLocality)] = placemark.subLocality;
    }

    if (placemark.administrativeArea) {
        self[RZDB_KP_OBJ(placemark, administrativeArea)] = placemark.administrativeArea;
    }

    if (placemark.subAdministrativeArea) {
        self[RZDB_KP_OBJ(placemark, subAdministrativeArea)] = placemark.subAdministrativeArea;
    }

    if (placemark.postalCode) {
        self[RZDB_KP_OBJ(placemark, postalCode)] = placemark.postalCode;
    }

    if (placemark.ISOcountryCode) {
        self[@"countryCode"] = placemark.ISOcountryCode;
    }

    if (placemark.country) {
        self[RZDB_KP_OBJ(placemark, country)] = placemark.country;
    }

    if (location) {
        self[kPPRParseRequestKeyLocation] = [PFGeoPoint geoPointWithLocation:location];
    }
}

@end

//
//  PPRPlacemark+RZImport.m
//  Poopr
//
//  Created by Bradley Smith on 9/12/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import CoreLocation;

#import "PPRPlacemark+RZImport.h"

#import "PPRParseConstants.h"

#import <RZDataBinding/RZDBMacros.h>
#import <RZVinyl/RZVinyl.h>

static NSString * const kPPRPlacemarkAddressStringFormat = @"%@ %@, %@ %@";

@implementation PPRPlacemark (RZImport)

#pragma mark - RZ Importable Protocol

+ (NSString *)rzv_externalPrimaryKey {
    return kPPRParseResponseKeyObjectID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(PPRPlacemark, placemarkID);
}

+ (NSDictionary *)rzi_customMappings {
    return nil;
}

+ (NSArray *)rzi_ignoredKeys {
    return nil;
}

+ (NSString *)rzi_dateFormatForKey:(NSString *)key {
    return kPPRParseDateFormat;
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([value isKindOfClass:[NSNull class]]) {
        return NO;
    }
    else {
        if ([value isKindOfClass:[CLLocation class]]) {
            CLLocation *location = (CLLocation *)value;

            self.latitude = @(location.coordinate.latitude);
            self.longitude = @(location.coordinate.longitude);

            return NO;
        }

        return [super rzi_shouldImportValue:value forKey:key inContext:context];
    }
}

#pragma mark - Setup

- (NSString *)address {
    return [NSString stringWithFormat:kPPRPlacemarkAddressStringFormat, self.name, self.locality, self.administrativeArea, self.postalCode];
}

@end

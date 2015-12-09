//
//  PPRPoop+RZImport.m
//  Poopr
//
//  Created by Bradley Smith on 9/12/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPoop+RZImport.h"
#import "PPRPlacemark+RZImport.h"

#import "PPRParseConstants.h"
#import "PPRCoreDataStack.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>
#import <RZCollectionList/RZCollectionList.h>

@implementation PPRPoop (RZImport)

#pragma mark - Importable Protocol

+ (NSString *)rzv_externalPrimaryKey {
    return kPPRParseResponseKeyObjectID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(PPRPoop, poopID);
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

#pragma mark - Collection Lists

+ (RZFetchedCollectionList *)fetchedListOfPoops {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];
    request.sortDescriptors = @[[self createdAtSortDescriptor]];

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[self rzv_coreDataStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];

    return fetchedList;
}

+ (RZFetchedCollectionList *)fetchedListOfPoopsNearLocation:(CLLocation *)location radius:(CGFloat)radius {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];
    request.sortDescriptors = @[[self createdAtSortDescriptor]];
    request.predicate = [self predicateNearLocation:location radius:radius];

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[self rzv_coreDataStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];

    return fetchedList;
}

+ (RZFetchedCollectionList *)fetchedListOfPoopsRecentlyAdded {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];
    request.sortDescriptors = @[[self createdAtSortDescriptor]];

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[self rzv_coreDataStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];

    return fetchedList;
}

+ (NSSortDescriptor *)createdAtSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(PPRPoop, createdAt) ascending:NO];
}

+ (NSPredicate *)predicateNearLocation:(CLLocation *)location radius:(CGFloat)radius {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        id placemarkObject = [object valueForKey:RZDB_KP(PPRPoop, placemark)];
        NSNumber *latitude = [placemarkObject valueForKey:RZDB_KP(PPRPlacemark, latitude)];
        NSNumber *longitude = [placemarkObject valueForKey:RZDB_KP(PPRPlacemark, longitude)];
        CLLocation *locationObject = [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];

        return ([location distanceFromLocation:locationObject] <= radius);
    }];

    return predicate;
}

#pragma mark - Annotation Protocol

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.placemark.latitude.doubleValue, self.placemark.longitude.doubleValue);
}

- (NSString *)title {
    return self.placemark.address;
}

@end

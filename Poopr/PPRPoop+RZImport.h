//
//  PPRPoop+RZImport.h
//  Poopr
//
//  Created by Bradley Smith on 9/12/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import MapKit;

#import "PPRPoop.h"

#import <RZImport/RZImportable.h>

@class RZFetchedCollectionList;

@interface PPRPoop (RZImport) <RZImportable, MKAnnotation>

+ (RZFetchedCollectionList *)fetchedListOfPoops;
+ (RZFetchedCollectionList *)fetchedListOfPoopsNearLocation:(CLLocation *)location radius:(CGFloat)radius;
+ (RZFetchedCollectionList *)fetchedListOfPoopsRecentlyAdded;

+ (NSPredicate *)predicateNearLocation:(CLLocation *)location radius:(CGFloat)radius;

@end

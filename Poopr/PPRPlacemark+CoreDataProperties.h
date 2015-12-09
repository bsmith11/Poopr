//
//  PPRPlacemark+CoreDataProperties.h
//  Poopr
//
//  Created by Bradley Smith on 9/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PPRPlacemark.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPRPlacemark (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *administrativeArea;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSString *countryCode;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSString *locality;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *placemarkID;
@property (nullable, nonatomic, retain) NSString *postalCode;
@property (nullable, nonatomic, retain) NSString *subAdministrativeArea;
@property (nullable, nonatomic, retain) NSString *subLocality;
@property (nullable, nonatomic, retain) NSString *subThoroughfare;
@property (nullable, nonatomic, retain) NSString *thoroughfare;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) PPRPoop *poop;

@end

NS_ASSUME_NONNULL_END

//
//  PPRPoop+CoreDataProperties.h
//  Poopr
//
//  Created by Bradley Smith on 9/23/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PPRPoop.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPRPoop (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *poopID;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSString *authorID;
@property (nullable, nonatomic, retain) NSSet<PPRComment *> *comments;
@property (nullable, nonatomic, retain) PPRPlacemark *placemark;

@end

@interface PPRPoop (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(PPRComment *)value;
- (void)removeCommentsObject:(PPRComment *)value;
- (void)addComments:(NSSet<PPRComment *> *)values;
- (void)removeComments:(NSSet<PPRComment *> *)values;

@end

NS_ASSUME_NONNULL_END

//
//  PPRComment+CoreDataProperties.h
//  Poopr
//
//  Created by Bradley Smith on 12/6/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PPRComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPRComment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *authorID;
@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSString *commentID;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSString *localCommentID;
@property (nullable, nonatomic, retain) PPRPoop *poop;

@end

NS_ASSUME_NONNULL_END

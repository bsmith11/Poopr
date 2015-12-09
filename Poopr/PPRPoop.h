//
//  PPRPoop.h
//  Poopr
//
//  Created by Bradley Smith on 9/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PPRPlacemark, PPRComment;

NS_ASSUME_NONNULL_BEGIN

@interface PPRPoop : NSManagedObject

- (NSString *)distanceFromCurrentLocation;

@end

NS_ASSUME_NONNULL_END

#import "PPRPoop+CoreDataProperties.h"

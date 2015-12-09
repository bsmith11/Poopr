//
//  PPRComment+RZImport.m
//  Poopr
//
//  Created by Bradley Smith on 9/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRComment+RZImport.h"

#import "PPRPoop.h"

#import "PPRParseConstants.h"

#import <RZDataBinding/RZDBMacros.h>
#import <RZVinyl/RZVinyl.h>

@implementation PPRComment (RZImport)

#pragma mark - RZ Importable Protocol

+ (NSString *)rzv_externalPrimaryKey {
    return kPPRParseResponseKeyObjectID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(PPRComment, commentID);
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

+ (NSFetchedResultsController *)fetchedResultsControllerWithPoop:(PPRPoop *)poop {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];
    request.sortDescriptors = @[[self createdAtSortDescriptor]];
    request.predicate = [self predicateWithPoop:poop];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:[self rzv_coreDataStack].mainManagedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];

    return fetchedResultsController;
}

+ (NSSortDescriptor *)createdAtSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(PPRComment, createdAt) ascending:YES];
}

+ (NSPredicate *)predicateWithPoop:(PPRPoop *)poop {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(PPRComment, poop), poop];

    return predicate;
}

@end

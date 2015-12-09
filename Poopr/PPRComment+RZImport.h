//
//  PPRComment+RZImport.h
//  Poopr
//
//  Created by Bradley Smith on 9/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRComment.h"

#import <RZImport/RZImportable.h>

@class RZFetchedCollectionList, PPRPoop;

@interface PPRComment (RZImport) <RZImportable>

+ (NSFetchedResultsController *)fetchedResultsControllerWithPoop:(PPRPoop *)poop;

@end

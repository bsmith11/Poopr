//
//  PPRCoreDataStack.m
//  Poopr
//
//  Created by Bradley Smith on 9/12/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRCoreDataStack.h"

#import "AssertMacros.h"

@implementation PPRCoreDataStack

+ (void)configureStack {
    RZCoreDataStackOptions options = RZCoreDataStackOptionDeleteDatabaseIfUnreadable | RZCoreDataStackOptionsEnableAutoStalePurge;
    PPRCoreDataStack *stack = [[PPRCoreDataStack alloc] initWithModelName:@"Poopr"
                                                            configuration:nil
                                                                storeType:NSInMemoryStoreType
                                                                 storeURL:nil
                                                                  options:options];
    __Check(stack);
    [PPRCoreDataStack setDefaultStack:stack];
}

@end

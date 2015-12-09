//
//  PPRPlacemark+RZImport.h
//  Poopr
//
//  Created by Bradley Smith on 9/12/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPlacemark.h"

#import <RZImport/RZImportable.h>

@interface PPRPlacemark (RZImport) <RZImportable>

- (NSString *)address;

@end

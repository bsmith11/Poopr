//
//  PFObject+PPRExtensions.h
//  Poopr
//
//  Created by Bradley Smith on 9/13/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import <Parse/Parse.h>

@class CLPlacemark, CLLocation;

@interface PFObject (PPRExtensions)

+ (NSArray *)ppr_arrayFromObjects:(NSArray *)objects;

- (NSDictionary *)ppr_dictionary;

- (void)ppr_setupWithPlacemark:(CLPlacemark *)placemark location:(CLLocation *)location;

@end

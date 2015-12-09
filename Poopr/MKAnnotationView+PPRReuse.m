//
//  MKAnnotationView+PPRReuse.m
//  Poopr
//
//  Created by Bradley Smith on 9/13/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "MKAnnotationView+PPRReuse.h"

@implementation MKAnnotationView (PPRReuse)

+ (NSString *)ppr_reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end

//
//  NSNumber+PPRCGFloat.m
//  Poopr
//
//  Created by Bradley Smith on 9/25/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "NSNumber+PPRCGFloat.h"

@implementation NSNumber (PPRCGFloat)

- (CGFloat)CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return self.doubleValue;
#else
    return self.floatValue;
#endif
}

@end

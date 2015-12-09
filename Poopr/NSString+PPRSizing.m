//
//  NSString+PPRSizing.m
//  Poopr
//
//  Created by Bradley Smith on 9/12/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

#import "NSString+PPRSizing.h"

#import <tgmath.h>

@implementation NSString (PPRSizing)

- (CGFloat)ppr_heightForSize:(CGSize)size attributes:(NSDictionary *)attributes {
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    CGRect boundingRect = [self boundingRectWithSize:size options:options attributes:attributes context:NULL];

    return __tg_ceil(CGRectGetHeight(boundingRect));
}

@end

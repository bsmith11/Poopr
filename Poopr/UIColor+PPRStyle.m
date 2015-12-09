//
//  UIColor+PPRStyle.m
//  Poopr
//
//  Created by Bradley Smith on 12/2/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UIColor+PPRStyle.h"

#import <RZUtils/UIColor+RZExtensions.h>

@implementation UIColor (PPRStyle)

+ (UIColor *)ppr_cocoaColor {
    return [UIColor rz_colorFromHexString:@"301B28"];
}

+ (UIColor *)ppr_chocolateColor {
    return [UIColor rz_colorFromHexString:@"523634"];
}

+ (UIColor *)ppr_toffeeColor {
    return [UIColor rz_colorFromHexString:@"B6452C"];
}

+ (UIColor *)ppr_frostingColor {
    return [UIColor rz_colorFromHexString:@"DDC5A2"];
}

@end

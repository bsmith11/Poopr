//
//  UIFont+PPRStyle.m
//  Poopr
//
//  Created by Bradley Smith on 12/2/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UIFont+PPRStyle.h"

@implementation UIFont (PPRStyle)

+ (UIFont *)ppr_extraExtraSmallFont {
    return [UIFont fontWithName:@"DINCond-Bold" size:12.0f];
}

+ (UIFont *)ppr_extraSmallFont {
    return [UIFont fontWithName:@"DINCond-Bold" size:18.0f];
}

+ (UIFont *)ppr_smallFont {
    return [UIFont fontWithName:@"DINCond-Bold" size:36.0f];
}

+ (UIFont *)ppr_mediumFont {
    return [UIFont fontWithName:@"DINCond-Bold" size:54.0f];
}

+ (UIFont *)ppr_largeFont {
    return [UIFont fontWithName:@"DINCond-Bold" size:72.0f];
}

+ (UIFont *)ppr_extraLargeFont {
    return [UIFont fontWithName:@"DINCond-Bold" size:90.0f];
}

@end

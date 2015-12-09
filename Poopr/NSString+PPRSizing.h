//
//  NSString+PPRSizing.h
//  Poopr
//
//  Created by Bradley Smith on 9/12/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

@interface NSString (PPRSizing)

- (CGFloat)ppr_heightForSize:(CGSize)size attributes:(NSDictionary *)attributes;

@end

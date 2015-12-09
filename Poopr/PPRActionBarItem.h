//
//  PPRActionBarItem.h
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface PPRActionBarItem : UIView

+ (instancetype)actionBarItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;
+ (instancetype)actionBarItemWithActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView;

- (void)transformImage:(CGAffineTransform)transform;

@end

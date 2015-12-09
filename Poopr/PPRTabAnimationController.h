//
//  PPRTabAnimationController.h
//  Poopr
//
//  Created by Bradley Smith on 12/8/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, PPRTabAnimationDirection) {
    PPRTabAnimationDirectionLeft,
    PPRTabAnimationDirectionRight
};

@interface PPRTabAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) PPRTabAnimationDirection direction;

@end

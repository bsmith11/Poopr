//
//  PPRPoopDetailAnimationController.m
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRPoopDetailAnimationController.h"

#import "PPRPoopListViewController.h"

@implementation PPRPoopDetailAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];

    if (self.positive) {
        toViewController.view.frame = fromViewController.view.frame;
        [toViewController.view setNeedsLayout];
        [toViewController.view layoutIfNeeded];
    }

    [container addSubview:toViewController.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.9f
          initialSpringVelocity:(1 / CGRectGetHeight(fromViewController.view.frame))
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end

//
//  PPRTabAnimationController.m
//  Poopr
//
//  Created by Bradley Smith on 12/8/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRTabAnimationController.h"

@implementation PPRTabAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];

    [container addSubview:fromViewController.view];
    [container addSubview:toViewController.view];

    CGAffineTransform toInitialTransform;
    CGAffineTransform fromFinalTransform;

    CGFloat translation = CGRectGetWidth(container.frame);

    if (self.direction == PPRTabAnimationDirectionLeft) {
        toInitialTransform = CGAffineTransformMakeTranslation(-translation, 0.0f);
        fromFinalTransform = CGAffineTransformMakeTranslation(translation, 0.0f);
    }
    else {
        toInitialTransform = CGAffineTransformMakeTranslation(translation, 0.0f);
        fromFinalTransform = CGAffineTransformMakeTranslation(-translation, 0.0f);
    }

    toViewController.view.transform = toInitialTransform;

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.9f
          initialSpringVelocity:(1 / CGRectGetWidth(fromViewController.view.frame))
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toViewController.view.transform = CGAffineTransformIdentity;
                         fromViewController.view.transform = fromFinalTransform;
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.transform = CGAffineTransformIdentity;

                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end

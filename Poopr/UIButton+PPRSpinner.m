//
//  UIButton+PPRSpinner.m
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import ObjectiveC.runtime;

#import "UIButton+PPRSpinner.h"

static char kPPRSpinnerAssocKeyAnimating;
static char kPPRSpinnerAssocKeyTitle;
static char kPPRSpinnerAssocKeyAttributedTitle;
static char kPPRSpinnerAssocKeySpinner;

@interface UIButton (PPRSpinnerInternal)

@property (strong, nonatomic) UIActivityIndicatorView *ppr_spinner;

@property (copy, nonatomic) NSString *ppr_title;
@property (copy, nonatomic) NSAttributedString *ppr_attributedTitle;

@property (assign, nonatomic) BOOL ppr_animating;


@end

@implementation UIButton (PPRSpinner)

- (void)ppr_startAnimating {
    if (!self.ppr_spinner) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = [UIColor blackColor];
        spinner.hidesWhenStopped = YES;
        
        self.ppr_spinner = spinner;
    }

    if (!self.ppr_animating) {
        self.ppr_animating = YES;

        self.ppr_title = [self titleForState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];

        [self addSubview:self.ppr_spinner];
        self.ppr_spinner.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
        [self.ppr_spinner startAnimating];

        self.userInteractionEnabled = NO;
    }
}

- (void)ppr_stopAnimating {
    if (self.ppr_animating) {
        self.ppr_animating = NO;

        [self.ppr_spinner removeFromSuperview];
        [self.ppr_spinner stopAnimating];

        [self setTitle:self.ppr_title forState:UIControlStateNormal];

        self.userInteractionEnabled = YES;
    }
}

#pragma mark - Getters/Setters

- (UIActivityIndicatorView *)ppr_spinner {
    UIActivityIndicatorView *spinner = objc_getAssociatedObject(self, &kPPRSpinnerAssocKeySpinner);

    return spinner;
}

- (void)setPpr_spinner:(UIActivityIndicatorView *)ppr_spinner {
    objc_setAssociatedObject(self, &kPPRSpinnerAssocKeySpinner, ppr_spinner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ppr_title {
    NSString *title = objc_getAssociatedObject(self, &kPPRSpinnerAssocKeyTitle);

    return title;
}

- (void)setPpr_title:(NSString *)ppr_title {
    objc_setAssociatedObject(self, &kPPRSpinnerAssocKeyTitle, ppr_title, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSAttributedString *)ppr_attributedTitle {
    NSAttributedString *attributedTitle = objc_getAssociatedObject(self, &kPPRSpinnerAssocKeyAttributedTitle);

    return attributedTitle;
}

- (void)setPpr_attributedTitle:(NSAttributedString *)ppr_attributedTitle {
    objc_setAssociatedObject(self, &kPPRSpinnerAssocKeyAttributedTitle, ppr_attributedTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)ppr_animating {
    NSNumber *animating = objc_getAssociatedObject(self, &kPPRSpinnerAssocKeyAnimating);

    return animating.boolValue;
}

- (void)setPpr_animating:(BOOL)ppr_animating {
    objc_setAssociatedObject(self, &kPPRSpinnerAssocKeyAnimating, @(ppr_animating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

//
//  PPRCommentAccessoryView.m
//  Poopr
//
//  Created by Bradley Smith on 12/6/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRCommentAccessoryView.h"

#import "PPRCommentTextView.h"

#import "UIColor+PPRStyle.h"

#import <pop/POP.h>
#import <tgmath.h>
#import <RZDataBinding/RZDataBinding.h>

@interface PPRCommentAccessoryView () <UITextViewDelegate>

@property (strong, nonatomic) PPRCommentTextView *commentTextView;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) NSLayoutConstraint *height;
@property (strong, nonatomic) NSLayoutConstraint *submitButtonTrailing;
@property (strong, nonatomic) NSLayoutConstraint *submitButtonWidth;

@property (assign, nonatomic) BOOL hasPositionedViews;

@end

@implementation PPRCommentAccessoryView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.backgroundColor = [UIColor ppr_frostingColor];

        [self setupCommentTextView];
        [self setupSubmitButton];
        [self setupActivityIndicatorView];
        [self setupObservers];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.hasPositionedViews) {
        self.hasPositionedViews = YES;

        [self hideSubmitButtonAnimated:NO];
        CGFloat verticalInset = (CGRectGetHeight(self.frame) - self.commentTextView.font.lineHeight) / 2;
        self.commentTextView.textContainerInset = UIEdgeInsetsMake(verticalInset, 16.0f, verticalInset, 0.0f);
    }
}

#pragma mark - Setup

- (void)setupCommentTextView {
    self.commentTextView = [[PPRCommentTextView alloc] initWithFrame:CGRectZero textContainer:nil];
    self.commentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.commentTextView];

    self.commentTextView.delegate = self;
    self.commentTextView.placeholderText = @"Join the conversation";

    [self.commentTextView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.commentTextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.commentTextView.bottomAnchor].active = YES;

    [self.commentTextView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.commentTextView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setupSubmitButton {
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.submitButton];

    self.submitButton.imageView.tintColor = [UIColor ppr_chocolateColor];
    UIImage *image = [[UIImage imageNamed:@"add_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.submitButton setImage:image forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(didTapSubmitButton) forControlEvents:UIControlEventTouchUpInside];

    [self.submitButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    self.submitButtonWidth = [self.submitButton.widthAnchor constraintEqualToConstant:image.size.width + (2 * 16.0f)];
    self.submitButtonWidth.active = YES;
    [self.submitButton.leadingAnchor constraintEqualToAnchor:self.commentTextView.trailingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.submitButton.bottomAnchor].active = YES;
    self.submitButtonTrailing = [self.trailingAnchor constraintEqualToAnchor:self.submitButton.trailingAnchor];
    self.submitButtonTrailing.active = YES;

    [self.submitButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.submitButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setupActivityIndicatorView {
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.activityIndicatorView];

    self.activityIndicatorView.color = [UIColor ppr_chocolateColor];
    self.activityIndicatorView.hidesWhenStopped = YES;

    [self.activityIndicatorView.widthAnchor constraintEqualToAnchor:self.submitButton.widthAnchor].active = YES;
    [self.activityIndicatorView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.activityIndicatorView.trailingAnchor].active = YES;
}

- (void)setupObservers {
    [self.submitButton rz_addTarget:self action:@selector(didHighlightButton:) forKeyPathChange:RZDB_KP(UIButton, highlighted) callImmediately:YES];
}

#pragma mark - Actions

- (void)didHighlightButton:(NSDictionary *)change {
    BOOL highlighted = [change[kRZDBChangeKeyNew] boolValue];

    POPSpringAnimation *animation = [self.submitButton pop_animationForKey:@"scale"];
    if (!animation) {
        animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    }

    CGFloat scale = highlighted ? 0.75f : 1.0f;
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(scale, scale)];

    [self.submitButton pop_addAnimation:animation forKey:@"scale"];
}

- (void)didTapSubmitButton {
    if ([self.delegate respondsToSelector:@selector(commentAccessoryViewDidTapSubmit:)]) {
        [self.delegate commentAccessoryViewDidTapSubmit:self];
    }
}

- (void)clearText {
    [self.commentTextView clearText];

    [self hideSubmitButtonAnimated:YES];
}

- (void)addConstraint:(NSLayoutConstraint *)constraint {
    if (constraint.firstAttribute == NSLayoutAttributeHeight) {
        self.height = constraint;
    }

    [super addConstraint:constraint];
}

#pragma mark - Getters

- (NSString *)text {
    return self.commentTextView.text;
}

#pragma mark - Setters

- (void)setLoading:(BOOL)loading {
    if (_loading != loading) {
        _loading = loading;

        self.submitButton.hidden = loading;

        if (loading) {
            [self.activityIndicatorView startAnimating];
        }
        else {
            [self.activityIndicatorView stopAnimating];
        }
    }
}

#pragma mark - Animations

- (void)showSubmitButtonAnimated:(BOOL)animated {
    CGFloat constant = 0.0f;

    if (self.submitButtonTrailing.constant != constant) {
        [self animateSubmitButton:constant animated:animated];
    }
}

- (void)hideSubmitButtonAnimated:(BOOL)animated {
    CGFloat constant = -self.submitButtonWidth.constant;
    
    if (self.submitButtonTrailing.constant != constant) {
        [self animateSubmitButton:constant animated:animated];
    }
}

- (void)animateSubmitButton:(CGFloat)value animated:(BOOL)animated {
    POPSpringAnimation *animation = [self.submitButtonTrailing pop_animationForKey:@"move"];

    if (animated) {
        if (!animation) {
            animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        }

        animation.toValue = @(value);

        [self.submitButtonTrailing pop_addAnimation:animation forKey:@"move"];
    }
    else {
        if (animation) {
            [self.submitButtonTrailing pop_removeAnimationForKey:@"move"];
        }

        self.submitButtonTrailing.constant = value;
    }
}

#pragma mark - Text View Delegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [self showSubmitButtonAnimated:YES];

        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), CGFLOAT_MAX)];
        CGFloat constant = MAX(44.0f, size.height);

        if ((NSInteger)self.height.constant != (NSInteger)constant) {
            self.height.constant = constant;
        }
    }
    else {
        [self hideSubmitButtonAnimated:YES];
    }
}

@end

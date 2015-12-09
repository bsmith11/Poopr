//
//  PPRActionBarItem.m
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRActionBarItem.h"

#import <pop/POP.h>
#import <RZDataBinding/RZDataBinding.h>

@interface PPRActionBarItem ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PPRActionBarItem

#pragma mark - Lifecycle

+ (PPRActionBarItem *)actionBarItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    PPRActionBarItem *item = [[PPRActionBarItem alloc] initWithImage:image target:target action:action];

    return item;
}

+ (instancetype)actionBarItemWithActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView {
    PPRActionBarItem *item = [[PPRActionBarItem alloc] initWithWithActivityIndicatorView:activityIndicatorView];

    return item;
}

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    self = [super init];

    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        [self.heightAnchor constraintEqualToConstant:50.0f].active = YES;

        [self setupImageView];
        [self setupButton];
        [self setupObservers];

        self.imageView.image = image;
        [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

- (instancetype)initWithWithActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView {
    self = [super init];

    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = NO;
        [self.heightAnchor constraintEqualToConstant:50.0f].active = YES;

        self.activityIndicatorView = activityIndicatorView;
        [self setupActivityIndicatorView];
    }

    return self;
}

#pragma mark - Setup

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];

    self.imageView.tintColor = self.tintColor;
    self.imageView.contentMode = UIViewContentModeCenter;

    [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.imageView.bottomAnchor].active = YES;
    [self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0f].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:16.0f].active = YES;
}

- (void)setupButton {
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.button];

    [self.button.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.button.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.button.trailingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.button.bottomAnchor].active = YES;
}

- (void)setupObservers {
    [self.button rz_addTarget:self action:@selector(didHighlightButton:) forKeyPathChange:RZDB_KP(UIButton, highlighted) callImmediately:YES];
}

- (void)setupActivityIndicatorView {
    if (self.activityIndicatorView) {
        [self.activityIndicatorView removeFromSuperview];
    }

    self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.activityIndicatorView];

    [self.activityIndicatorView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.activityIndicatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0f].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.activityIndicatorView.bottomAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.activityIndicatorView.trailingAnchor constant:16.0f].active = YES;
}

#pragma mark - Actions

- (void)didHighlightButton:(NSDictionary *)change {
    BOOL highlighted = [change[kRZDBChangeKeyNew] boolValue];

    POPSpringAnimation *animation = [self.imageView pop_animationForKey:@"scale"];
    if (!animation) {
        animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    }

    CGFloat scale = highlighted ? 0.75f : 1.0f;
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(scale, scale)];

    [self.imageView pop_addAnimation:animation forKey:@"scale"];
}

- (void)transformImage:(CGAffineTransform)transform {
    self.imageView.transform = transform;
}

@end

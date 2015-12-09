//
//  PPRTabBarItem.m
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRTabBarItem.h"

#import <pop/POP.h>
#import <RZDataBinding/RZDataBinding.h>

@interface PPRTabBarItem ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;

@end

@implementation PPRTabBarItem

#pragma mark - Lifecycle

+ (PPRTabBarItem *)tabBarItemWithImage:(UIImage *)image {
    PPRTabBarItem *item = [[PPRTabBarItem alloc] initWithImage:image target:nil action:nil];

    return item;
}

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    self = [super init];

    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        [self setupImageView];
        [self setupButton];
        [self setupObservers];

        self.imageView.image = image;
        [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];

    self.imageView.tintColor = self.tintColor;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
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

- (void)addTarget:(id)target action:(SEL)action {
    [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)tintColorDidChange {
    self.imageView.tintColor = self.tintColor;
}

@end

//
//  PPRActionBar.m
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRActionBar.h"

@interface PPRActionBar ()

@property (strong, nonatomic) UIStackView *leftStackView;
@property (strong, nonatomic) UIStackView *rightStackView;

@end

@implementation PPRActionBar

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.clipsToBounds = YES;

        [self setupLeftStackView];
        [self setupRightStackView];
    }

    return self;
}

#pragma mark - Setup

- (void)setupLeftStackView {
    self.leftStackView = [[UIStackView alloc] init];
    self.leftStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.leftStackView];

    self.leftStackView.distribution = UIStackViewDistributionFillEqually;

    [self.leftStackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.leftStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
}

- (void)setupRightStackView {
    self.rightStackView = [[UIStackView alloc] init];
    self.rightStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.rightStackView];

    self.rightStackView.distribution = UIStackViewDistributionFillEqually;

    [self.rightStackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.rightStackView.trailingAnchor].active = YES;
}

#pragma mark - Getters

- (PPRActionBarItem *)leftItem {
    return self.leftStackView.arrangedSubviews.firstObject;
}

- (NSArray *)leftItems {
    return self.leftStackView.arrangedSubviews;
}

- (PPRActionBarItem *)rightItem {
    return self.rightStackView.arrangedSubviews.firstObject;
}

- (NSArray *)rightItems {
    return self.rightStackView.arrangedSubviews;
}

#pragma mark - Setters

- (void)setLeftItem:(PPRActionBarItem *)leftItem {
    for (UIView *view in self.leftStackView.arrangedSubviews) {
        [self.leftStackView removeArrangedSubview:view];
    }

    [self.leftStackView addArrangedSubview:leftItem];
}

- (void)setLeftItems:(NSArray *)leftItems {
    for (UIView *view in self.leftStackView.arrangedSubviews) {
        [self.leftStackView removeArrangedSubview:view];
    }

    for (UIView *view in leftItems) {
        [self.leftStackView addArrangedSubview:view];
    }
}

- (void)setRightItem:(PPRActionBarItem *)rightItem {
    for (UIView *view in self.rightStackView.arrangedSubviews) {
        [self.rightStackView removeArrangedSubview:view];
    }

    [self.rightStackView addArrangedSubview:rightItem];
}

- (void)setRightItems:(NSArray *)rightItems {
    for (UIView *view in self.rightStackView.arrangedSubviews) {
        [self.rightStackView removeArrangedSubview:view];
    }

    for (UIView *view in rightItems) {
        [self.rightStackView addArrangedSubview:view];
    }
}

@end

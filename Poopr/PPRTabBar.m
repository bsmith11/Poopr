//
//  PPRTabBar.m
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRTabBar.h"

#import <pop/POP.h>

@interface PPRTabBarItem ()

- (void)addTarget:(id)target action:(SEL)action;

@end

@interface PPRTabBar ()

@property (strong, nonatomic) UIStackView *stackView;
@property (strong, nonatomic) UIView *selectionView;
@property (strong, nonatomic) NSLayoutConstraint *selectionViewWidth;
@property (strong, nonatomic) NSLayoutConstraint *selectionViewCenterX;

@property (assign, nonatomic) BOOL hasSetInitialSelectedIndex;

@end

@implementation PPRTabBar

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setupStackView];
        [self setupSelectionView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.hasSetInitialSelectedIndex) {
        self.hasSetInitialSelectedIndex = YES;

        [self updateSelectionViewWidth];
        [self animateSelectionViewToIndex:self.selectedIndex];
    }
}

#pragma mark - Setup

- (void)setupStackView {
    self.stackView = [[UIStackView alloc] init];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.stackView];

    self.stackView.distribution = UIStackViewDistributionFillEqually;

    [self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0f].active = YES;
    [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor constant:0.0f].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor].active = YES;
}

- (void)setupSelectionView {
    self.selectionView = [[UIView alloc] init];
    self.selectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.selectionView];
    [self sendSubviewToBack:self.selectionView];

    [self.selectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.selectionView.bottomAnchor].active = YES;
    self.selectionViewWidth = [self.selectionView.widthAnchor constraintEqualToConstant:0.0f];
    self.selectionViewWidth.active = YES;
    self.selectionViewCenterX = [self.selectionView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    self.selectionViewCenterX.active = YES;
}

#pragma mark - Actions

- (void)addTabBarItem:(PPRTabBarItem *)item {
    [self.stackView addArrangedSubview:item];

    [item addTarget:self action:@selector(didSelectItem:)];

    [self updateSelectionViewWidth];
}

- (void)removeTabBarItem:(PPRTabBarItem *)item {
    [self.stackView removeArrangedSubview:item];

    [self updateSelectionViewWidth];
}

- (void)insertTabBarItem:(PPRTabBarItem *)item atIndex:(NSUInteger)index {
    [self.stackView insertArrangedSubview:item atIndex:index];

    [self updateSelectionViewWidth];
}

- (void)updateSelectionViewWidth {
    NSUInteger count = self.tabBarItems.count;
    CGFloat width = 0.0f;

    if (count > 0) {
        width = CGRectGetWidth(self.bounds) / count;
    }

    self.selectionViewWidth.constant = width;
}

- (void)tintColorDidChange {
    for (PPRTabBarItem *item in self.tabBarItems) {
        item.tintColor = self.tintColor;
    }
}

- (void)didSelectItem:(id)object {
    PPRTabBarItem *item = (PPRTabBarItem *)[object superview];
    NSUInteger index = [self.tabBarItems indexOfObject:item];

    if (index != NSNotFound) {
        self.selectedIndex = index;

        if ([self.delegate respondsToSelector:@selector(PPRTabBar:didSelectItemAtIndex:)]) {
            [self.delegate PPRTabBar:self didSelectItemAtIndex:index];
        }
    }
}

#pragma mark - Getters

- (NSArray<PPRTabBarItem *> *)tabBarItems {
    return self.stackView.arrangedSubviews;
}

#pragma mark - Setters

- (void)setSelectionViewColor:(UIColor *)selectionViewColor {
    _selectionViewColor = selectionViewColor;

    self.selectionView.backgroundColor = selectionViewColor;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex != selectedIndex && selectedIndex < self.tabBarItems.count) {
        _selectedIndex = selectedIndex;

        [self animateSelectionViewToIndex:selectedIndex];
    }
}

#pragma mark - Animations

- (void)animateSelectionViewToIndex:(NSUInteger)index {
    if (index < self.tabBarItems.count) {
        PPRTabBarItem *item = self.tabBarItems[index];

        [self.stackView layoutIfNeeded];

        CGFloat offset = CGRectGetMidX(self.stackView.bounds) - CGRectGetMidX(item.frame);
        offset = [self convertPoint:CGPointMake(offset, 0.0f) fromView:self.stackView].x;

        POPSpringAnimation *animation = [self.selectionViewCenterX pop_animationForKey:@"slide"];
        animation = animation ?: [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        animation.toValue = @(-offset);
        animation.springSpeed = 20.0f;

        [self.selectionViewCenterX pop_addAnimation:animation forKey:@"slide"];
    }
}

@end

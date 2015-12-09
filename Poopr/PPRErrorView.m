//
//  PPRErrorView.m
//  Poopr
//
//  Created by Bradley Smith on 12/8/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRErrorView.h"

#import "UIFont+PPRStyle.h"
#import "UIColor+PPRStyle.h"

@interface PPRErrorView ()

@property (strong, nonatomic) UIImageView *errorImageView;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *errorButton;

@end

@implementation PPRErrorView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setupErrorImageView];
        [self setupErrorLabel];
        [self setupErrorButton];

        self.backgroundColor = [UIColor ppr_cocoaColor];
    }

    return self;
}

#pragma mark - Setup

- (void)setupErrorImageView {
    self.errorImageView = [[UIImageView alloc] init];
    self.errorImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.errorImageView];

    self.errorImageView.contentMode = UIViewContentModeCenter;
    self.errorImageView.image = [UIImage imageNamed:@"error_icon"];
    self.errorImageView.tintColor = [UIColor ppr_frostingColor];

    [self.errorImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.errorImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0f].active = YES;

    [self.errorImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.errorImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setupErrorLabel {
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.errorLabel];

    self.errorLabel.font = [UIFont ppr_extraSmallFont];
    self.errorLabel.textColor = [UIColor ppr_frostingColor];
    self.errorLabel.textAlignment = NSTextAlignmentLeft;
    self.errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.errorLabel.numberOfLines = 0;

    [self.errorLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.errorLabel.leadingAnchor constraintEqualToAnchor:self.errorImageView.trailingAnchor constant:16.0f].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.errorLabel.trailingAnchor].active = YES;

    [self.errorLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.errorLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setupErrorButton {
    self.errorButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.errorButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.errorButton];

    [self.errorButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.errorButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.errorButton.bottomAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.errorButton.trailingAnchor].active = YES;
}

- (void)setupWithError:(NSError *)error {
    self.errorLabel.text = error.localizedDescription;
}

#pragma mark - Actions

- (void)addTarget:(id)target action:(SEL)action {
    [self.errorButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end

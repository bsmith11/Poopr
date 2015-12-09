//
//  PPRCommentTextView.m
//  Poopr
//
//  Created by Bradley Smith on 12/6/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRCommentTextView.h"

#import "UIColor+PPRStyle.h"
#import "UIFont+PPRStyle.h"

@interface PPRCommentTextView () <UITextViewDelegate>

@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation PPRCommentTextView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];

    if (self) {
        self.textColor = [UIColor ppr_chocolateColor];
        self.backgroundColor = [UIColor ppr_frostingColor];
        self.font = [UIFont ppr_extraSmallFont];
        self.tintColor = [UIColor ppr_chocolateColor];
        self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.bounces = NO;
        self.scrollEnabled = NO;
        self.textContainer.lineFragmentPadding = 0.0f;

        [self setupPlaceholderLabel];
        [self setupObservers];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.placeholderLabel.frame = CGRectMake(self.textContainerInset.left + 2.0f, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - Setup

- (void)setupPlaceholderLabel {
    self.placeholderLabel = [[UILabel alloc] init];
    [self addSubview:self.placeholderLabel];

    self.placeholderLabel.textColor = [self.textColor colorWithAlphaComponent:0.5f];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.font = self.font;
}

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - Actions

- (void)clearText {
    self.text = nil;
    
    [self textViewTextDidChange];
}

- (void)textViewTextDidChange {
    self.placeholderLabel.hidden = (self.text.length > 0);
}

#pragma mark - Getters

- (NSString *)placeholderText {
    return self.placeholderLabel.text;
}

#pragma mark - Setters

- (void)setPlaceholderText:(NSString *)placeholderText {
    self.placeholderLabel.text = placeholderText;
}

@end

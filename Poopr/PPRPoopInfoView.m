//
//  PPRPoopInfoView.m
//  Poopr
//
//  Created by Bradley Smith on 12/4/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRPoopInfoView.h"

#import "PPRPoop.h"
#import "PPRPlacemark+RZImport.h"

#import "UIFont+PPRStyle.h"
#import "UIColor+PPRStyle.h"
#import "NSDate+PPRTimeSince.h"

@interface PPRPoopInfoView ()

@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) UILabel *commentsLabel;
@property (strong, nonatomic) UILabel *addressLabel;

@end

@implementation PPRPoopInfoView

+ (NSDictionary *)attributesWithFont:(UIFont *)font
                           textColor:(UIColor *)textColor
                           alignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;

    CGFloat baselineOffset = 0.0f;
    if (font == [UIFont ppr_largeFont]) {
        paragraphStyle.maximumLineHeight = font.capHeight;
        baselineOffset = font.descender;
    }

    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:textColor,
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSBaselineOffsetAttributeName:@(baselineOffset)};

    return attributes;
}

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setupDistanceLabel];
        [self setupAddressLabel];
        [self setupTimestampLabel];
        [self setupCommentsLabel];
    }

    return self;
}

#pragma mark - Setup

- (void)setupDistanceLabel {
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.distanceLabel];

    [self.distanceLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.distanceLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0f].active = YES;
}

- (void)setupAddressLabel {
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.addressLabel];

    [self.addressLabel.topAnchor constraintEqualToAnchor:self.distanceLabel.bottomAnchor constant:16.0f].active = YES;
    [self.addressLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
}

- (void)setupTimestampLabel {
    self.timestampLabel = [[UILabel alloc] init];
    self.timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.timestampLabel];

    [self.timestampLabel.topAnchor constraintEqualToAnchor:self.addressLabel.bottomAnchor constant:16.0f].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.timestampLabel.trailingAnchor constant:16.0f].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.timestampLabel.bottomAnchor constant:16.0f].active = YES;
}

- (void)setupCommentsLabel {
    self.commentsLabel = [[UILabel alloc] init];
    self.commentsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.commentsLabel];

    [self.commentsLabel.topAnchor constraintEqualToAnchor:self.addressLabel.bottomAnchor constant:16.0f].active = YES;
    [self.commentsLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0f].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.commentsLabel.bottomAnchor constant:16.0f].active = YES;
}

- (void)setupWithPoop:(PPRPoop *)poop {
    NSString *distanceString = [poop distanceFromCurrentLocation];

    NSDictionary *distanceAttributes = [self.class attributesWithFont:[UIFont ppr_largeFont]
                                                            textColor:[UIColor ppr_frostingColor]
                                                            alignment:NSTextAlignmentLeft];
    NSAttributedString *distanceAttributedText = [[NSAttributedString alloc] initWithString:distanceString
                                                                                 attributes:distanceAttributes];
    self.distanceLabel.attributedText = distanceAttributedText;

    NSString *timestampString = [poop.createdAt ppr_timeSince] ?: @"N/A";

    NSDictionary *timestampAttributes = [self.class attributesWithFont:[UIFont ppr_extraSmallFont]
                                                             textColor:[UIColor ppr_frostingColor]
                                                             alignment:NSTextAlignmentRight];
    NSAttributedString *timestampAttributedText = [[NSAttributedString alloc] initWithString:timestampString
                                                                                  attributes:timestampAttributes];
    self.timestampLabel.attributedText = timestampAttributedText;

    [self updateCommentCountForPoop:poop];

    NSString *addressString = poop.placemark.address ?: @"No address";

    NSDictionary *addressAttributes = [self.class attributesWithFont:[UIFont ppr_extraSmallFont]
                                                           textColor:[UIColor ppr_frostingColor]
                                                           alignment:NSTextAlignmentRight];
    NSAttributedString *addressAttributedText = [[NSAttributedString alloc] initWithString:addressString
                                                                                attributes:addressAttributes];

    self.addressLabel.attributedText = addressAttributedText;
}

#pragma mark - Actions

- (void)updateCommentCountForPoop:(PPRPoop *)poop {
    NSUInteger count = poop.comments.count;
    NSMutableString *commentsString = [NSMutableString stringWithFormat:@"%@ comment", @(count)];
    if (count != 1) {
        [commentsString appendString:@"s"];
    }

    NSDictionary *commentsAttributes = [self.class attributesWithFont:[UIFont ppr_extraSmallFont]
                                                            textColor:[UIColor ppr_frostingColor]
                                                            alignment:NSTextAlignmentRight];
    NSAttributedString *commentsAttributedText = [[NSAttributedString alloc] initWithString:commentsString
                                                                                 attributes:commentsAttributes];

    self.commentsLabel.attributedText = commentsAttributedText;
}

@end

//
//  PPRPoopDetailCommentCell.m
//  Poopr
//
//  Created by Bradley Smith on 12/4/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRPoopDetailCommentCell.h"

#import "PPRComment.h"

#import "UIColor+PPRStyle.h"
#import "UIFont+PPRStyle.h"
#import "NSDate+PPRTimeSince.h"

@interface PPRPoopDetailCommentCell ()

@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) UILabel *bodyLabel;

@end

@implementation PPRPoopDetailCommentCell

+ (NSDictionary *)attributesWithFont:(UIFont *)font
                           textColor:(UIColor *)textColor
                           alignment:(NSTextAlignment)alignment
                       lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = lineBreakMode;

    CGFloat baselineOffset = 0.0f;
    if (font == [UIFont ppr_mediumFont]) {
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        [self setupBodyLabel];
        [self setupTimestampLabel];
    }

    return self;
}

#pragma mark - Setup

- (void)setupBodyLabel {
    self.bodyLabel = [[UILabel alloc] init];
    self.bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.bodyLabel];

    self.bodyLabel.numberOfLines = 0;

    [self.bodyLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16.0f].active = YES;
    [self.bodyLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8.0f].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bodyLabel.bottomAnchor constant:8.0f].active = YES;

    [self.bodyLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.bodyLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setupTimestampLabel {
    self.timestampLabel = [[UILabel alloc] init];
    self.timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.timestampLabel];

    [self.timestampLabel.leadingAnchor constraintEqualToAnchor:self.bodyLabel.trailingAnchor constant:16.0f].active = YES;
    [self.timestampLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8.0f].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.timestampLabel.trailingAnchor constant:16.0f].active = YES;
    [self.contentView.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.timestampLabel.bottomAnchor constant:16.0f].active = YES;

    [self.timestampLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.timestampLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setupWithComment:(PPRComment *)comment {
    NSString *timestampString = [comment.createdAt ppr_timeSince] ?: @"N/A";

    NSDictionary *timestampAttributes = [self.class attributesWithFont:[UIFont ppr_extraExtraSmallFont]
                                                             textColor:[UIColor ppr_frostingColor]
                                                             alignment:NSTextAlignmentLeft
                                                         lineBreakMode:NSLineBreakByTruncatingTail];
    NSAttributedString *timestampAttributedText = [[NSAttributedString alloc] initWithString:timestampString
                                                                                  attributes:timestampAttributes];
    self.timestampLabel.attributedText = timestampAttributedText;

    NSString *bodyString = comment.body ?: @"No body";

//    BOOL isAuthor = [comment.authorID isEqualToString:[UIDevice currentDevice].identifierForVendor.UUIDString];
    NSDictionary *bodyAttributes = [self.class attributesWithFont:[UIFont ppr_extraSmallFont]
                                                        textColor:[UIColor ppr_frostingColor]
                                                        alignment:NSTextAlignmentLeft
                                                    lineBreakMode:NSLineBreakByWordWrapping];
    NSAttributedString *bodyAttributedText = [[NSAttributedString alloc] initWithString:bodyString
                                                                             attributes:bodyAttributes];

    self.bodyLabel.attributedText = bodyAttributedText;
}

@end

//
//  PPRPoopListCell.m
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPoopListCell.h"

#import "PPRPoop.h"
#import "PPRPlacemark+RZImport.h"

#import "PPRParseConstants.h"

#import "NSString+PPRSizing.h"
#import "UIColor+PPRStyle.h"
#import "UIFont+PPRStyle.h"
#import "NSDate+PPRTimeSince.h"

@interface PPRPoopListCell ()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *infoContainerView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceLabelBottomAlign;

@end

@implementation PPRPoopListCell

+ (NSDictionary *)attributesWithFont:(UIFont *)font
                           textColor:(UIColor *)textColor
                           alignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;

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

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self setupDistanceLabel];
    [self setupInfoContainerView];
    [self setupTimestampLabel];
    [self setupCommentsLabel];
    [self setupAddressLabel];
}

#pragma mark - Setup

- (void)setupDistanceLabel {

}

- (void)setupInfoContainerView {
    self.infoContainerView.backgroundColor = [UIColor clearColor];
}

- (void)setupTimestampLabel {

}

- (void)setupCommentsLabel {

}

- (void)setupAddressLabel {

}

- (void)setupWithPoop:(PPRPoop *)poop {
    NSString *distanceString = [poop distanceFromCurrentLocation];

    NSDictionary *distanceAttributes = [self.class attributesWithFont:[UIFont ppr_mediumFont]
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

    NSString *addressString = poop.placemark.address ?: @"No address";

    NSDictionary *addressAttributes = [self.class attributesWithFont:[UIFont ppr_extraSmallFont]
                                                           textColor:[UIColor ppr_frostingColor]
                                                           alignment:NSTextAlignmentRight];
    NSAttributedString *addressAttributedText = [[NSAttributedString alloc] initWithString:addressString
                                                                                attributes:addressAttributes];

    self.addressLabel.attributedText = addressAttributedText;

    self.distanceLabelBottomAlign.constant = -[UIFont ppr_extraSmallFont].descender;
}

@end

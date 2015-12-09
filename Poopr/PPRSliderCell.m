//
//  PPRSliderCell.m
//  Poopr
//
//  Created by Bradley Smith on 9/15/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRSliderCell.h"

#import <tgmath.h>

@interface PPRSliderCell ()

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) id <PPRSliderCellDelegate> delegate;

@end

@implementation PPRSliderCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self setupSlider];
    [self setupSliderLabel];
}

#pragma mark - Setup

- (void)setupSlider {
    [self.slider addTarget:self action:@selector(sliderDidChangeValue:) forControlEvents:UIControlEventValueChanged];

    UIControlEvents events = UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel;
    [self.slider addTarget:self action:@selector(sliderDidEndSliding:) forControlEvents:events];
}

- (void)setupSliderLabel {
    self.sliderLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupWithMax:(CGFloat)max min:(CGFloat)min value:(CGFloat)value delegate:(id <PPRSliderCellDelegate>)delegate {
    self.slider.maximumValue = (float)max;
    self.slider.minimumValue = (float)min;
    self.slider.value = (float)value;
    self.sliderLabel.text = [NSString stringWithFormat:@"%.0f", self.slider.value];
    self.delegate = delegate;
}

#pragma mark - Actions

- (void)sliderDidChangeValue:(UISlider *)slider {
    CGFloat value = __tg_ceil(slider.value);
    self.sliderLabel.text = [NSString stringWithFormat:@"%.0f", value];

    if ([self.delegate respondsToSelector:@selector(sliderCell:didChangeValue:)]) {
        [self.delegate sliderCell:self didChangeValue:value];
    }
}

- (void)sliderDidEndSliding:(UISlider *)slider {
    CGFloat value = __tg_ceil(slider.value);

    if ([self.delegate respondsToSelector:@selector(sliderCell:didEndSlidingWithValue:)]) {
        [self.delegate sliderCell:self didEndSlidingWithValue:value];
    }
}

@end

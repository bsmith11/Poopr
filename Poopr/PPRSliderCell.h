//
//  PPRSliderCell.h
//  Poopr
//
//  Created by Bradley Smith on 9/15/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class PPRSliderCell;

@protocol PPRSliderCellDelegate <NSObject>

@optional
- (void)sliderCell:(PPRSliderCell *)sliderCell didChangeValue:(CGFloat)value;
- (void)sliderCell:(PPRSliderCell *)sliderCell didEndSlidingWithValue:(CGFloat)value;

@end

@interface PPRSliderCell : UITableViewCell

- (void)setupWithMax:(CGFloat)max min:(CGFloat)min value:(CGFloat)value delegate:(id <PPRSliderCellDelegate>)delegate;

@end

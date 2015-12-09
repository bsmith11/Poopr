//
//  PPRSwitchCell.h
//  Poopr
//
//  Created by Bradley Smith on 9/15/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class PPRSwitchCell;

@protocol PPRSwitchCellDelegate <NSObject>

- (void)switchCell:(PPRSwitchCell *)switchCell didChangeEnabled:(BOOL)enabled;

@end

@interface PPRSwitchCell : UITableViewCell

- (void)setupWithTitle:(NSString *)title enabled:(BOOL)enabled delegate:(id <PPRSwitchCellDelegate>)delegate;
- (void)setSwitchEnabled:(BOOL)enabled animated:(BOOL)animated;

@end

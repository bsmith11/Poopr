//
//  PPRSwitchCell.m
//  Poopr
//
//  Created by Bradley Smith on 9/15/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRSwitchCell.h"

@interface PPRSwitchCell ()

@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchElement;
@property (weak, nonatomic) id <PPRSwitchCellDelegate> delegate;

@end

@implementation PPRSwitchCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self setupSwitchLabel];
    [self setupSwitchElement];
}

#pragma mark - Setup

- (void)setupSwitchLabel {

}

- (void)setupSwitchElement {
    [self.switchElement addTarget:self action:@selector(switchDidChangeEnabled:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupWithTitle:(NSString *)title enabled:(BOOL)enabled delegate:(id <PPRSwitchCellDelegate>)delegate {
    self.switchLabel.text = title;
    self.switchElement.on = enabled;
    self.delegate = delegate;
}

#pragma mark - Actions

- (void)switchDidChangeEnabled:(UISwitch *)switchElement {
    if ([self.delegate respondsToSelector:@selector(switchCell:didChangeEnabled:)]) {
        [self.delegate switchCell:self didChangeEnabled:switchElement.on];
    }
}

- (void)setSwitchEnabled:(BOOL)enabled animated:(BOOL)animated {
    [self.switchElement setOn:enabled animated:animated];
}

@end

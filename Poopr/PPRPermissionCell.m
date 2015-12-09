//
//  PPRPermissionCell.m
//  Poopr
//
//  Created by Bradley Smith on 9/16/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPermissionCell.h"

#import "PPRPermissionObject.h"

static NSString * const kPPRPermissionRequestTitleOK = @"OK";
static NSString * const kPPRPermissionRequestTitleSkip = @"Skip";

@interface PPRPermissionCell ()

@property (weak, nonatomic) IBOutlet UILabel *requestLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) id <PPRPermissionCellDelegate> delegate;

@end

@implementation PPRPermissionCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setupRequestLabel];
    [self setupAcceptButton];
    [self setupSkipButton];
}

#pragma mark - Setup

- (void)setupRequestLabel {

}

- (void)setupAcceptButton {
    [self.acceptButton setTitle:kPPRPermissionRequestTitleOK forState:UIControlStateNormal];
    [self.acceptButton addTarget:self action:@selector(didTapAcceptButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSkipButton {
    [self.skipButton setTitle:kPPRPermissionRequestTitleSkip forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(didTapSkipButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupWithPermissionObject:(PPRPermissionObject *)permissionObject delegate:(id<PPRPermissionCellDelegate>)delegate {
    self.requestLabel.text = permissionObject.request;

    if (permissionObject.type == PPRPermissionObjectTypeLocationServices) {
        self.skipButton.hidden = YES;
    }
    else if (permissionObject.type == PPRPermissionObjectTypeNotifications) {
        self.skipButton.hidden = NO;
    }

    self.delegate = delegate;
}

#pragma mark - Actions

- (void)didTapAcceptButton {
    if ([self.delegate respondsToSelector:@selector(permissionCellDidSelectAccept:)]) {
        [self.delegate permissionCellDidSelectAccept:self];
    }
}

- (void)didTapSkipButton {
    if ([self.delegate respondsToSelector:@selector(permissionCellDidSelectSkip:)]) {
        [self.delegate permissionCellDidSelectSkip:self];
    }
}

@end

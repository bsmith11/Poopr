//
//  UITableView+PPRUtilities.m
//  Poopr
//
//  Created by Bradley Smith on 12/6/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UITableView+PPRUtilities.h"

@implementation UITableView (PPRUtilities)

- (void)ppr_scrollToBottomAnimated:(BOOL)animated {
    if ([self numberOfRowsInSection:0] > 0) {
        NSInteger row = [self numberOfRowsInSection:0] - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];

        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];

//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//
//    CGFloat contentHeight = CGRectGetHeight([self rectForSection:0]);
//    CGFloat offset = self.contentSize.height - CGRectGetHeight(self.frame) + self.contentInset.bottom;
//    offset = MAX(offset, -self.contentInset.top);
//
//    NSLog(@"Offset: %@", @(offset));
//    NSLog(@"Content Size: %@", [NSValue valueWithCGSize:self.contentSize]);
//    NSLog(@"Content Height: %@", @(contentHeight));
//
//    [self setContentOffset:CGPointMake(self.contentOffset.x, offset) animated:animated];
    }
}

@end

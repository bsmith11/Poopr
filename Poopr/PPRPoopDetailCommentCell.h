//
//  PPRPoopDetailCommentCell.h
//  Poopr
//
//  Created by Bradley Smith on 12/4/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class PPRComment;

@interface PPRPoopDetailCommentCell : UITableViewCell

- (void)setupWithComment:(PPRComment *)comment;

@end

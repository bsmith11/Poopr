//
//  PPRCommentTextView.h
//  Poopr
//
//  Created by Bradley Smith on 12/6/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface PPRCommentTextView : UITextView

- (void)clearText;

@property (copy, nonatomic) NSString *placeholderText;

@end

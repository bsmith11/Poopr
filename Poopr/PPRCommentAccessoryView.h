//
//  PPRCommentAccessoryView.h
//  Poopr
//
//  Created by Bradley Smith on 12/6/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class PPRCommentAccessoryView;

@protocol PPRCommentAccessoryViewDelegate <NSObject>

- (void)commentAccessoryViewDidTapSubmit:(PPRCommentAccessoryView *)commentAccessoryView;

@end

@interface PPRCommentAccessoryView : UIView

- (void)clearText;

@property (copy, nonatomic, readonly) NSString *text;

@property (weak, nonatomic) id <PPRCommentAccessoryViewDelegate> delegate;

@property (assign, nonatomic) BOOL loading;

@end

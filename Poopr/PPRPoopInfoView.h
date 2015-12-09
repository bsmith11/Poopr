//
//  PPRPoopInfoView.h
//  Poopr
//
//  Created by Bradley Smith on 12/4/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class PPRPoop;

@interface PPRPoopInfoView : UIView

- (void)setupWithPoop:(PPRPoop *)poop;
- (void)updateCommentCountForPoop:(PPRPoop *)poop;

@end

//
//  PPRErrorView.h
//  Poopr
//
//  Created by Bradley Smith on 12/8/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface PPRErrorView : UIView

- (void)setupWithError:(NSError *)error;
- (void)addTarget:(id)target action:(SEL)action;

@end

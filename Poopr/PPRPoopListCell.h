//
//  PPRPoopListCell.h
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class PPRPoop;

@interface PPRPoopListCell : UITableViewCell

- (void)setupWithPoop:(PPRPoop *)poop;

@end

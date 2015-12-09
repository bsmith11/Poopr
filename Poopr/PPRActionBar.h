//
//  PPRActionBar.h
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

#import "PPRActionBarItem.h"

@interface PPRActionBar : UIView

@property (strong, nonatomic) PPRActionBarItem *leftItem;
@property (strong, nonatomic) PPRActionBarItem *rightItem;

@property (copy, nonatomic) NSArray *leftItems;
@property (copy, nonatomic) NSArray *rightItems;

@end

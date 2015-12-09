//
//  UITableViewCell+PPRReuse.h
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface UITableViewCell (PPRReuse)

+ (NSString *)ppr_reuseIdentifier;
+ (UINib *)ppr_reuseNib;

@end

//
//  UITableViewHeaderFooterView+PPRReuse.h
//  Poopr
//
//  Created by Bradley Smith on 12/5/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface UITableViewHeaderFooterView (PPRReuse)

+ (NSString *)ppr_reuseIdentifier;
+ (UINib *)ppr_reuseNib;

@end

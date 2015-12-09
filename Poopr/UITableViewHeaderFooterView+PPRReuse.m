//
//  UITableViewHeaderFooterView+PPRReuse.m
//  Poopr
//
//  Created by Bradley Smith on 12/5/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UITableViewHeaderFooterView+PPRReuse.h"

@implementation UITableViewHeaderFooterView (PPRReuse)

+ (NSString *)ppr_reuseIdentifier{
    return NSStringFromClass([self class]);
}

+ (UINib *)ppr_reuseNib {
    UINib *nib = [UINib nibWithNibName:[self ppr_reuseIdentifier] bundle:nil];

    return nib;
}

@end

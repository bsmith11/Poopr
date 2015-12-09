//
//  UITableViewCell+PPRReuse.m
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "UITableViewCell+PPRReuse.h"

@implementation UITableViewCell (PPRReuse)

+ (NSString *)ppr_reuseIdentifier{
    return NSStringFromClass([self class]);
}

+ (UINib *)ppr_reuseNib {
    UINib *nib = [UINib nibWithNibName:[self ppr_reuseIdentifier] bundle:nil];

    return nib;
}

@end

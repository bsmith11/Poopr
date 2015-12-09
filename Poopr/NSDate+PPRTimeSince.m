//
//  NSDate+PPRTimeSince.m
//  Poopr
//
//  Created by Bradley Smith on 12/4/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "NSDate+PPRTimeSince.h"

@implementation NSDate (PPRTimeSince)

- (NSString *)ppr_timeSince {
    NSTimeInterval timeSince = -[self timeIntervalSinceNow];
    NSString *timeSinceString = nil;

    if (timeSince > 0 && timeSince < 60) {
        timeSinceString = @"Now";
    }
    else if (timeSince > 59 && timeSince < 3600) {
        NSInteger value = (NSInteger)ceil(timeSince / 60);
        timeSinceString = [NSString stringWithFormat:@"%ld min ago", (long)value];
    }
    else if (timeSince > 3599 && timeSince < 86400) {
        NSInteger value = (NSInteger)ceil(timeSince / 3600);
        NSString *pluralString = (value == 1) ? @"" : @"s";
        timeSinceString = [NSString stringWithFormat:@"%ld hour%@ ago", (long)value, pluralString];
    }
    else {
        NSInteger value = (NSInteger)ceil(timeSince / 86400);
        NSString *pluralString = (value == 1) ? @"" : @"s";
        timeSinceString = [NSString stringWithFormat:@"%ld day%@ ago", (long)value, pluralString];
    }

    return timeSinceString;
}

@end

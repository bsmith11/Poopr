//
//  PPRErrorManager.m
//  Poopr
//
//  Created by Bradley Smith on 12/8/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRErrorManager.h"

NSString * const kPPRNotificationDidReceiveError = @"com.poopr.error.notification";
NSString * const kPPRNotificationDidReceiveErrorKeyError = @"poopr_error";

@implementation PPRErrorManager

+ (void)handleError:(NSError *)error {
    if (error) {
        NSDictionary *userInfo = @{kPPRNotificationDidReceiveErrorKeyError:error};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPPRNotificationDidReceiveError object:nil userInfo:userInfo];
    }
}

@end

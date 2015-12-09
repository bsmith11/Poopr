//
//  PPRErrorManager.h
//  Poopr
//
//  Created by Bradley Smith on 12/8/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

OBJC_EXTERN NSString * const kPPRNotificationDidReceiveError;
OBJC_EXTERN NSString * const kPPRNotificationDidReceiveErrorKeyError;

@interface PPRErrorManager : NSObject

+ (void)handleError:(NSError *)error;

@end

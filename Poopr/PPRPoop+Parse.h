//
//  PPRPoop+Parse.h
//  Poopr
//
//  Created by Bradley Smith on 9/13/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import MapKit;

#import "PPRPoop.h"

typedef void (^PPRPoopDownloadCompletionBlock)(NSArray *poops, NSError *error);
typedef void (^PPRPoopAddCompletionBlock)(NSError *error);
typedef void (^PPRPoopCheckCompletionBlock)(NSArray *poops, NSError *error);

typedef void (^PPRCommentAddCompletionBlock)(NSError *error);

@class CLPlacemark, CLLocation;

@interface PPRPoop (Parse)

+ (void)downloadPoopsWithCompletion:(PPRPoopDownloadCompletionBlock)completion;
+ (void)downloadPoopsNearLocation:(CLLocation *)location radius:(CGFloat)radius completion:(PPRPoopDownloadCompletionBlock)completion;
+ (void)downloadPoopsNearLocation:(CLLocation *)location radius:(CGFloat)radius timeInterval:(NSTimeInterval)timeInterval completion:(PPRPoopDownloadCompletionBlock)completion;

+ (void)addPoopWithPlacemark:(CLPlacemark *)placemark location:(CLLocation *)location completion:(PPRPoopAddCompletionBlock)completion;

+ (void)addCommentWithBody:(NSString *)body
                      poop:(PPRPoop *)poop
                completion:(PPRCommentAddCompletionBlock)completion;

@end

//
//  PPRPoop+Parse.m
//  Poopr
//
//  Created by Bradley Smith on 9/13/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPoop+Parse.h"
#import "PPRPlacemark+RZImport.h"
#import "PPRComment+RZImport.h"
#import "PFObject+PPRExtensions.h"

#import "PPRErrorManager.h"

#import "PPRParseConstants.h"

#import <Parse/Parse.h>
#import <RZDataBinding/RZDBMacros.h>
#import <RZVinyl/RZVinyl.h>

@implementation PPRPoop (Parse)

+ (void)downloadPoopsWithCompletion:(PPRPoopDownloadCompletionBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([self class])];
    [query includeKey:RZDB_KP(PPRPoop, placemark)];
    [query includeKey:RZDB_KP(PPRPoop, comments)];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [PPRErrorManager handleError:error];

        if (!error) {
            NSArray *poops = [PFObject ppr_arrayFromObjects:objects];
            __block NSArray *savedPoops = nil;

            [[PPRPoop rzv_coreDataStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
                savedPoops = [PPRPoop rzi_objectsFromArray:poops inContext:context];
            } completion:^(NSError *err) {
                [PPRErrorManager handleError:err];

                if (completion) {
                    completion(savedPoops, err);
                }
            }];
        }
        else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

+ (void)downloadPoopsNearLocation:(CLLocation *)location radius:(CGFloat)radius completion:(PPRPoopDownloadCompletionBlock)completion {
    [self downloadPoopsNearLocation:location radius:radius timeInterval:-1 completion:completion];
}

+ (void)downloadPoopsNearLocation:(CLLocation *)location radius:(CGFloat)radius timeInterval:(NSTimeInterval)timeInterval completion:(PPRPoopDownloadCompletionBlock)completion {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:location];
    PFQuery *placemarkQuery = [PFQuery queryWithClassName:NSStringFromClass([PPRPlacemark class])];
    [placemarkQuery whereKey:kPPRParseRequestKeyLocation nearGeoPoint:geoPoint withinKilometers:(radius / 1000.0f)];

    if (timeInterval > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-timeInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = kPPRParseDateFormat;
        NSString *dateString = [dateFormatter stringFromDate:date];

        [placemarkQuery whereKey:RZDB_KP(PPRPlacemark, updatedAt) greaterThanOrEqualTo:dateString];
    }

    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([PPRPoop class])];
    [query includeKey:RZDB_KP(PPRPoop, placemark)];
    [query includeKey:RZDB_KP(PPRPoop, comments)];
    [query whereKey:RZDB_KP(PPRPoop, placemark) matchesQuery:placemarkQuery];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [PPRErrorManager handleError:error];

        if (!error) {
            NSArray *poops = [PFObject ppr_arrayFromObjects:objects];
            __block NSArray *savedPoops = nil;

            [[PPRPoop rzv_coreDataStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
                savedPoops = [PPRPoop rzi_objectsFromArray:poops inContext:context];
            } completion:^(NSError *err) {
                [PPRErrorManager handleError:err];

                if (completion) {
                    completion(savedPoops, err);
                }
            }];
        }
        else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

+ (void)addPoopWithPlacemark:(CLPlacemark *)placemark location:(CLLocation *)location completion:(PPRPoopAddCompletionBlock)completion {
    PFObject *placemarkObject = [PFObject objectWithClassName:NSStringFromClass([PPRPlacemark class])];
    [placemarkObject ppr_setupWithPlacemark:placemark location:location];

    PFObject *poopObject = [PFObject objectWithClassName:NSStringFromClass([PPRPoop class])];
    poopObject[RZDB_KP(PPRPoop, placemark)] = placemarkObject;
    poopObject[RZDB_KP(PPRPoop, authorID)] = [UIDevice currentDevice].identifierForVendor.UUIDString;

    [poopObject saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        [PPRErrorManager handleError:error];

        if (success) {
            [self subscribeToPoopID:poopObject.objectId];

            [[PPRPoop rzv_coreDataStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
                [PPRPoop rzi_objectFromDictionary:[poopObject ppr_dictionary] inContext:context];
            } completion:^(NSError *err) {
                [PPRErrorManager handleError:err];

                if (completion) {
                    completion(err);
                }
            }];
        }
        else {
            if (completion) {
                completion(error);
            }
        }
    }];
}

+ (void)addCommentWithBody:(NSString *)body
                      poop:(PPRPoop *)poop
                completion:(PPRCommentAddCompletionBlock)completion {
    PFObject *commentObject = [PFObject objectWithClassName:NSStringFromClass([PPRComment class])];
    commentObject[RZDB_KP(PPRComment, body)] = body;
    commentObject[RZDB_KP(PPRComment, authorID)] = [UIDevice currentDevice].identifierForVendor.UUIDString;
    commentObject[RZDB_KP(PPRComment, localCommentID)] = [NSUUID UUID].UUIDString;

    [[PPRPoop rzv_coreDataStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
        NSMutableDictionary *commentDictionary = [[commentObject ppr_dictionary] mutableCopy];
        commentDictionary[kPPRParseResponseKeyCreatedAt] = [NSDate date];

        PPRComment *comment = [PPRComment rzi_objectFromDictionary:commentDictionary inContext:context];
        PPRPoop *backgroundPoop = [poop rzv_objectInContext:context];
        [backgroundPoop addCommentsObject:comment];
    } completion:^(NSError *err) {
        [PPRErrorManager handleError:err];
    }];

    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([self class])];
    [query getObjectInBackgroundWithId:poop.poopID block:^(PFObject *poopObject, NSError *error) {
        [PPRErrorManager handleError:error];

        if (!error) {
            [poopObject addUniqueObject:commentObject forKey:RZDB_KP(PPRPoop, comments)];
            [poopObject saveInBackgroundWithBlock:^(BOOL success, NSError *saveError) {
                [PPRErrorManager handleError:saveError];

                if (success) {
                    [self subscribeToPoopID:poop.poopID];
                    [self sendCommentPushForPoopID:poop.poopID];

                    [[PPRPoop rzv_coreDataStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(PPRComment, localCommentID), commentObject[RZDB_KP(PPRComment, localCommentID)]];
                        PPRComment *comment = [PPRComment rzv_where:predicate inContext:context].firstObject;
                        comment.commentID = commentObject.objectId;
                        [PPRPoop rzi_objectFromDictionary:[poopObject ppr_dictionary] inContext:context];
                    } completion:^(NSError *err) {
                        [PPRErrorManager handleError:err];

                        if (completion) {
                            completion(err);
                        }
                    }];
                }
                else {
                    if (completion) {
                        completion(saveError);
                    }
                }
            }];
        }
        else {
            if (completion) {
                completion(error);
            }
        }
    }];
}

+ (void)subscribeToPoopID:(NSString *)poopID {
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation addUniqueObject:poopID forKey:@"channels"];
    [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [PPRErrorManager handleError:error];
    }];
}

+ (void)sendCommentPushForPoopID:(NSString *)poopID {
    PFInstallation *installation = [PFInstallation currentInstallation];
    PFQuery *query = [PFInstallation query];
    [query whereKey:RZDB_KP(PFInstallation, channels) equalTo:poopID];
    [query whereKey:RZDB_KP(PFInstallation, installationId) notEqualTo:installation.installationId];

    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    [push setMessage:@"Someone's talking about your poop!"];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [PPRErrorManager handleError:error];
    }];
}

@end

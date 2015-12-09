//
//  PPRPoopListViewModel.m
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPoopListViewModel.h"

#import "PPRSettingsViewModel.h"

#import "PPRPoop+RZImport.h"

#import "PPRErrorManager.h"
#import "PPRLocationManager.h"
#import "PPRLog.h"
#import "PPRSettings.h"

#import <RZCollectionList/RZCollectionList.h>

@interface PPRPoopListViewModel ()

@property (strong, nonatomic, readwrite) RZFilteredCollectionList *poops;
@property (strong, nonatomic) RZCollectionListTableViewDataSource *dataSource;

@property (assign, nonatomic, readwrite) BOOL loading;

@end

@implementation PPRPoopListViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setupPoops];
        [self setupObservers];

        [self downloadPoopsNearCurrentLocationWithCompletion:^(NSArray *poops, NSError *error) {
            if (error) {
                DDLogError(@"Failed to download poops with error: %@", error);
            }
        }];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPPRSettingsRadiusDidChangeNotification object:nil];
}

#pragma mark - Setup

- (void)setupPoops {
    RZFetchedCollectionList *fetchedPoops = [PPRPoop fetchedListOfPoops];
    self.poops = [[RZFilteredCollectionList alloc] initWithSourceList:fetchedPoops predicate:nil];
}

- (void)setupPoopsWithLocation:(CLLocation *)location {
    NSPredicate *predicate = [PPRPoop predicateNearLocation:location radius:[PPRSettings radius].CGFloatValue];
    self.poops.predicate = predicate;
}

- (void)configureTableView:(UITableView *)tableView delegate:(id<RZCollectionListTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[RZCollectionListTableViewDataSource alloc] initWithTableView:tableView collectionList:self.poops delegate:delegate];
}

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(radiusDidChange) name:kPPRSettingsRadiusDidChangeNotification object:nil];
}

#pragma mark - Actions

- (void)downloadPoopsNearCurrentLocationWithCompletion:(PPRPoopDownloadCompletionBlock)completion {
    __weak __typeof (self) welf = self;

    self.loading = YES;

    [[PPRLocationManager sharedInstance] requestLocationWithCompletion:^(CLLocation *location) {
        [welf setupPoopsWithLocation:location];

        [welf downloadPoopsNearLocation:location completion:^(NSArray *poops, NSError *downloadError) {
            welf.loading = NO;

            if (completion) {
                completion(poops, downloadError);
            }
        }];
    }];
}

- (void)downloadPoopsNearLocation:(CLLocation *)location completion:(PPRPoopDownloadCompletionBlock)completion {
    [PPRPoop downloadPoopsNearLocation:location radius:[PPRSettings radius].CGFloatValue completion:completion];
}

- (void)addPoopWithCompletion:(PPRPoopAddCompletionBlock)completion {
    self.loading = YES;

    __weak __typeof (self) welf = self;

    [[PPRLocationManager sharedInstance] requestLocationWithCompletion:^(CLLocation *location) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];

        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *geocodeError) {
            [PPRErrorManager handleError:geocodeError];

            if (!geocodeError) {
                [PPRPoop addPoopWithPlacemark:placemarks.firstObject location:location completion:^(NSError *addError) {
                    welf.loading = NO;

                    if (completion) {
                        completion(addError);
                    }
                }];
            }
            else {
                welf.loading = NO;

                if (completion) {
                    completion(geocodeError);
                }
            }
        }];
    }];
}

- (void)radiusDidChange {
    [self downloadPoopsNearCurrentLocationWithCompletion:^(NSArray *poops, NSError *error) {
        if (error) {
            DDLogError(@"Failed to download poops with error: %@", error);
        }
    }];
}

@end

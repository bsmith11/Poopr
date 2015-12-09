//
//  PPRPoopListViewModel.h
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

#import "PPRPoop+Parse.h"

@protocol RZCollectionListTableViewDataSourceDelegate;

@class RZFilteredCollectionList;

@interface PPRPoopListViewModel : NSObject

@property (strong, nonatomic, readonly) RZFilteredCollectionList *poops;

@property (assign, nonatomic, readonly) BOOL loading;

- (void)configureTableView:(UITableView *)tableView delegate:(id <RZCollectionListTableViewDataSourceDelegate>)delegate;
- (void)downloadPoopsNearCurrentLocationWithCompletion:(PPRPoopDownloadCompletionBlock)completion;
- (void)addPoopWithCompletion:(PPRPoopAddCompletionBlock)completion;

@end

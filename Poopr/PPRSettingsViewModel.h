//
//  PPRSettingsViewModel.h
//  Poopr
//
//  Created by Bradley Smith on 9/16/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

OBJC_EXTERN NSString * const kPPRSettingsRadiusDidChangeNotification;

@protocol RZCollectionListTableViewDataSourceDelegate;

@class RZArrayCollectionList;

@interface PPRSettingsViewModel : NSObject

@property (strong, nonatomic, readonly) RZArrayCollectionList *settings;

- (void)configureTableView:(UITableView *)tableView delegate:(id <RZCollectionListTableViewDataSourceDelegate>)delegate;
- (void)sendRadiusDidChangeNotification;

@end

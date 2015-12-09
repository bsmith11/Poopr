//
//  PPRSettingsViewModel.m
//  Poopr
//
//  Created by Bradley Smith on 9/16/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRSettingsViewModel.h"

#import "PPRSettingsObject.h"

#import "PPRSettings.h"
#import "PPRAppDelegate.h"

#import <RZCollectionList/RZCollectionList.h>

NSString * const kPPRSettingsRadiusDidChangeNotification = @"com.poopr.settings.RadiusDidChangeNotification";

static NSString * const kPPRSettingsRadiusSectionTitle = @"Radius (meters)";
static NSString * const kPPRSettingsNotificationsSectionTitle = @"Notifications";

@interface PPRSettingsViewModel ()

@property (strong, nonatomic, readwrite) RZArrayCollectionList *settings;
@property (strong, nonatomic) RZCollectionListTableViewDataSource *dataSource;

@property (copy, nonatomic) NSNumber *initialRadiusValue;

@end

@implementation PPRSettingsViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.initialRadiusValue = [PPRSettings radius];

        [self setupSettings];
        [self setupObservers];
    }

    return self;
}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark - Setup

- (void)setupSettings {
    PPRSettingsObject *radiusObject = [PPRSettingsObject settingsObjectWithType:PPRSettingsObjectTypeRadius];
    RZArrayCollectionListSectionInfo *radiusSectionInfo = [[RZArrayCollectionListSectionInfo alloc] initWithName:kPPRSettingsRadiusSectionTitle sectionIndexTitle:nil numberOfObjects:0];

    PPRSettingsObject *poopNotificationObject = [PPRSettingsObject settingsObjectWithType:PPRSettingsObjectTypeNotificationPoop];
    PPRSettingsObject *commentNotificationObject = [PPRSettingsObject settingsObjectWithType:PPRSettingsObjectTypeNotificationComment];
    RZArrayCollectionListSectionInfo *notificationSectionInfo = [[RZArrayCollectionListSectionInfo alloc] initWithName:kPPRSettingsNotificationsSectionTitle sectionIndexTitle:nil numberOfObjects:0];

    NSArray *sections = @[radiusSectionInfo, notificationSectionInfo];

    self.settings = [[RZArrayCollectionList alloc] initWithArray:@[] sections:sections];
    [self.settings addObject:radiusObject toSection:0];
    [self.settings addObject:poopNotificationObject toSection:1];
    [self.settings addObject:commentNotificationObject toSection:1];
}

- (void)configureTableView:(UITableView *)tableView delegate:(id<RZCollectionListTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[RZCollectionListTableViewDataSource alloc] initWithTableView:tableView collectionList:self.settings delegate:delegate];
}

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPermissionDidChange) name:kPPRNotificationPermissionDidChangeNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPPRNotificationPermissionDidChangeNotification object:nil];
}

#pragma mark - Actions

- (void)sendRadiusDidChangeNotification {
    NSNumber *endRadiusValue = [PPRSettings radius];

    if (self.initialRadiusValue.integerValue != endRadiusValue.integerValue) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPPRSettingsRadiusDidChangeNotification object:nil];
    }
}

- (void)notificationPermissionDidChange {
    for (PPRSettingsObject *settingsObject in self.settings.listObjects) {
        if (settingsObject.type == PPRSettingsObjectTypeNotificationPoop || settingsObject.type == PPRSettingsObjectTypeNotificationComment) {
            NSIndexPath *indexPath = [self.settings indexPathForObject:settingsObject];
            [self.dataSource.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

@end

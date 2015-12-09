//
//  PPRPermissionViewController.m
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPermissionViewController.h"

#import "PPRPermissionCell.h"

#import "PPRPermissionObject.h"

#import "PPRLocationManager.h"
#import "PPRAppDelegate.h"
#import "PPRSettings.h"

#import "UICollectionReusableView+PPRReuse.h"

@interface PPRPermissionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PPRPermissionCellDelegate>

@property (strong, nonatomic) NSArray *permissions;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PPRPermissionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self setupPermissions];
}

- (void)viewDidLayoutSubviews {
    [self setupCollectionView];
}

#pragma mark - Setup

- (void)setupPermissions {
    PPRPermissionObject *locationServicesObject = [PPRPermissionObject permissionObjectWithType:PPRPermissionObjectTypeLocationServices];
    PPRPermissionObject *notificationsObject = [PPRPermissionObject permissionObjectWithType:PPRPermissionObjectTypeNotifications];

    self.permissions = @[locationServicesObject, notificationsObject];
}

- (void)setupCollectionView {
    [self.collectionView registerNib:[PPRPermissionCell ppr_reuseNib] forCellWithReuseIdentifier:[PPRPermissionCell ppr_reuseIdentifier]];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = self.collectionView.frame.size;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 0.0f;
    self.collectionView.collectionViewLayout = flowLayout;
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (NSInteger)self.permissions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPRPermissionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PPRPermissionCell ppr_reuseIdentifier] forIndexPath:indexPath];
    PPRPermissionObject *permissionObject = self.permissions[(NSUInteger)indexPath.item];

    [cell setupWithPermissionObject:permissionObject delegate:self];

    return cell;
}

#pragma mark - Permission Cell Delegate

- (void)permissionCellDidSelectAccept:(PPRPermissionCell *)permissionCell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:permissionCell];
    PPRPermissionObject *permissionObject = self.permissions[(NSUInteger)indexPath.item];

    if (permissionObject.type == PPRPermissionObjectTypeLocationServices) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:0];

        [[PPRLocationManager sharedInstance] requestAlwaysPermissionWithCompletion:^(PPRLocationServicesPermissionState state) {
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }];
    }
    else if (permissionObject.type == PPRPermissionObjectTypeNotifications) {
        [PPRSettings setDidSkipNotificationPermission:NO];

        PPRAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate requestNotificationPermissionWithCompletion:^(BOOL granted) {
            [PPRSettings setPoopNotificationsEnabled:granted];

            if ([self.delegate respondsToSelector:@selector(permissionViewControllerDidFinish:)]) {
                [self.delegate permissionViewControllerDidFinish:self];
            }
        }];
    }
}

- (void)permissionCellDidSelectSkip:(PPRPermissionCell *)permissionCell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:permissionCell];
    PPRPermissionObject *permissionObject = self.permissions[(NSUInteger)indexPath.item];

    if (permissionObject.type == PPRPermissionObjectTypeNotifications) {
        [PPRSettings setDidSkipNotificationPermission:YES];
        [PPRSettings setPoopNotificationsEnabled:NO];

        if ([self.delegate respondsToSelector:@selector(permissionViewControllerDidFinish:)]) {
            [self.delegate permissionViewControllerDidFinish:self];
        }
    }
}

@end

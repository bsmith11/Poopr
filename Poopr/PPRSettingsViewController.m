//
//  PPRSettingsViewController.m
//  Poopr
//
//  Created by Bradley Smith on 9/14/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRSettingsViewController.h"

#import "PPRSettingsViewModel.h"

#import "PPRSettingsObject.h"

#import "PPRSliderCell.h"
#import "PPRSwitchCell.h"

#import "UITableViewCell+PPRReuse.h"
#import "UIAlertController+PPRExtensions.h"

#import <RZCollectionList/RZCollectionList.h>

static NSString * const kPPRSettingsTitle = @"Settings";

@interface PPRSettingsViewController () <RZCollectionListTableViewDataSourceDelegate, UITableViewDelegate, PPRSliderCellDelegate, PPRSwitchCellDelegate>

@property (strong, nonatomic) PPRSettingsViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PPRSettingsViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(PPRSettingsViewModel *)viewModel {
    self = [super init];

    if (self) {
        _viewModel = viewModel;
        
        self.title = kPPRSettingsTitle;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBarButtonItems];
    [self setupTableView];

    [self.viewModel configureTableView:self.tableView delegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.viewModel sendRadiusDidChangeNotification];
}

#pragma mark - Setup

- (void)setupBarButtonItems {
    UIBarButtonItem *dismissBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Delete Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapDismissBarButtonItem)];

    [self.navigationItem setRightBarButtonItem:dismissBarButtonItem animated:YES];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    [self.tableView registerNib:[PPRSliderCell ppr_reuseNib] forCellReuseIdentifier:[PPRSliderCell ppr_reuseIdentifier]];
    [self.tableView registerNib:[PPRSwitchCell ppr_reuseNib] forCellReuseIdentifier:[PPRSwitchCell ppr_reuseIdentifier]];
}

#pragma mark - Actions

- (void)didTapDismissBarButtonItem {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Collection List Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(PPRSettingsObject *)object atIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    if (object.type == PPRSettingsObjectTypeRadius) {
        PPRSliderCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:[PPRSliderCell ppr_reuseIdentifier] forIndexPath:indexPath];
        [sliderCell setupWithMax:object.max min:object.min value:object.value delegate:self];

        cell = sliderCell;
    }
    else if (object.type == PPRSettingsObjectTypeNotificationPoop || object.type == PPRSettingsObjectTypeNotificationComment) {
        PPRSwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:[PPRSwitchCell ppr_reuseIdentifier] forIndexPath:indexPath];
        [switchCell setupWithTitle:object.title enabled:object.enabled delegate:self];

        cell = switchCell;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    RZArrayCollectionListSectionInfo *sectionInfo = self.viewModel.settings.sections[(NSUInteger)section];

    return sectionInfo.name;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

#pragma mark - Slider Cell Delegate

- (void)sliderCell:(PPRSliderCell *)sliderCell didEndSlidingWithValue:(CGFloat)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sliderCell];
    PPRSettingsObject *settingsObject = [self.viewModel.settings objectAtIndexPath:indexPath];

    settingsObject.value = value;
}

#pragma mark - Switch Cell Delegate

- (void)switchCell:(PPRSwitchCell *)switchCell didChangeEnabled:(BOOL)enabled {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:switchCell];
    PPRSettingsObject *settingsObject = [self.viewModel.settings objectAtIndexPath:indexPath];

    __weak __typeof(self) welf = self;

    [settingsObject setEnabled:enabled completion:^(BOOL granted, BOOL displayAlert) {
        if (!granted) {
            [switchCell setSwitchEnabled:NO animated:YES];
        }

        if (displayAlert) {
            [welf presentNotificationDisabledAlertController];
        }
    }];
}

#pragma mark - Alert Controller

- (void)presentNotificationDisabledAlertController {
    UIAlertController *settingsAlertController = [UIAlertController ppr_alertControllerForNotificationSettings];

    [self presentViewController:settingsAlertController animated:YES completion:nil];
}

@end

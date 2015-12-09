//
//  PPRPoopListViewController.m
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPoopListViewController.h"
#import "PPRNavigationController.h"
#import "PPRSettingsViewController.h"
#import "PPRPoopDetailViewController.h"

#import "PPRPoopListViewModel.h"
#import "PPRSettingsViewModel.h"

#import "PPRPoopDetailAnimationController.h"
#import "PPRErrorManager.h"
#import "PPRPoopListCell.h"

#import "UITableViewCell+PPRReuse.h"
#import "UIAlertController+PPRExtensions.h"
#import "UIColor+PPRStyle.h"

#import "PPRLog.h"

#import <RZCollectionList/RZCollectionList.h>
#import <RZDataBinding/RZDataBinding.h>
#import <RZUtils/RZCommonUtils.h>
#import <pop/POP.h>

@interface PPRPoopListViewController () <RZCollectionListTableViewDataSourceDelegate, UITableViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) PPRPoopListViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) PPRActionBarItem *locationItem;
@property (strong, nonatomic) PPRActionBarItem *addItem;

@end

@implementation PPRPoopListViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(PPRPoopListViewModel *)viewModel {
    self = [super init];

    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"list_icon"] selectedImage:nil];

        _viewModel = viewModel;
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;

    [self setupTableView];
    [self setupActionBarItems];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupObservers];

    [self.viewModel configureTableView:self.tableView delegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.tableView.transform = CGAffineTransformIdentity;
        [self.addItem transformImage:CGAffineTransformIdentity];
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGFloat translation = -CGRectGetHeight(self.tableView.frame);
        self.tableView.transform = CGAffineTransformMakeTranslation(0.0f, translation);
        [self.addItem transformImage:CGAffineTransformMakeRotation((CGFloat)M_PI_4)];
    } completion:nil];
}

#pragma mark - Setup

- (void)setupActionBarItems {
    UIImage *addImage = [UIImage imageNamed:@"add_icon"];
    self.addItem = [PPRActionBarItem actionBarItemWithImage:addImage target:self action:@selector(didTapAddActionBarItem)];
    self.pprNavigationController.actionBar.rightItem = self.addItem;

//    UIImage *locationImage = [UIImage imageNamed:@"location_icon"];
//    self.locationItem = [PPRActionBarItem actionBarItemWithImage:locationImage target:nil action:nil];
//    self.locationItem.userInteractionEnabled = NO;
//    self.pprNavigationController.actionBar.leftItem = self.locationItem;

    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.color = [UIColor ppr_frostingColor];
    self.activityIndicatorView.hidesWhenStopped = YES;
    PPRActionBarItem *item = [PPRActionBarItem actionBarItemWithActivityIndicatorView:self.activityIndicatorView];
    self.pprNavigationController.actionBar.leftItem = item;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.tableView.estimatedRowHeight = 100.0f;

    UIEdgeInsets insets = UIEdgeInsetsMake(50.0f, 0.0f, 50.0f, 0.0f);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;

    [self.tableView registerNib:[PPRPoopListCell ppr_reuseNib] forCellReuseIdentifier:[PPRPoopListCell ppr_reuseIdentifier]];

    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
}

- (void)setupObservers {
    [self.viewModel rz_addTarget:self action:@selector(updateLoadingStatus:) forKeyPathChange:RZDB_KP_OBJ(self.viewModel, loading) callImmediately:YES];
}

#pragma mark - Actions

- (void)didTapAddActionBarItem {
    if (![self.pprNavigationController.topViewController isEqual:self]) {
        [self.pprNavigationController popViewControllerAnimated:YES];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPPRNotificationDidReceiveError object:nil];

//        __weak __typeof(self) welf = self;
//
//        [self.viewModel addPoopWithCompletion:^(NSError *error) {
//            if (error) {
//                DDLogError(@"Failed to add poop with error: %@", error);
//
//                UIAlertController *alertController = [UIAlertController ppr_alertControllerWithError:error];
//                [welf presentViewController:alertController animated:YES completion:nil];
//            }
//        }];
    }
}

- (void)didTapSettingsBarButtonItem {
    PPRSettingsViewModel *viewModel = [[PPRSettingsViewModel alloc] init];
    PPRSettingsViewController *settingsViewController = [[PPRSettingsViewController alloc] initWithViewModel:viewModel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)updateLoadingStatus:(NSDictionary *)change {
    NSNumber *loading = RZNSNullToNil(change[kRZDBChangeKeyNew]);

    if (loading.boolValue) {
        [self.activityIndicatorView startAnimating];
    }
    else {
        [self.activityIndicatorView stopAnimating];
    }
}

#pragma mark - Collection List Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(PPRPoop *)poop atIndexPath:(NSIndexPath *)indexPath {
    PPRPoopListCell *cell = [tableView dequeueReusableCellWithIdentifier:[PPRPoopListCell ppr_reuseIdentifier] forIndexPath:indexPath];

    [cell setupWithPoop:poop];

    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PPRPoop *poop = [self.viewModel.poops objectAtIndexPath:indexPath];
    PPRPoopDetailViewController *poopDetailViewController = [[PPRPoopDetailViewController alloc] initWithPoop:poop];

    [self.navigationController pushViewController:poopDetailViewController animated:YES];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = -(scrollView.contentOffset.y + scrollView.contentInset.top);
    offset = MAX(offset, 0.0f);

    UIEdgeInsets insets = scrollView.scrollIndicatorInsets;
    insets.top = offset + 50.0f;
    scrollView.scrollIndicatorInsets = insets;

    self.pprNavigationController.actionBarHeight.constant = offset + 50.0f;
}

#pragma mark - Navigation Controller Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    PPRPoopDetailAnimationController *animationController = [[PPRPoopDetailAnimationController alloc] init];
    animationController.positive = (operation == UINavigationControllerOperationPush);

    return animationController;
}

@end

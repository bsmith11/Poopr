//
//  PPRPoopDetailViewController.m
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRPoopDetailViewController.h"
#import "PPRNavigationController.h"
#import "PPRTabBarController.h"

#import "PPRPoopDetailViewModel.h"

#import "PPRPoop.h"

#import "PPRPoopDetailCommentCell.h"

#import "PPRActionBar.h"
#import "PPRPoopInfoView.h"
#import "PPRCommentAccessoryView.h"

#import "UITableViewCell+PPRReuse.h"
#import "UIColor+PPRStyle.h"
#import "UITableView+PPRUtilities.h"

#import <RZUtils/UIViewController+RZKeyboardWatcher.h>
#import <RZDataBinding/RZDataBinding.h>

@interface PPRPoopDetailViewController () <PPRPoopDetailViewModelDelegate, UITableViewDelegate, PPRCommentAccessoryViewDelegate>

@property (strong, nonatomic) PPRPoopDetailViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) PPRPoopInfoView *poopInfoView;
@property (strong, nonatomic) PPRCommentAccessoryView *commentAccessoryView;

@property (strong, nonatomic) NSLayoutConstraint *poopInfoViewBottom;

@property (assign, nonatomic) CGFloat poopInfoViewHeight;
@property (assign, nonatomic) BOOL hasPositionedViews;
@property (assign, nonatomic) BOOL viewDidInitiallyAppear;
@property (assign, nonatomic) BOOL isTransitioning;
@property (assign, nonatomic) BOOL isKeyboardVisible;

@end

@implementation PPRPoopDetailViewController

#pragma mark - Lifecycle

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (UIView *)inputAccessoryView {
    return self.commentAccessoryView;
}

- (instancetype)initWithPoop:(PPRPoop *)poop {
    self = [super init];

    if (self) {
        self.viewModel = [[PPRPoopDetailViewModel alloc] initWithPoop:poop];
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupPoopInfoView];
    [self setupTableView];
    [self setupCommentAccessoryView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    [self.viewModel configureTableView:self.tableView delegate:self];

    [self.pprNavigationController.view setNeedsLayout];
    [self.pprNavigationController.view layoutIfNeeded];

    [self setupObservers];
    [self setupKeyboardObserver];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (!self.hasPositionedViews) {
        self.hasPositionedViews = YES;
        CGFloat tableViewTranslation = CGRectGetHeight(self.tableView.frame);

        [UIView performWithoutAnimation:^{
            self.tableView.transform = CGAffineTransformMakeTranslation(0.0f, tableViewTranslation);
            self.commentAccessoryView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 44.0f);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.isTransitioning = YES;

        self.tableView.transform = CGAffineTransformIdentity;
        self.pprTabBarController.pprTabBar.transform = CGAffineTransformMakeTranslation(0.0f, 50.0f);
        self.pprTabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0.0f, 49.0f);

        [self showPoopInfoView];

        [self.tableView ppr_scrollToBottomAnimated:NO];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.viewDidInitiallyAppear = YES;
        self.isTransitioning = NO;

        [self becomeFirstResponder];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.isTransitioning = YES;

        [self hidePoopInfoView];

        CGFloat tableViewTranslation = CGRectGetHeight(self.tableView.frame);
        self.tableView.transform = CGAffineTransformMakeTranslation(0.0f, tableViewTranslation);
        self.pprTabBarController.pprTabBar.transform = CGAffineTransformIdentity;
        self.pprTabBarController.tabBar.transform = CGAffineTransformIdentity;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.isTransitioning = NO;
        
        [self.poopInfoView removeFromSuperview];
    }];
}

- (void)dealloc {
    [self rz_unwatchKeyboard];
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 44.0f;

    self.tableView.contentInset = UIEdgeInsetsMake(self.poopInfoViewHeight + 8.0f, 0.0f, 44.0f + 8.0f, 0.0f);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.poopInfoViewHeight, 0.0f, 44.0f, 0.0f);

    [self.tableView registerClass:[PPRPoopDetailCommentCell class] forCellReuseIdentifier:[PPRPoopDetailCommentCell ppr_reuseIdentifier]];

    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
}

- (void)setupCommentAccessoryView {
    self.commentAccessoryView = [[PPRCommentAccessoryView alloc] init];
    self.commentAccessoryView.delegate = self;
}

- (void)setupPoopInfoView {
    PPRActionBar *actionBar = self.pprNavigationController.actionBar;

    self.poopInfoView = [[PPRPoopInfoView alloc] init];
    self.poopInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    [actionBar addSubview:self.poopInfoView];

    [self.poopInfoView setupWithPoop:self.viewModel.poop];
    self.poopInfoView.userInteractionEnabled = NO;

    [self.poopInfoView.leadingAnchor constraintEqualToAnchor:actionBar.leadingAnchor].active = YES;
    [actionBar.trailingAnchor constraintEqualToAnchor:self.poopInfoView.trailingAnchor].active = YES;

    self.poopInfoViewHeight = [self.poopInfoView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.poopInfoViewBottom = [actionBar.bottomAnchor constraintEqualToAnchor:self.poopInfoView.bottomAnchor constant:-self.poopInfoViewHeight];
    self.poopInfoViewBottom.active = YES;
}

- (void)setupObservers {
    [self.viewModel rz_addTarget:self action:@selector(updateCommentCount) forKeyPathChange:RZDB_KP_OBJ(self.viewModel, commentCount) callImmediately:YES];
    [self.viewModel rz_addTarget:self action:@selector(updateLoadingStatus:) forKeyPathChange:RZDB_KP_OBJ(self.viewModel, loading) callImmediately:YES];
}

- (void)setupKeyboardObserver {
    __weak __typeof(self) wself = self;

    [self rz_watchKeyboardShowWithAnimations:^(BOOL keyboardVisible, CGRect keyboardFrame) {
        if (!wself.isTransitioning) {
            CGFloat offset = keyboardVisible ? CGRectGetHeight(keyboardFrame) : 0.0f;
            wself.isKeyboardVisible = (offset > 44.0f);

            UIEdgeInsets contentInset = wself.tableView.contentInset;
            contentInset.bottom = 8.0f + offset;
            contentInset.top = (wself.isKeyboardVisible ? 50.0f : wself.poopInfoViewHeight) + 8.0f;
            wself.tableView.contentInset = contentInset;

            UIEdgeInsets scrollIndicatorInset = wself.tableView.scrollIndicatorInsets;
            scrollIndicatorInset.bottom = offset;
            scrollIndicatorInset.top = wself.isKeyboardVisible ? 50.0f : wself.poopInfoViewHeight;
            wself.tableView.scrollIndicatorInsets = scrollIndicatorInset;

            if (wself.isKeyboardVisible) {
                [wself hidePoopInfoView];
            }
            else {
                [wself showPoopInfoView];
            }

            if (wself.isKeyboardVisible) {
                [wself.tableView ppr_scrollToBottomAnimated:NO];
            }
        }
    } completion:nil animated:YES];
}

#pragma mark - Actions

- (void)updateCommentCount {
    [self.poopInfoView updateCommentCountForPoop:self.viewModel.poop];
}

- (void)updateLoadingStatus:(NSDictionary *)change {
    NSNumber *loading = change[kRZDBChangeKeyNew];

    self.commentAccessoryView.loading = loading.boolValue;
}

- (void)showPoopInfoView {
    self.pprNavigationController.actionBarHeight.constant = self.poopInfoViewHeight;
    self.poopInfoViewBottom.constant = 0.0f;
    [self.pprNavigationController.view layoutIfNeeded];
}

- (void)hidePoopInfoView {
    self.pprNavigationController.actionBarHeight.constant = 50.0f;
    self.poopInfoViewBottom.constant = -CGRectGetHeight(self.poopInfoView.frame);
    [self.pprNavigationController.view layoutIfNeeded];
}

#pragma mark - Collection List Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    PPRPoopDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[PPRPoopDetailCommentCell ppr_reuseIdentifier] forIndexPath:indexPath];
    PPRComment *comment = [self.viewModel commentAtIndexPath:indexPath];

    [cell setupWithComment:comment];

    return cell;
}

- (void)tableView:(UITableView *)tableView updateCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    PPRPoopDetailCommentCell *commentCell = (PPRPoopDetailCommentCell *)cell;
    [commentCell setupWithComment:object];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isTransitioning && !self.isKeyboardVisible) {
        CGFloat offset = -(scrollView.contentOffset.y + scrollView.contentInset.top);
        offset = MAX(offset, 0.0f);

        UIEdgeInsets insets = scrollView.scrollIndicatorInsets;
        insets.top = offset + self.poopInfoViewHeight;
        scrollView.scrollIndicatorInsets = insets;

        self.pprNavigationController.actionBarHeight.constant = offset + self.poopInfoViewHeight;
    }
}

#pragma mark - Comment Accessory View Delegate

- (void)commentAccessoryViewDidTapSubmit:(PPRCommentAccessoryView *)commentAccessoryView {
    NSString *body = commentAccessoryView.text;
    [commentAccessoryView clearText];

    [self.viewModel addCommentWithBody:body];
}

@end

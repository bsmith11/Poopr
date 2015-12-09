//
//  PPRPoopDetailViewModel.m
//  Poopr
//
//  Created by Bradley Smith on 12/4/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "PPRPoopDetailViewModel.h"

#import "PPRPoop+Parse.h"
#import "PPRComment+RZImport.h"

#import "PPRLog.h"

#import "UITableView+PPRUtilities.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDataBinding.h>

@interface PPRPoopDetailViewModel () <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic, readwrite) PPRPoop *poop;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id <PPRPoopDetailViewModelDelegate> delegate;

@property (assign, nonatomic, readwrite) BOOL loading;
@property (assign, nonatomic, readwrite) NSUInteger commentCount;
@property (assign, nonatomic) BOOL shouldScrollToBottom;

@end

@implementation PPRPoopDetailViewModel

#pragma mark - Lifecycle

- (instancetype)initWithPoop:(PPRPoop *)poop {
    self = [super init];

    if (self) {
        self.poop = poop;
    }

    return self;
}

#pragma mark - Setup

- (void)configureTableView:(UITableView *)tableView delegate:(id<PPRPoopDetailViewModelDelegate>)delegate {
    self.tableView = tableView;
    self.tableView.dataSource = self;

    self.delegate = delegate;

    self.fetchedResultsController = [PPRComment fetchedResultsControllerWithPoop:self.poop];
    self.fetchedResultsController.delegate = self;
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        DDLogError(@"Failed to fetch comments with error: %@", error);
    }
}

- (void)addCommentWithBody:(NSString *)body {
    self.loading = YES;

    self.shouldScrollToBottom = YES;

    [PPRPoop addCommentWithBody:body
                           poop:self.poop
                     completion:^(NSError *error) {
                         self.loading = NO;

                         if (error) {
                             DDLogError(@"Failed to add comment with error: %@", error);
                         }
                     }];
}

#pragma mark - Actions

- (PPRComment *)commentAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self commentAtIndexPath:indexPath];

    return [self.delegate tableView:tableView cellForObject:object atIndexPath:indexPath];
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [CATransaction begin];

    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;

        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;

        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [CATransaction setCompletionBlock:^{
        if (self.shouldScrollToBottom) {
            self.shouldScrollToBottom = NO;

            [self.tableView ppr_scrollToBottomAnimated:YES];
        }
    }];

    [self.tableView endUpdates];

    [CATransaction commit];

    self.commentCount = self.fetchedResultsController.fetchedObjects.count;
}

@end

//
//  PPRPoopDetailViewModel.h
//  Poopr
//
//  Created by Bradley Smith on 12/4/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class PPRPoop, PPRComment;

@protocol PPRPoopDetailViewModelDelegate <NSObject>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end

@interface PPRPoopDetailViewModel : NSObject

- (instancetype)initWithPoop:(PPRPoop *)poop;
- (void)configureTableView:(UITableView *)tableView delegate:(id <PPRPoopDetailViewModelDelegate>)delegate;
- (void)addCommentWithBody:(NSString *)body;
- (PPRComment *)commentAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic, readonly) PPRPoop *poop;

@property (assign, nonatomic, readonly) BOOL loading;
@property (assign, nonatomic, readonly) NSUInteger commentCount;

@end

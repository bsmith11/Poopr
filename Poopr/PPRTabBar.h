//
//  PPRTabBar.h
//  Poopr
//
//  Created by Bradley Smith on 12/3/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

#import "PPRTabBarItem.h"

@class PPRTabBar;

@protocol PPRTabBarDelegate <NSObject>

- (void)PPRTabBar:(PPRTabBar *)tabBar didSelectItemAtIndex:(NSUInteger)index;

@end

@interface PPRTabBar : UIView

- (void)addTabBarItem:(PPRTabBarItem *)item;
- (void)removeTabBarItem:(PPRTabBarItem *)item;
- (void)insertTabBarItem:(PPRTabBarItem *)item atIndex:(NSUInteger)index;

@property (strong, nonatomic) UIColor *selectionViewColor;

@property (copy, nonatomic, readonly) NSArray<PPRTabBarItem *> *tabBarItems;

@property (weak, nonatomic) id <PPRTabBarDelegate> delegate;

@property (assign, nonatomic) NSUInteger selectedIndex;

@end

//
//  PPRPermissionCell.h
//  Poopr
//
//  Created by Bradley Smith on 9/16/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class PPRPermissionCell, PPRPermissionObject;

@protocol PPRPermissionCellDelegate <NSObject>

- (void)permissionCellDidSelectAccept:(PPRPermissionCell *)permissionCell;
- (void)permissionCellDidSelectSkip:(PPRPermissionCell *)permissionCell;

@end

@interface PPRPermissionCell : UICollectionViewCell

- (void)setupWithPermissionObject:(PPRPermissionObject *)permissionObject delegate:(id <PPRPermissionCellDelegate>)delegate;

@end

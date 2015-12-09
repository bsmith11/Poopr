//
//  PPRSettingsObject.h
//  Poopr
//
//  Created by Bradley Smith on 9/16/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

typedef NS_ENUM(NSInteger, PPRSettingsObjectType) {
    PPRSettingsObjectTypeRadius,
    PPRSettingsObjectTypeNotificationPoop,
    PPRSettingsObjectTypeNotificationComment
};

@interface PPRSettingsObject : NSObject

+ (instancetype)settingsObjectWithType:(PPRSettingsObjectType)type;

- (void)setEnabled:(BOOL)enabled completion:(void (^)(BOOL granted, BOOL displayAlert))completion;

@property (copy, nonatomic, readonly) NSString *title;

@property (assign, nonatomic, readonly) PPRSettingsObjectType type;
@property (assign, nonatomic) CGFloat min;
@property (assign, nonatomic) CGFloat max;
@property (assign, nonatomic) CGFloat value;
@property (assign, nonatomic) BOOL enabled;

@end

//
//  PPRAppDelegate.m
//  Poopr
//
//  Created by Bradley Smith on 9/11/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRAppDelegate.h"

#import "PPRRootViewController.h"

#import "PPRPoop+Parse.h"

#import "PPRSettings.h"
#import "PPRCoreDataStack.h"
#import "PPRLocationManager.h"
#import "PPRParseConstants.h"
#import "PPRLog.h"

#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>

NSString * const kPPRNotificationPermissionDidChangeNotification = @"com.poopr.settings.NotificationPermissionDidChangeNotification";

@interface PPRAppDelegate ()

@property (copy, nonatomic) PPRNotificationPermissionBlock notificationPermissionBlock;

@end

@implementation PPRAppDelegate

#pragma mark - Actions

- (BOOL)notificationPermissionEnabled {
    UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];

    return (notificationSettings.types == UIUserNotificationTypeAlert);
}

- (void)requestNotificationPermissionWithCompletion:(PPRNotificationPermissionBlock)completion {
    self.notificationPermissionBlock = completion;

    UIUserNotificationType types = UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - Application Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    [PPRCoreDataStack configureStack];

    [ParseCrashReporting enable];
    [Parse setApplicationId:kPPRParseApplicationID
                  clientKey:kPPRParseClientKey];

    if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
        [[PPRLocationManager sharedInstance] checkForRecentNearbyPoops];
    }

    PPRRootViewController *rootViewController = [[PPRRootViewController alloc] init];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:rootViewController];
    [self.window setBackgroundColor:[UIColor whiteColor]];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    BOOL granted = (notificationSettings.types == UIUserNotificationTypeAlert);

    if (self.notificationPermissionBlock) {
        self.notificationPermissionBlock(granted);
        self.notificationPermissionBlock = nil;
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *installation = [PFInstallation currentInstallation];
     [installation setDeviceTokenFromData:deviceToken];
     [installation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DDLogError(@"Failed to register for remote notifications with error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    BOOL granted = [self notificationPermissionEnabled];
    if (!granted) {
        [PPRSettings setPoopNotificationsEnabled:granted];
        [PPRSettings setCommentNotificationsEnabled:granted];

        [[NSNotificationCenter defaultCenter] postNotificationName:kPPRNotificationPermissionDidChangeNotification object:nil];
    }
}

@end

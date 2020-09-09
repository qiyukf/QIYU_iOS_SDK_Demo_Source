//
//  AppDelegate.m
//  QYSDKDemo
//
//  Created by liaosipei on 2020/3/2.
//  Copyright © 2020 Netease. All rights reserved.
//

#import "AppDelegate.h"
#import "QYHomePageViewController.h"
#import "IQKeyboardManager.h"
#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYSDK.h>

#import <UserNotifications/UserNotifications.h>


@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    QYHomePageViewController *vc = [[QYHomePageViewController alloc] init];
    _window.rootViewController = vc;
    [_window makeKeyAndVisible];
    
    //APNs
    [self registerAPNs];
    
    /**
     * IQKeyboardManager
     */
    //全局关闭IQKeyboardManager
    [IQKeyboardManager sharedManager].enable = NO;
    //关闭IQ在键盘上加的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    /**
     * V5.11.0 修复了留言表单及工单页面键盘适配问题，项目中IQKeyboardManager可去掉或是关闭功能
     */
    //部分页面启用键盘管理：工单页面-YSFWorkOrderViewController、留言表单页面-YSFMessageFormViewController
//    [[IQKeyboardManager sharedManager].enabledDistanceHandlingClasses addObject:NSClassFromString(@"YSFWorkOrderViewController")];
//    [[IQKeyboardManager sharedManager].enabledDistanceHandlingClasses addObject:NSClassFromString(@"YSFMessageFormViewController")];
    //点击页面非输入区域时收起键盘
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

#pragma mark - APNs
//注册通知，区分iOS10以上、iOS8-iOS10，iOS8以下三种方式注册
- (void)registerAPNs {
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"UNUserNotificationCenter request authorization success");
            } else {
                NSLog(@"UNUserNotificationCenter request authorization failed %@", error);
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        //若为iOS10以下系统，使用UIUserNotification
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"register remote notification success %@", [NSString stringWithFormat:@"%@",deviceToken]);
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"register remote notification failed %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}


@end

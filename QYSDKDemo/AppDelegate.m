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


@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    QYHomePageViewController *vc = [[QYHomePageViewController alloc] init];
    _window.rootViewController = vc;
    [_window makeKeyAndVisible];
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

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"register remote notification success %@", [NSString stringWithFormat:@"%@",deviceToken]);
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"register remote notification failed %@", error);
}


@end

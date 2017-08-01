//
//  AppDelegate.m
//  YSFDemo
//
//  Created by amao on 8/25/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "AppDelegate.h"
#import "QYHomePageViewController.h"
#import "QYSDK.h"
#import "QYDemoConfig.h"
#import "NSDictionary+YSF.h"
#import "QYSettingViewController.h"

#define YSFSelectAppKey 1

@interface AppDelegate ()

@end  

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    QYHomePageViewController *vc = [[QYHomePageViewController alloc] init];
    _window.rootViewController = vc;
    
    [_window makeKeyAndVisible];

    //推送消息相关处理
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    
    NSDictionary *remoteNotificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationInfo) {
        [self showChatViewController:remoteNotificationInfo];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"register remote notification failed %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        [self showChatViewController:userInfo];
    }
}

- (void)showChatViewController:(NSDictionary *)remoteNotificationInfo
{
    id object = [remoteNotificationInfo objectForKey:@"nim"]; //含有“nim”字段，就表示是七鱼的消息
    if (object)
    {
        //所有 UINavigationController 都先 popToRootViewController，
        //然后将聊天窗口 push 进某个 UINavigationController
        QYHomePageViewController *rootVc = (QYHomePageViewController *)_window.rootViewController;
        assert(rootVc.viewControllers.count == 2);
        UINavigationController *mainNav = rootVc.viewControllers[0];
        [mainNav popToRootViewControllerAnimated:NO];
        UINavigationController *settingNav = rootVc.viewControllers[1];
        [settingNav popToRootViewControllerAnimated:NO];
        [rootVc setSelectedIndex:1];
        assert(settingNav.viewControllers.count > 0);
        QYSettingViewController *settingViewController = settingNav.viewControllers[0];
        [settingViewController onChat];
    }
}

@end

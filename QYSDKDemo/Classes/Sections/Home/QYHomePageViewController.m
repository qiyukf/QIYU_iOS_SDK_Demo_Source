//
//  QYHomePageViewController.m
//  YSFDemo
//
//  Created by 赛赛 on 15/12/30.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "QYHomePageViewController.h"
#import "QYBindAppkeyViewController.h"
#import "QYDemoConfig.h"
#import "UIView+YSFToast.h"
#import "QYUserTableViewController.h"
#import "QYAppKeyConfig.h"
#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYSDK.h>

#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"


@interface QYHomePageViewController ()

@end


@implementation QYHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //读取本地存储的AppKey信息
    [self readAppkey];
    
    //注册SDK
    [self registerSDK];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [[self tabbars] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * item = obj;
        NSString * vcName = item[TabbarVC];
        NSString * title  = item[TabbarTitle];
        NSString * imageName = item[TabbarImage];
        NSString * imageSelected = item[TabbarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController * vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = NO;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:imageSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [nav.tabBarItem  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor systemRedColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        nav.tabBarItem.tag = idx;
        [array addObject:nav];
    }];
    self.viewControllers = array;
}

- (NSArray*)tabbars
{
    NSArray *item = @[
                      @{
                          TabbarVC           : @"QYMainViewController",
                          TabbarTitle        : @"首页",
                          TabbarImage        : @"icon_homepage_normal",
                          TabbarSelectedImage: @"icon_homepage_selected",
                          },
                      @{
                          TabbarVC           : @"QYSettingViewController",
                          TabbarTitle        : @"设置",
                          TabbarImage        : @"icon_setting_normal",
                          TabbarSelectedImage: @"icon_setting_selected",
                          },
                      ];
    return item;
}

- (void)readAppkey {
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self configFilepath]];
    if (data && [data isKindOfClass:[QYAppKeyConfig class]]) {
        QYAppKeyConfig *appData = (QYAppKeyConfig *)data;
        [[QYDemoConfig sharedConfig] setAppKey:appData.appKey];
        [[QYDemoConfig sharedConfig] setIsFusion:appData.isFusion];
    }
}

- (void)registerSDK {
    QYSDKOption *option = [[QYSDKOption alloc] init];
    option.appKey = [[QYDemoConfig sharedConfig] appKey];
    option.appName = [[QYDemoConfig sharedConfig] appName];
    option.isFusion = [[QYDemoConfig sharedConfig] isFusion];
    [[QYSDK sharedSDK] registerWithOption:option];
}

- (NSString *)configFilepath {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [dir stringByAppendingPathComponent:@"qy_appkey.plist"];
}

@end

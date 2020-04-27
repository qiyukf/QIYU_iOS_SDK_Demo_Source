//
//  QYHomePageViewController.m
//  QYSDKDemo
//
//  Created by liaosipei on 2020/3/2.
//  Copyright © 2020 Netease. All rights reserved.
//

#import "QYHomePageViewController.h"

#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"


@interface QYHomePageViewController ()

@end


@implementation QYHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [[self tabbars] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *item = obj;
        NSString *vcName = item[TabbarVC];
        NSString *title  = item[TabbarTitle];
        NSString *imageName = item[TabbarImage];
        NSString *imageSelected = item[TabbarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController *vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = NO;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:imageSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [nav.tabBarItem  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor systemRedColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        nav.tabBarItem.tag = idx;
        [array addObject:nav];
    }];
    self.viewControllers = array;
}

- (NSArray*)tabbars {
    NSArray *item = @[
        @{
            TabbarVC : @"QYMainViewController",
            TabbarTitle : @"首页",
            TabbarImage : @"icon_homepage_normal",
            TabbarSelectedImage : @"icon_homepage_selected",
        },
        @{
            TabbarVC : @"QYSettingViewController",
            TabbarTitle : @"设置",
            TabbarImage : @"icon_setting_normal",
            TabbarSelectedImage : @"icon_setting_selected",
        },
    ];
    return item;
}

@end

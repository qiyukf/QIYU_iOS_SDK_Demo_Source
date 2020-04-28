//
//  QYMacro.h
//  QYSDKDemo
//
//  Created by liaosipei on 2020/3/2.
//  Copyright © 2020 Netease. All rights reserved.
//

#ifndef QYMacro_h
#define QYMacro_h

#define QYSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define qy_dispatch_async_main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#pragma mark - 常用宏定义
#define QYStrParam(x)          ((x) ? : @"")

#define QYIOS7             ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
#define QYIOS7_1           ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.1)
#define QYIOS8             ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define QYIOS8_2           ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.2)
#define QYIOS9             ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0)
#define QYIOS10            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0)
#define QYIOS11            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11.0)
#define QYIOS12            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 12.0)

//判断设备是否是iPad
#define iPadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//屏幕scale
#define QYUIScreenScale    ([[UIScreen mainScreen] scale])
//是否横屏
#define QYIsLandscape      (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//是否retina屏
#define QYRETINA           (QYUIScreenScale >= 2)
//是否3x手机
#define QYRETINAHD         (QYUIScreenScale >= 3)
//当前屏幕的宽度和高度，已经考虑旋转的因素(iOS8上[UIScreen mainScreen].bounds直接就考虑了旋转因素，iOS8以下[UIScreen mainScreen].bounds是不变的值)
#define QYUIScreenWidth    ((QYIOS8 || !QYIsLandscape) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
#define QYUIScreenHeight   ((QYIOS8 || !QYIsLandscape) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)
//statusBar-状态栏高度
#define QYStatusBarHeight      ([[UIApplication sharedApplication] statusBarFrame].size.height)
//针对X/XR/XS/XS Max的底部适配
#define QYSafeAreaBottomHeight (([[UIApplication sharedApplication] statusBarFrame].size.height) > 20 ? 34 : 0)
//navigation-导航栏高度
#define QYNavigationBarHeight  (QYStatusBarHeight + 44)
//tabBar-工具栏高度
#define QYTabBarHeight         (([[UIApplication sharedApplication] statusBarFrame].size.height) > 20 ? (49 + 34) : 49)


#pragma mark - UIColor宏定义
//QYColorFromRGBA(rgbValue, alphaValue)
#define QYColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
//QYColorFromRGB(rgbValue)
#define QYColorFromRGB(rgbValue) QYColorFromRGBA(rgbValue, 1.0)

//QYRGBA(rgbValue, alphaValue)
#define QYRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
//QYRGB(rgbValue)
#define QYRGB(rgbValue) QYRGBA(rgbValue, 1.0)

//QYRGBA2(rgbaValue)
#define QYRGBA2(rgbaValue) [UIColor \
colorWithRed:((float)((rgbaValue & 0x00FF0000) >> 16))/255.0 \
green:((float)((rgbaValue & 0x0000FF00) >> 8))/255.0 \
blue:((float)(rgbaValue & 0x000000FF))/255.0 \
alpha:((float)((rgbaValue & 0xFF000000) >> 24))/255.0]

//RGBCOLOR(r,g,b)
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//RGBACOLOR(r,g,b,a)
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//常用颜色定义
#define QYBlueColor  QYColorFromRGB(0x337eff)
#define QYBlueHighlightedColor  [QYBlueColor colorWithAlphaComponent:0.5]
#define QYTextGrayColor  QYColorFromRGB(0x333333)
#define QYLineColor      QYColorFromRGB(0xededed)
#define QYTipBackColor   QYColorFromRGB(0xfff9e2)
#define QYTipTextColor   QYColorFromRGB(0xc08722)
#define QYPlaceholderColor           QYColorFromRGB(0xcccccc)
#define QYButtonTitleNormalColor     QYColorFromRGB(0x666666)
#define QYButtonTitleDisableColor    QYColorFromRGB(0x999999)
#define QYButtonBackDisableColor     QYColorFromRGB(0xf2f2f5)
#define QYButtonBorderColor          QYColorFromRGB(0xe1e3e6)
#define QYInputBackgroundColor       QYColorFromRGB(0xf6f6f6)
#define QYStatusOrangeColor          QYColorFromRGB(0xfe6112)
#define QYNotificationBackColor      QYColorFromRGB(0xd0d3d9)


#endif /* QYMacro_h */

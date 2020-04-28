//
//  QYMacro.h
//  QYSDKDemo
//
//  Created by liaosipei on 2020/3/2.
//  Copyright © 2020 Netease. All rights reserved.
//

#ifndef QYMacro_h
#define QYMacro_h

#define YSFSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define ysf_dispatch_async_main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#pragma mark - 常用宏定义
#define QYStrParam(x)          ((x) ? : @"")

#define YSFIOS7             ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
#define YSFIOS7_1           ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.1)
#define YSFIOS8             ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define YSFIOS8_2           ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.2)
#define YSFIOS9             ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0)
#define YSFIOS10            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0)
#define YSFIOS11            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11.0)
#define YSFIOS12            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 12.0)

//判断设备是否是iPad
#define iPadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//屏幕scale
#define YSFUIScreenScale    ([[UIScreen mainScreen] scale])
//是否横屏
#define YSFIsLandscape      (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//是否retina屏
#define YSFRETINA           (YSFUIScreenScale >= 2)
//是否3x手机
#define YSFRETINAHD         (YSFUIScreenScale >= 3)
//当前屏幕的宽度和高度，已经考虑旋转的因素(iOS8上[UIScreen mainScreen].bounds直接就考虑了旋转因素，iOS8以下[UIScreen mainScreen].bounds是不变的值)
#define YSFUIScreenWidth    ((YSFIOS8 || !YSFIsLandscape) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
#define YSFUIScreenHeight   ((YSFIOS8 || !YSFIsLandscape) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)
//statusBar-状态栏高度
#define YSFStatusBarHeight      ([[UIApplication sharedApplication] statusBarFrame].size.height)
//针对X/XR/XS/XS Max的底部适配
#define YSFSafeAreaBottomHeight (([[UIApplication sharedApplication] statusBarFrame].size.height) > 20 ? 34 : 0)
//navigation-导航栏高度
#define YSFNavigationBarHeight  (YSFStatusBarHeight + 44)
//tabBar-工具栏高度
#define YSFTabBarHeight         (([[UIApplication sharedApplication] statusBarFrame].size.height) > 20 ? (49 + 34) : 49)
//手动布局view起始Y坐标
#define YSFViewStartOffsetY     (YSFIOS7 ? (YSFIsLandscape ? 52 : YSFNavigationBarHeight) : 0)
//1px对应的pt值
#define YSFPixel                (1.0 / YSFUIScreenScale)
//屏幕宽度相对于375宽度比例
#define YSFScreenAdapterScale   ([UIScreen mainScreen].bounds.size.width / 375.0)


#pragma mark - UIColor宏定义
//YSFColorFromRGBA(rgbValue, alphaValue)
#define YSFColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
//YSFColorFromRGB(rgbValue)
#define YSFColorFromRGB(rgbValue) YSFColorFromRGBA(rgbValue, 1.0)

//YSFRGBA(rgbValue, alphaValue)
#define YSFRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
//YSFRGB(rgbValue)
#define YSFRGB(rgbValue) YSFRGBA(rgbValue, 1.0)

//YSFRGBA2(rgbaValue)
#define YSFRGBA2(rgbaValue) [UIColor \
colorWithRed:((float)((rgbaValue & 0x00FF0000) >> 16))/255.0 \
green:((float)((rgbaValue & 0x0000FF00) >> 8))/255.0 \
blue:((float)(rgbaValue & 0x000000FF))/255.0 \
alpha:((float)((rgbaValue & 0xFF000000) >> 24))/255.0]

//RGBCOLOR(r,g,b)
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//RGBACOLOR(r,g,b,a)
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//常用颜色定义
#define YSFQYBlueColor  YSFColorFromRGB(0x337eff)
#define YSFQYBlueHighlightedColor  [YSFQYBlueColor colorWithAlphaComponent:0.5]
#define YSFQYTextGrayColor  YSFColorFromRGB(0x333333)
#define YSFQYLineColor      YSFColorFromRGB(0xededed)
#define YSFQYTipBackColor   YSFColorFromRGB(0xfff9e2)
#define YSFQYTipTextColor   YSFColorFromRGB(0xc08722)
#define YSFQYPlaceholderColor           YSFColorFromRGB(0xcccccc)
#define YSFQYButtonTitleNormalColor     YSFColorFromRGB(0x666666)
#define YSFQYButtonTitleDisableColor    YSFColorFromRGB(0x999999)
#define YSFQYButtonBackDisableColor     YSFColorFromRGB(0xf2f2f5)
#define YSFQYButtonBorderColor          YSFColorFromRGB(0xe1e3e6)
#define YSFQYInputBackgroundColor       YSFColorFromRGB(0xf6f6f6)
#define YSFQYStatusOrangeColor          YSFColorFromRGB(0xfe6112)
#define YSFQYNotificationBackColor      YSFColorFromRGB(0xd0d3d9)


#endif /* QYMacro_h */

//
//  NIMGlobalMacro.h
//  YSFKit
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#ifndef YSF_Macro_h
#define YSF_Macro_h


#define YSFSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#pragma mark - UIColor宏定义
#define YSFColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define YSFColorFromRGB(rgbValue) YSFColorFromRGBA(rgbValue, 1.0)



#define ysf_dispatch_async_main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}



#pragma mark - 系统定义
//判断设备是否是iPad
#define iPadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//系统版本枚举除了iOS5外,都是指大于等于当前那个版本,如IOS6表示当前版本号大于等于6.0
//所以在这个基础上，如果要判断当前版本是6.0版本就必须是: (IOS6 && !IOS7)
//但是不推荐这样的做法,大部分的系统判断都可以用responseToSelector替代
//只有在少部分大量用到某个版本以上API的地方才使用
#define YSFIOS9            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0)
#define YSFIOS8            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define YSFIOS8_2          ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.2)
#define YSFIOS7            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
#define YSFIOS7_1          ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.1)

#define YSFUIScreenScale  ([[UIScreen mainScreen] scale])
#define YSFIsLandscape   (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

#define YSFRETINA          (YSFUIScreenScale >= 2)
// iphone 6以上的scale叫做RETINAHD好了
#define YSFRETINAHD        (YSFUIScreenScale >= 3)
// 当前屏幕的宽度和高度，已经考虑旋转的因素(iOS8上[UIScreen mainScreen].bounds直接就考虑了旋转因素，iOS8以下[UIScreen mainScreen].bounds是不变的值)
#define YSFUIScreenWidth    ((YSFIOS8 || !YSFIsLandscape) ?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height)
#define YSFUIScreenHeight   ((YSFIOS8 || !YSFIsLandscape) ?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)
// 由于现在适配的机器多了不建议使用以下屏幕参数来做判断，建议旧的view使用UIScreenWidth和UIScreenHeight来做动态适配,新的view可以考虑用autolayout
#define YSFIPHONE3_5INCH   ((YSFIsLandscape ? YSFUIScreenWidth :YSFUIScreenHeight) == 480)

//手动布局view起始Y坐标
#define YSFViewStartOffsetY (YSFIOS7? (YSFIsLandscape ? 52:64):0)
#define YSFNormalNavigationbarHeight       64.0f
#define YSFNavigationBarHeight  (([[UIApplication sharedApplication] statusBarFrame].size.height)>20 ? 84 :64)
#define YSFStatusBarHeight (([[UIApplication sharedApplication] statusBarFrame].size.height)>20 ? 40 :20)

#define YSFPixel (1.0/[[UIScreen mainScreen] scale])
#define YSFScreenAdapterScale   ([UIScreen mainScreen].bounds.size.width / 375.0)

#define YSFRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define YSFRGBA2(rgbaValue) [UIColor \
colorWithRed:((float)((rgbaValue & 0x00FF0000) >> 16))/255.0 \
green:((float)((rgbaValue & 0x0000FF00) >> 8))/255.0 \
blue:((float)(rgbaValue & 0x000000FF))/255.0 \
alpha:((float)((rgbaValue & 0xFF000000) >> 24))/255.0]

#define YSFRGB(rgbValue) YSFRGBA(rgbValue, 1.0)


#define YSFErrorDomain          @"ysf_error_domain"
#define YSFCodeInvalidData      -1       //错误数据

#define YSFStrParam(x)            ((x) ? : @"")


#define YSF_INLINE static inline

#define YSFNotification(x)           NSString *x = @#x
#define YSFDictionaryKey             YXNotification


YSF_INLINE void ysf_main_sync(dispatch_block_t block){
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

YSF_INLINE void ysf_main_async(dispatch_block_t block){
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define YSF_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

#define YSF_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

#define ResourceBundle  [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"QYResource" ofType:@"bundle"]]

#define BundleName @"QYResource.bundle"


#define ResourceFromBundle(x) [BundleName stringByAppendingPathComponent:@#x]

#endif

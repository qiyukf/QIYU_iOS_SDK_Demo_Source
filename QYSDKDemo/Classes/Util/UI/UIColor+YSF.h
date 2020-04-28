//
//  UIColor+HEX.h
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YSF)
+ (UIColor *)ysf_colorWithHex:(UInt32)hex;
+ (UIColor *)ysf_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)ysf_colorWithHexString:(NSString *)hexString;
- (NSString *)ysf_HEXString;

+ (UIColor *)ysf_colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)ysf_colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;
@end

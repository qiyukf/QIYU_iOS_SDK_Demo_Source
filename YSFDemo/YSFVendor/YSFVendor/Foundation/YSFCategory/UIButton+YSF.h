//
//  UIButton+YSF.h
//  YSFSDK
//
//  Created by panqinke on 15-12-17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    kButtonEdgeInsetsStyleImageLeft, // 图片在左边，文字在下面
    kButtonEdgeInsetsStyleImageRight,  // 图片在右边，文字在下面
    kButtonEdgeInsetsStyleImageTop,  // 图片在上边，文字在下面
    kButtonEdgeInsetsStyleImageBottom // 图片在下边，文字在上面
};

@interface UIButton (YSF)

+ (UIButton *)ysf_buttonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

+ (UIButton *)ysf_buttonWithTitle:(NSString *)title image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)ysf_layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style imageTitlespace:(CGFloat)space;

@end

//
//  UIView+YSFKit.h
//  YSFKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YSF)

@property (nonatomic) CGFloat ysf_frameLeft;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat ysf_frameTop;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat ysf_frameRight;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat ysf_frameBottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat ysf_frameWidth;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat ysf_frameHeight;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat ysf_frameCenterX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat ysf_frameCenterY;
/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint ysf_frameOrigin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize ysf_frameSize;


//找到自己的vc
- (UIViewController *)ysf_viewController;

/**
 * Removes all subviews.
 */
- (void)ysf_removeAllSubviews;

/*取消阴影*/
- (void)ysf_hideShadow;

/*设置阴影*/
- (void)shadowColor:(UIColor*)color shadowOffset:(CGSize)offset shadowRadius:(CGFloat)radius shadowOpacity:(CGFloat)opacity;

/*设置圆角*/
- (void)ysf_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;

/*既有圆角又有阴影*/
- (void)ysf_shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)offset shadowRadius:(CGFloat)sradius shadowOpacity:(CGFloat)opacity
       cornerRadius:(CGFloat)cradius borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor;

- (void)ysf_shake;

/*绘制特殊阴影,实现下页脚卷起的效果*/
-(void)ysf_configureBorder:(CGFloat)borderWidth shadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset;

//屏幕截图
-(UIImage*)ysf_viewToImage;

@end

//
//  UIView+ULK.h
//  UILayoutKit
//
//  Created by Tom Quist on 22.07.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//
//  Modified by towik on 19.07.16.
//  Copyright (c) 2016 towik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ULKDefine.h"


@interface ULKLayoutParams : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) UIEdgeInsets margin;

- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithLayoutParams:(ULKLayoutParams *)layoutParams;

@end


@interface UIView (ULK_Layout)

@property (nonatomic, assign) CGSize ulk_minSize;
@property (nonatomic, assign) CGSize ulk_maxSize;
@property (nonatomic, readonly) CGSize ulk_measuredSize;
@property (nonatomic, readonly) BOOL ulk_hadMeasured;
@property (nonatomic, readonly) ULKLayoutMeasuredWidthHeightState ulk_measuredState;
@property (nonatomic, readonly) CGFloat ulk_baseline;
@property (nonatomic, assign) NSString *ulk_identifier;
@property (nonatomic, assign) ULKViewVisibility ulk_visibility;

- (void)ulk_onMeasureWithWidthMeasureSpec:(ULKLayoutMeasureSpec)widthMeasureSpec heightMeasureSpec:(ULKLayoutMeasureSpec)heightMeasureSpec;
- (void)ulk_measureWithWidthMeasureSpec:(ULKLayoutMeasureSpec)widthMeasureSpec heightMeasureSpec:(ULKLayoutMeasureSpec)heightMeasureSpec;
- (void)ulk_onLayoutWithFrame:(CGRect)frame didFrameChange:(BOOL)changed;
- (BOOL)ulk_setFrame:(CGRect)frame;
- (void)ulk_layoutWithFrame:(CGRect)frame;

- (void)ulk_setMeasuredDimensionSize:(ULKLayoutMeasuredSize)size;
- (void)ulk_clearMeasuredDimensionSize;

- (void)ulk_requestLayout;
- (void)ulk_onFinishInflate;
- (UIView *)ulk_findViewById:(NSString *)identifier;

+ (ULKLayoutMeasuredWidthHeightState)ulk_combineMeasuredStatesCurrentState:(ULKLayoutMeasuredWidthHeightState)curState newState:(ULKLayoutMeasuredWidthHeightState)newState;
+ (ULKLayoutMeasuredDimension)ulk_resolveSizeAndStateForSize:(CGFloat)size measureSpec:(ULKLayoutMeasureSpec)measureSpec childMeasureState:(ULKLayoutMeasuredState)childMeasuredState;
+ (CGFloat)ulk_resolveSizeForSize:(CGFloat)size measureSpec:(ULKLayoutMeasureSpec)measureSpec;

@end


@interface UIView (ULK_Layout_ViewGroup)

- (ULKLayoutParams *)ulk_generateDefaultLayoutParams;
- (ULKLayoutParams *)ulk_generateLayoutParamsFromLayoutParams:(ULKLayoutParams *)lp;
- (BOOL)ulk_checkLayoutParams:(ULKLayoutParams *)layoutParams;
- (ULKLayoutMeasureSpec)ulk_childMeasureSpecWithMeasureSpec:(ULKLayoutMeasureSpec)spec padding:(CGFloat)padding childDimension:(CGFloat)childDimension;

- (void)ulk_measureChildWithMargins:(UIView *)child parentWidthMeasureSpec:(ULKLayoutMeasureSpec)parentWidthMeasureSpec widthUsed:(CGFloat)widthUsed parentHeightMeasureSpec:(ULKLayoutMeasureSpec)parentHeightMeasureSpec heightUsed:(CGFloat)heightUsed;
- (UIView *)ulk_findViewTraversal:(NSString *)identifier;

@property (nonatomic, readonly) BOOL ulk_isViewGroup;

@end


@interface UIView (ULKLayoutParams)

@property (nonatomic, assign) CGFloat ulk_layoutWidth;
@property (nonatomic, assign) CGFloat ulk_layoutHeight;
@property (nonatomic, assign) UIEdgeInsets ulk_layoutMargin;
@property (nonatomic, strong) ULKLayoutParams *ulk_layoutParams;

@end


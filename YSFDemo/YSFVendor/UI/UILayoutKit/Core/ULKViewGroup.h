//
//  ViewGroup.h
//  UILayoutKit
//
//  Created by Tom Quist on 22.07.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//
//  Modified by towik on 19.07.16.
//  Copyright (c) 2016 towik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ULK_Layout.h"

@interface ULKViewGroup : UIView

@property (nonatomic, assign) UIEdgeInsets ulk_padding;

+ (ULKLayoutMeasureSpec)childMeasureSpecForMeasureSpec:(ULKLayoutMeasureSpec)spec padding:(CGFloat)padding childDimension:(CGFloat)childDimension;

/**
 * Did add a child view.
 *
 * @param child the child view to add
 */
- (void)didAddSubview:(UIView *)subview;

/**
 * Will remove the specified child from the group.
 *
 * @param view to remove from the group
 */
- (void)willRemoveSubview:(UIView *)subview;

@end

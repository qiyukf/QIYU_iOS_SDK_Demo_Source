//
//  Gravity.h
//  UILayoutKit
//
//  Created by Tom Quist on 22.07.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//
//  Modified by towik on 19.07.16.
//  Copyright (c) 2016 towik. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * This is used by the layout-inflater to pass an action target to a UIControl
 */
FOUNDATION_EXPORT NSString *const ULKViewAttributeActionTarget;

enum ULKLayoutParamsSize {
    ULKLayoutParamsSizeMatchParent = -1,
    ULKLayoutParamsSizeWrapContent = -2
};

typedef NS_ENUM(NSInteger, ULKLayoutMeasureSpecMode) {
    ULKLayoutMeasureSpecModeUnspecified,
    ULKLayoutMeasureSpecModeExactly,
    ULKLayoutMeasureSpecModeAtMost
};

typedef struct ULKLayoutMeasureSpec {
    CGFloat size;
    ULKLayoutMeasureSpecMode mode;
} ULKLayoutMeasureSpec;

ULKLayoutMeasureSpec ULKLayoutMeasureSpecMake(CGFloat size, ULKLayoutMeasureSpecMode mode);

typedef NS_OPTIONS(NSInteger, ULKLayoutMeasuredState) {
    ULKLayoutMeasuredStateNone = 0x0,
    ULKLayoutMeasuredStateTooSmall = 0x1
};

typedef struct ULKLayoutMeasuredDimension {
    CGFloat size;
    ULKLayoutMeasuredState state;
} ULKLayoutMeasuredDimension;

typedef struct ULKLayoutMeasuredSize {
    ULKLayoutMeasuredDimension width;
    ULKLayoutMeasuredDimension height;
} ULKLayoutMeasuredSize;

typedef struct ULKLayoutMeasuredWidthHeightState {
    ULKLayoutMeasuredState widthState;
    ULKLayoutMeasuredState heightState;
} ULKLayoutMeasuredWidthHeightState;

typedef NS_OPTIONS(NSInteger, ULKViewVisibility) {
    ULKViewVisibilityVisible = 0x00000000,
    ULKViewVisibilityInvisible = 0x00000004,
    ULKViewVisibilityGone = 0x00000008
};

ULKLayoutMeasuredSize ULKLayoutMeasuredSizeMake(ULKLayoutMeasuredDimension width, ULKLayoutMeasuredDimension height);


#define AXIS_SPECIFIED 0x0001
#define AXIS_PULL_BEFORE 0x0002
#define AXIS_PULL_AFTER 0x0004
#define AXIS_CLIP 0x0008
#define AXIS_X_SHIFT 0
#define AXIS_Y_SHIFT 4
#define HORIZONTAL_GRAVITY_MASK (AXIS_SPECIFIED | AXIS_PULL_BEFORE | AXIS_PULL_AFTER) << AXIS_X_SHIFT
#define VERTICAL_GRAVITY_MASK  (AXIS_SPECIFIED | AXIS_PULL_BEFORE | AXIS_PULL_AFTER) << AXIS_Y_SHIFT
#define RELATIVE_HORIZONTAL_GRAVITY_MASK (ULKGravityLeft | ULKGravityRight)
#define DEFAULT_CHILD_GRAVITY ULKGravityTop | ULKGravityLeft

typedef NS_OPTIONS(NSInteger, ULKGravity) {
    ULKGravityNone = 0x0000,
    ULKGravityTop = (AXIS_PULL_BEFORE|AXIS_SPECIFIED)<<AXIS_Y_SHIFT,
    ULKGravityBottom = (AXIS_PULL_AFTER|AXIS_SPECIFIED)<<AXIS_Y_SHIFT,
    ULKGravityLeft = (AXIS_PULL_BEFORE|AXIS_SPECIFIED)<<AXIS_X_SHIFT,
    ULKGravityRight = (AXIS_PULL_AFTER|AXIS_SPECIFIED)<<AXIS_X_SHIFT,
    ULKGravityCenterVertical = AXIS_SPECIFIED<<AXIS_Y_SHIFT,
    ULKGravityFillVertical = ULKGravityTop|ULKGravityBottom,
    ULKGravityCenterHorizontal = AXIS_SPECIFIED<<AXIS_X_SHIFT,
    ULKGravityFillHorizontal = ULKGravityLeft|ULKGravityRight,
    ULKGravityCenter = ULKGravityCenterVertical|ULKGravityCenterHorizontal,
    ULKGravityFill = ULKGravityFillVertical|ULKGravityFillHorizontal
};



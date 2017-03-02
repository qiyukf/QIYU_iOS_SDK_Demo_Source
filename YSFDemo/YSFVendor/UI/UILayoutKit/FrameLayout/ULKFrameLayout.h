//
//  ULKFrameLayout.h
//  UILayoutKit
//
//  Created by Tom Quist on 22.07.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//
//  Modified by towik on 19.07.16.
//  Copyright (c) 2016 towik. All rights reserved.
//

#import "ULKViewGroup.h"
#import "ULKDefine.h"

@interface ULKFrameLayoutParams : ULKLayoutParams

@property (nonatomic, assign) ULKGravity gravity;

@end


@interface UIView (ULK_FrameLayoutParams)

@property (nonatomic, assign) ULKGravity ulk_layoutGravity;

@end


@interface ULKFrameLayout : ULKViewGroup

@end

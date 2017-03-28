//
//  QYSessionViewController.h
//  QYSDK
//
//  Created by towik on 12/21/15.
//  Copyright (c) 2017 Netease. All rights reserved.
//

#import "QYSessionViewController.h"

/**
 *  平台电商专用
 */
@protocol QYSessionViewDelegate <NSObject>

/**
 *  点击商铺入口按钮回调
 */
- (void)onTapShopEntrance;

/**
 *  点击聊天窗口右边或左边会话列表按钮回调
 */
- (void)onTapSessionListEntrance;


@end

/**
 *  平台电商专用
 */
@interface QYSessionViewController (POP)

/**
 *  平台电商店铺Id，不是平台电商不用管
 */
@property (nonatomic,copy)    NSString *shopId;

/**
 *  会话窗口回调
 */
@property (nonatomic, weak) id<QYSessionViewDelegate> delegate;

@end

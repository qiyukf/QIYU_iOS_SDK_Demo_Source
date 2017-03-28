//
//  QYCustomUIConfig.h
//  QYCustomUIConfig
//
//  Created by towik on 12/21/15.
//  Copyright (c) 2017 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  平台电商专用
 */
@interface QYCustomUIConfig (POP)

/**
 *  聊天窗口右上角商铺入口显示，默认不显示
 */
@property (nonatomic, assign)   BOOL showShopEntrance;

/**
 *  聊天窗口右上角商铺入口icon
 */
@property (nonatomic, strong) UIImage *shopEntranceImage;

/**
 *  聊天窗口右上角商铺入口文本
 */
@property (nonatomic, copy) NSString *shopEntranceText;

/**
 *  聊天窗口右边会话列表入口，默认不显示
 */
@property (nonatomic, assign) BOOL showSessionListEntrance;

/**
 *  会话列表入口在聊天页面的位置，YES代表在右上角，NO代表在左上角，默认在右上角
 */
@property (nonatomic, assign) BOOL sessionListEntrancePosition;

/**
 *  会话列表入口icon
 */
@property (nonatomic, strong) UIImage *sessionListEntranceImage;

@end




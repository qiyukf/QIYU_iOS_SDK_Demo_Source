//
//  QYPOPMessageInfo.h
//  YSFSDK
//
//  Created by towik on 16/12/29.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QYPOPMessageInfo : NSObject

/**
 *  会话ID，可以是商铺ID等
 */
@property (nonatomic, copy) NSString *shopId;

/**
 *  会话头像URL
 */
@property (nonatomic, copy) NSString *avatarImageUrlString;

/**
 *  发送者
 */
@property (nonatomic, copy) NSString *sender;

/**
 *  消息文本
 */
@property (nonatomic, copy) NSString *text;

/**
 *  消息时间
 */
@property (nonatomic, assign) NSTimeInterval timeStamp;


@end

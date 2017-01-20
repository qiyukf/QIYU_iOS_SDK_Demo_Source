//
//  QYSessionInfo.h
//  YSFSDK
//
//  Created by JackyYu on 16/12/2.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, QYSessionStatus) {
    QYSessionStatusNone,
    QYSessionStatusInSession,
    QYSessionStatusWaiting
};

/**
 *  平台电商专用；会话列表中的会话详情信息
 */
@interface QYPOPSessionInfo : NSObject

/**
 *  会话ID，可以是商铺ID等
 */
@property (nonatomic, copy) NSString *shopId;

/**
 *  会话头像URL
 */
@property (nonatomic, copy) NSString *avatarImageUrlString;

/**
 *  会话名称
 */
@property (nonatomic, copy) NSString *sessionName;

/**
 *  会话最后一条消息文本
 */
@property (nonatomic, copy) NSString *lastMessageText;

/**
 *  会话未读数
 */
@property (nonatomic, assign) NSInteger unreadCount;

/**
 *  会话状态
 */
@property (nonatomic, assign) QYSessionStatus status;

/**
 *  会话最后一条消息的时间
 */
@property (nonatomic, assign) NSTimeInterval lastMessageTimeStamp;


@end

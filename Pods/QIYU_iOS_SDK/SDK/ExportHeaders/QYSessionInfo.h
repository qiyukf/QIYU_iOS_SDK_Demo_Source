//
//  QYSessionInfo.h
//  YSFSDK
//
//  Created by JackyYu on 16/12/2.
//  Copyright (c) 2017 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYMessageInfo.h"

typedef NS_ENUM(NSInteger, QYSessionStatus) {
    QYSessionStatusNone,
    QYSessionStatusInSession,
    QYSessionStatusWaiting
};

/**
 *  平台电商专用；会话列表中的会话详情信息
 */
@interface QYSessionInfo : NSObject

/**
 *  会话最后一条消息文本
 */
@property (nonatomic, copy) NSString *lastMessageText;

/**
 *  消息类型
 */
@property (nonatomic, assign) QYMessageType lastMessageType;

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

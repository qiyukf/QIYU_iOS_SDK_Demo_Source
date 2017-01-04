//
//  QYConversationManager.h
//  QYSDK
//
//  Created by towik on 12/21/15.
//  Copyright (c) 2016 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYConversationManager.h"

/**
 *  平台电商专用
 */
@class QYPOPSessionInfo;
@class QYPOPMessageInfo;

/**
 *  会话委托
 */
@protocol QYPOPConversationManagerDelegate <NSObject>

/**
 *  会话列表变化
 */
- (void)onSessionListChanged;

/**
 *  收到消息
 */
- (void)onReceiveMessage:(QYPOPMessageInfo *)message;

@end


/**
 *  平台电商专用;会话管理类委托
 */
@interface QYConversationManager (POP)

/**
 *  获取所有会话的列表
 *
 *  @return 包含SessionInfo的数组
 */
- (NSArray<QYPOPSessionInfo*> *)getSessionList;
    
/**
 *  删除会话列表中的会话
 *
 *  @param shopId 商铺ID
 *  @param isDelete 是否删除消息记录，YES删除，NO不删除
 */
- (void)deleteRecentSessionByShopId:(NSString *)shopId deleteMessages:(BOOL)isDelete;

/**
 *  设置会话委托
 *
 *  @param delegate 会话委托
 */
- (void)popSetDelegate:(id<QYPOPConversationManagerDelegate>)delegate;
    
@end

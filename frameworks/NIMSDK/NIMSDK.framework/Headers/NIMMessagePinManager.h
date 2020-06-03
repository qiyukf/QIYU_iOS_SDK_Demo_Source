//
//  NIMMessagePinManager.h
//  NIMSDK
//
//  Created by 丁文超 on 2020/4/8.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMManager.h"
#import "NIMMessagePinItem.h"
#import "NIMChatExtendManagerProtocol.h"
#import "NIMMessagePinItem.h"
#import "NIMSyncMessagePinResponse.h"
#import "NIMSyncMessagePinRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface NIMMessagePinManager : NIMManager

/**
 * 保存成功同步的session，保证成功一次后不再同步
 */
@property (nonatomic,strong) NSMutableSet<NIMSession *> *successfullySyncedSessions;

/**
 * 添加一条PIN
 */
- (void)addMessagePin:(NIMMessagePinItem *)item completion:(NIMAddMessagePinCompletion)completion;

/**
 * 删除一条PIN
 */
- (void)removeMessagePin:(NIMMessagePinItem *)item completion:(NIMRemoveMessagePinCompletion)completion;

/**
 * 更新一条PIN的扩展字段
 */
- (void)updateMessagePin:(NIMMessagePinItem *)item completion:(NIMUpdateMessagePinCompletion)completion;

/**
 * 增量更新PIN消息
 */
- (void)syncMessagePin:(NIMSyncMessagePinRequest *)request completion:(NIMSyncMessagePinCompletion)completion;

/**
 * 更新会话PIN消息的时间戳，仅当本地时间戳大于或等于登录时间戳时才有效
 */
- (void)updateLocalTimestamp:(uint64_t)timestamp forSession:(NIMSession *)session;

@end

NS_ASSUME_NONNULL_END

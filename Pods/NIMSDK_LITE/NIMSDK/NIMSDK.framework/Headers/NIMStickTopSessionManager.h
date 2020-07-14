//
//  NIMStickTopSessionManager.h
//  NIMLib
//
//  Created by 丁文超 on 2020/4/1.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMChatExtendManagerProtocol.h"
#import "NIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NIMStickTopSessionManager : NIMManager 

/**
 * 添加一个置顶
 */
- (void)addStickTopSession:(NIMAddStickTopSessionParams *)newInfo completion:(NIMAddStickTopSessionCompletion __nullable)completion;

/**
 * 删除一个置顶会话
 */
- (void)removeStickTopSession:(NIMStickTopSessionInfo *)info completion:(NIMRemoveStickTopSessionCompletion __nullable)completion;

/**
 * 更新置顶会话扩展信息
 */
- (void)updateStickTopSession:(NIMStickTopSessionInfo *)info completion:(NIMUpdateStickTopSessionCompletion __nullable)completion;

/**
 * 更新置顶会话同步时间戳，仅当置顶开关开启时有效
 */
- (void)updateLocalTimestamp:(uint64_t)timestamp;

@end

NS_ASSUME_NONNULL_END

//
//  NIMSDK.h
//  NIMSDK
//
//  Created by Netease.
//  Copyright © 2017年 Netease. All rights reserved.
//

/**
 *  平台相关定义
 */
#import "NIMPlatform.h"

/**
 *  全局枚举和结构体定义
 */
#import "NIMGlobalDefs.h"

/**
 *  配置项
 */
#import "NIMSDKOption.h"
#import "NIMSDKConfig.h"

/**
 *  会话相关定义
 */
#import "NIMSession.h"
#import "NIMRecentSession.h"
#import "NIMMessageSearchOption.h"
#import "NIMIncompleteSessionInfo.h"


/**
 *  用户定义
 */
#import "NIMUser.h"
#import "NIMUserSearchOption.h"

/**
 *  群相关定义
 */
#import "NIMTeamDefs.h"
#import "NIMTeam.h"
#import "NIMTeamMember.h"
#import "NIMCreateTeamOption.h"
#import "NIMTeamManagerDelegate.h"
#import "NIMTeamFetchMemberOption.h"
#import "NIMTeamSearchOption.h"

/**
 *  消息定义
 */
#import "NIMMessage.h"
#import "NIMAddEmptyRecentSessionBySessionOption.h"
#import "NIMSystemNotification.h"
#import "NIMRevokeMessageNotification.h"
#import "NIMDeleteMessagesOption.h"
#import "NIMDeleteMessageOption.h"
//#import "NIMBroadcastMessage.h"
#import "NIMImportedRecentSession.h"
#import "NIMClearMessagesOption.h"
#import "NIMDeleteRecentSessionOption.h"
#import "NIMBatchDeleteMessagesOption.h"
#import "NIMRevokeMessageOption.h"
#import "NIMSessionDeleteAllRemoteMessagesOptions.h"
#import "NIMSessionDeleteAllRemoteMessagesInfo.h"


/**
 *  推送定义
 */
#import "NIMPushNotificationSetting.h"

/**
 *  登录定义
 */
#import "NIMLoginClient.h"
#import "NIMLoginKickoutResult.h"

/**
 *  文档转码信息
 */
//#import "NIMDocTranscodingInfo.h"

/**
 *  事件订阅
 */
//#import "NIMSubscribeEvent.h"
//#import "NIMSubscribeRequest.h"
//#import "NIMSubscribeOnlineInfo.h"
//#import "NIMSubscribeResult.h"

/**
 *  智能机器人
 */
//#import "NIMRobot.h"

/**
 *  缓存管理
 */
#import "NIMCacheQuery.h"

/**
 *  各个对外接口协议定义
 */
#import "NIMLoginManagerProtocol.h"
#import "NIMChatManagerProtocol.h"
#import "NIMConversationManagerProtocol.h"
#import "NIMMediaManagerProtocol.h"
#import "NIMUserManagerProtocol.h"
#import "NIMTeamManagerProtocol.h"
//#import "NIMSuperTeamManagerProtocol.h"
#import "NIMSystemNotificationManagerProtocol.h"
#import "NIMApnsManagerProtocol.h"
#import "NIMResourceManagerProtocol.h"
//#import "NIMChatroomManagerProtocol.h"
//#import "NIMDocTranscodingManagerProtocol.h"
//#import "NIMEventSubscribeManagerProtocol.h"
//#import "NIMRobotManagerProtocol.h"
//#import "NIMRedPacketManagerProtocol.h"
//#import "NIMBroadcastManagerProtocol.h"
//#import "NIMAntispamManagerProtocol.h"
//#import "NIMSignalManagerProtocol.h"
//#import "NIMPassThroughManagerProtocol.h"
//#import "NIMChatExtendManagerProtocol.h"
//#import "NIMIndexManagerProtocol.h"

/**
 *  SDK业务类
 */
#import "NIMServerSetting.h"
#import "NIMSDKHeader.h"

/**
 * 数据库
 */
#import "NIMDatabaseException.h"

/**
 *  资源
 */
#import "NIMResourceExtraInfo.h"

/**
 *  透传代理定义
 */
//#import "NIMPassThroughOption.h"


/**
 *  Thread Talk & 快捷回复
 */
//#import "NIMThreadTalkFetchOption.h"
//#import "NIMChatExtendBasicInfo.h"
//#import "NIMQuickComment.h"
//#import "NIMThreadTalkFetchResult.h"

/**
 * 收藏
 */
//#import "NIMCollectInfo.h"
//#import "NIMCollectQueryOptions.h"
//#import "NIMAddCollectParams.h"

/**
 * 置顶会话
 */
//#import "NIMStickTopSessionInfo.h"
//#import "NIMAddStickTopSessionParams.h"
//#import "NIMSyncStickTopSessionResponse.h"
//#import "NIMLoadRecentSessionsOptions.h"

/**
 * PIN
 */
//#import "NIMMessagePinItem.h"
//#import "NIMSyncMessagePinRequest.h"
//#import "NIMSyncMessagePinResponse.h"


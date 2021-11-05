//
// Created by Songwenhai on 2021/4/10.
// Copyright (c) 2021 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NIMChatroomMember;

/**
 *  禁言某个标签的用户的发言，只有管理员或创建者能操作
 */
@interface NIMChatroomTempMuteTagRequest : NSObject

/**
 *  聊天室ID
 */
@property(nullable, nonatomic, copy) NSString *roomId;

/**
 *  禁言的tag
 */
@property(nullable, nonatomic, copy) NSString *targetTag;

/**
 *  禁言的时长，单位秒，若设置为0，则表示取消禁言
 */
@property(nonatomic, assign) unsigned long long duartion;


/**
 *  是否需要通知
 */
@property(nonatomic, assign) BOOL needNotify;

/**
 *  操作通知事件扩展
 */
@property(nullable, nonatomic, copy) NSString *notifyExt;

/**
 *  禁言通知广播的目标标签，默认是targetTag
 */
@property(nullable, nonatomic, copy) NSString *notifyTargetTags;


@end

/**
 *  根据用户标签获取聊天室成员请求
 */
@interface NIMChatroomFetchMembersByTagRequest : NSObject

/**
 *  聊天室ID
 */
@property(nullable, nonatomic, copy) NSString *roomId;

/**
 *  标签
 */
@property(nullable, nonatomic, copy) NSString *tag;

/**
 *  最后一位成员锚点，不包括此成员。填nil会使用当前服务器最新时间开始查询，即第一页。
 */
@property(nullable, nonatomic, strong) NIMChatroomMember *lastMember;

/**
 *  获取聊天室成员个数
 */
@property(nonatomic, assign) NSUInteger limit;


@end


/**
 *  根据用户标签获取聊天室在线成员数量请求
 */
@interface NIMChatroomQueryMembersCountByTagRequest : NSObject

/**
 *  聊天室ID
 */
@property(nullable, nonatomic, copy) NSString *roomId;

/**
 *  标签
 */
@property(nullable, nonatomic, copy) NSString *tag;

@end
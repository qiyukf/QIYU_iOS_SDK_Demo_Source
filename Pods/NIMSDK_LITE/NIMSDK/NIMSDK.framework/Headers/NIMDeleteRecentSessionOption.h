//
//  NIMDeleteRecentSessionOption.h
//  NIMSDK
//
//  Created by I am Groot on 2020/12/6.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NIMDeleteRecentSessionOption : NSObject
/**
 *  是否移除该会话的服务端漫游消息
 *  @discussion ，默认为 NO，仅删除本地会话；为YES，将同时删除服务端漫游消息
 */
@property   (nonatomic,assign)  BOOL    isDeleteRoamMessage;

@end

NS_ASSUME_NONNULL_END

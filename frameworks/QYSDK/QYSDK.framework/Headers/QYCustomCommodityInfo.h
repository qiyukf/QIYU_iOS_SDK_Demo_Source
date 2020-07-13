//
//  QYCustomCommodityInfo.h
//  QYBiz
//
//  Created by liaosipei on 2020/7/13.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYCustomMessage.h"

/**
 *  自定义商品卡片消息
 *  @discussion 收到客服发来的自定义商品卡片消息时，数据库中会自动插入一条QYCustomCommodityInfo类型消息
 *  通过调用QYCustomUIConfig的注册接口注入model及view，配置此自定义消息的UI显示
 */
@interface QYCustomCommodityInfo : QYCustomMessage

/**
 *  服务端透传的json数据
 */
@property (nonatomic, copy, readonly) NSString *jsonData;

@end


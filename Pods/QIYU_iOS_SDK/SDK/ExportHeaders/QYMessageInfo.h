//
//  QYPOPMessageInfo.h
//  YSFSDK
//
//  Created by towik on 16/12/29.
//  Copyright (c) 2017 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QYMessageType) {
    QYMessageTypeText,
    QYMessageTypeImage,
    QYMessageTypeAudio,
    QYMessageTypeCustom
};

@interface QYMessageInfo : NSObject

/**
 *  消息文本
 */
@property (nonatomic, copy) NSString *text;

/**
 *  消息类型
 */
@property (nonatomic, assign) QYMessageType type;

/**
 *  消息时间
 */
@property (nonatomic, assign) NSTimeInterval timeStamp;


@end

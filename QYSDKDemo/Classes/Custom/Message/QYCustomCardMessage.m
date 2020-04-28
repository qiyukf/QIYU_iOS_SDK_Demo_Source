//
//  QYCustomCardMessage.m
//  YSFDemo
//
//  Created by liaosipei on 2018/11/29.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "QYCustomCardMessage.h"

@implementation QYCustomCardMessage

- (NSString *)thumbText {
    return @"[自定义卡片消息]";
}

- (QYCustomMessageSourceType)messageSourceType {
    return QYCustomMessageSourceTypeNone;
}

@end

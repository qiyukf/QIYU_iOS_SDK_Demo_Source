//
//  QYCustomImageMessage.m
//  YSFDemo
//
//  Created by liaosipei on 2018/11/28.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "QYCustomImageMessage.h"
#import "QYCustomKeyDefine.h"
#import "NSDictionary+QYJson.h"
#import "NSString+QY.h"

@implementation QYCustomImageMessage

- (NSString *)thumbText {
    return @"[自定义图片消息]";
}

- (NSDictionary *)encodeMessage {
    return @{QYCustomKeyShowImage : @(self.showImage)};
}

- (void)decodeMessage:(NSDictionary *)content {
    self.showImage = [content qy_jsonBool:QYCustomKeyShowImage];
}

- (QYCustomMessageSourceType)messageSourceType {
    return QYCustomMessageSourceTypeSend;
}

@end

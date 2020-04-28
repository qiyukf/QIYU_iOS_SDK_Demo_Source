//
//  QYCustomTextMessage.m
//  YSFDemo
//
//  Created by liaosipei on 2018/11/23.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "QYCustomTextMessage.h"
#import "QYCustomKeyDefine.h"
#import "NSDictionary+QYJson.h"
#import "NSString+QY.h"
#import "QYMacro.h"

@implementation QYCustomTextMessage

- (NSString *)thumbText {
    if (self.text.length) {
        return self.text;
    }
    return @"[自定义文本消息]";
}

- (NSDictionary *)encodeMessage {
    return @{QYCustomKeyText : QYStrParam(self.text)};
}

- (void)decodeMessage:(NSDictionary *)content {
    NSString *text = QYStrParam([content qy_jsonString:QYCustomKeyText]);
    self.text = text;
}

- (QYCustomMessageSourceType)messageSourceType {
    return QYCustomMessageSourceTypeReceive;
}

@end

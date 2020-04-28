//
//  QYCustomTicketMessage.m
//  YSFDemo
//
//  Created by liaosipei on 2019/11/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "QYCustomTicketMessage.h"
#import "NSDictionary+QYJson.h"
#import "NSString+QY.h"
#import "QYMacro.h"

@implementation QYCustomTicketMessage

- (NSString *)thumbText {
    return @"[自定义消息]";
}

- (QYCustomMessageSourceType)messageSourceType {
    return QYCustomMessageSourceTypeNone;
}

+ (instancetype)objectByDict:(NSDictionary *)dict {
    QYCustomTicketMessage *message = [[QYCustomTicketMessage alloc] init];
    message.title = [dict qy_jsonString:@"title"];
    message.icon = [dict qy_jsonString:@"icon"];
    message.price = [dict qy_jsonString:@"price"];
    message.desc = [dict qy_jsonString:@"desc"];
    message.tagArray = [dict qy_jsonStringArray:@"tag"];
    message.buttonTitle = [dict qy_jsonString:@"buttonTitle"];
    message.buttonUrl = [dict qy_jsonString:@"buttonUrl"];
    return message;
}

- (NSDictionary *)encodeMessage {
    return @{
        @"title" : QYStrParam(self.title),
        @"title" : QYStrParam(self.icon),
        @"price" : QYStrParam(self.price),
        @"desc" : QYStrParam(self.desc),
        @"tag" : QYStrParam(self.tagArray),
        @"buttonTitle" : QYStrParam(self.buttonTitle),
        @"buttonUrl" : QYStrParam(self.buttonUrl),
    };
}

- (void)decodeMessage:(NSDictionary *)content {
    self.title = [content qy_jsonString:@"title"];
    self.icon = [content qy_jsonString:@"icon"];
    self.price = [content qy_jsonString:@"price"];
    self.desc = [content qy_jsonString:@"desc"];
    self.tagArray = [content qy_jsonStringArray:@"tag"];
    self.buttonTitle = [content qy_jsonString:@"buttonTitle"];
    self.buttonUrl = [content qy_jsonString:@"buttonUrl"];
}

@end

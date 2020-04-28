//
//  QYCustomTicketMessage.h
//  YSFDemo
//
//  Created by liaosipei on 2019/11/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <QYSDK/QYCustomMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYCustomTicketMessage : QYCustomMessage

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSArray *tagArray;
@property (nonatomic, copy) NSString *buttonTitle;
@property (nonatomic, copy) NSString *buttonUrl;

+ (instancetype)objectByDict:(NSDictionary *)dict;


@end

NS_ASSUME_NONNULL_END

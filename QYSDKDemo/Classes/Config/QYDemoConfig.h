//
//  YSFDemoConfig.h
//  YSFDemo
//
//  Created by amao on 9/1/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kQYInvalidAccountTitle = @"云信帐号未登录";
static NSString * const kQYInvalidAccountMessage = @"请在设置中登录\n成功后可使用七鱼客服功能";


@interface QYDemoConfig : NSObject

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, assign) BOOL isFusion;

+ (instancetype)sharedConfig;

@end

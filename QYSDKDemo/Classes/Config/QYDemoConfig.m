//
//  YSFDemoConfig.m
//  YSFDemo
//
//  Created by amao on 9/1/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "QYDemoConfig.h"
#import <QYSDK/QYSDK.h>

@interface QYDemoConfig ()
@end

@implementation QYDemoConfig
+ (instancetype)sharedConfig {
    static QYDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QYDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _appKey = @"3858be3c20ceb6298575736cf27858a7";
#ifdef DEBUG
        _appName = @"qiyudemo_enterprise_dev";
#else
        _appName = @"QYKF";
#endif
        _isFusion = NO;
    }
    return self;
}

- (void)setEnvironment:(NSInteger)isTest {
    [[QYSDK sharedSDK] performSelector:@selector(readEnvironmentConfig:useHttps:) withObject:@(isTest) withObject:@(YES)];
}

@end


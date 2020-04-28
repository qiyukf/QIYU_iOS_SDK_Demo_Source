//
//  QYSettingData.m
//  QYDemo
//
//  Created by liaosipei on 2020/3/10.
//  Copyright © 2020 Netease. All rights reserved.
//

#import "QYSettingData.h"
#import "QYDemoConfig.h"

@implementation QYSettingData

+ (instancetype)sharedData {
    static QYSettingData *settingData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settingData = [[QYSettingData alloc] init];
    });
    return settingData;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isDefault = YES;
        _isPushMode = YES;
        
        _source = nil;
        
        _groupId = 0;
        _staffId = 0;
        _robotId = 0;
        _questionTemplateId = 0;
        _vipLevel = 0;
        _robotWelcomeTemplateId = 0;
        _openRobotInShuntMode = NO;
        
        _authToken = nil;
        
        _quickButtonArray = [NSMutableArray array];
        _hoverViewHeight = 0;
        _customEvaluation = NO;
        _hideHistoryMsg = NO;
        _historyMsgTip = nil;
        _pullRoamMessage = [QYDemoConfig sharedConfig].isFusion;
    }
    return self;
}

- (void)resetEntranceParameter {
    _groupId = 0;
    _staffId = 0;
    _robotId = 0;
    _questionTemplateId = 0;
    _vipLevel = 0;
    _robotWelcomeTemplateId = 0;
    _openRobotInShuntMode = NO;
}

@end

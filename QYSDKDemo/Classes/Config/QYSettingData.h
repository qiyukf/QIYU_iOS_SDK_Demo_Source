//
//  QYSettingData.h
//  QYDemo
//
//  Created by liaosipei on 2020/3/10.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QYSDK/QYSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYSettingData : NSObject

@property (nonatomic, assign) BOOL isDefault;       //是否为默认配置
@property (nonatomic, assign) BOOL isPushMode;      //界面是否push进入，否则present

@property (nonatomic, strong) QYSource *source;     //会话来源信息
@property (nonatomic, assign) int64_t groupId;      //客服组ID
@property (nonatomic, assign) int64_t staffId;      //客服ID
@property (nonatomic, assign) int64_t robotId;      //机器人ID
@property (nonatomic, assign) int64_t questionTemplateId;   //机器人常见问题模板ID
@property (nonatomic, assign) NSInteger vipLevel;           //客服VIP等级
@property (nonatomic, assign) int64_t robotWelcomeTemplateId;   //机器人欢迎语模板ID
@property (nonatomic, assign) BOOL openRobotInShuntMode;        //访客分流是否开启机器人

@property (nonatomic, copy) NSString *authToken;    //authToken验证

@property (nonatomic, strong) NSMutableArray *quickButtonArray; //人工快捷入口按钮组
@property (nonatomic, assign) CGFloat hoverViewHeight;      //顶部悬停视图高度
@property (nonatomic, assign) BOOL customEvaluation;        //是否自定义评价界面
@property (nonatomic, assign) BOOL hideHistoryMsg;          //是否收起历史消息
@property (nonatomic, copy) NSString *historyMsgTip;        //历史消息分隔文案
@property (nonatomic, assign) BOOL pullRoamMessage;         //是否拉取漫游消息

+ (instancetype)sharedData;

/**
 * 重置部分入口参数：
 * groupId/staffId/robotId/questionTemplateId/vipLevel/robotWelcomeTemplateId/openRobotInShuntMode
 */
- (void)resetEntranceParameter;

@end

NS_ASSUME_NONNULL_END

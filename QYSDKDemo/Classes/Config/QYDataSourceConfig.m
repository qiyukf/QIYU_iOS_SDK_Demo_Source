//
//  QYDataSourceConfig.m
//  YSFDemo
//
//  Created by liaosipei on 2019/3/20.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "QYDataSourceConfig.h"
#import "YSFCommonTableData.h"
#import "QYDemoConfig.h"
#import "QYAppKeyConfig.h"
#import "QYMacro.h"

#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYSDK.h>


@implementation QYDataSourceConfig

+ (instancetype)sharedConfig {
    static QYDataSourceConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QYDataSourceConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self makeSettingData];
        [self makeAppKeyData];
        [self makeUIData];
    }
    return self;
}

- (void)makeSettingData {
    NSString *appkey = [QYDemoConfig sharedConfig].appKey;
    NSString *bindAppkey;
    NSString *bindAppkeyDetail = @"";
    if (!appkey) {
        bindAppkey = @"绑定appkey";
    } else {
        bindAppkey = [QYDemoConfig sharedConfig].isFusion ? @"已绑定AppKey（融合）" : @"已绑定AppKey";
        bindAppkeyDetail = [@"AppKey: " stringByAppendingString:appkey];
    }
    
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    NSString *badgeValue = @"";
    if (count > 0) {
        badgeValue = (count > 99) ? @"99+" : [NSString stringWithFormat:@"%ld",(long)count];
    }
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:@{
        YSFHeaderTitle : @"",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : bindAppkey,
                    YSFDetailTitle : bindAppkeyDetail,
                    YSFType : @(QYSettingTypeAppKey),
                    YSFRowHeight : @(50),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"用户信息",
                    YSFType : @(QYSettingTypeUserInfo),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"私有化配置",
                    YSFType : @(QYSettingTypePrivatization),
                },
        ],
        YSFFooterTitle : @"",
    }];
    if ([QYDemoConfig sharedConfig].isFusion) {
        NSString *accInfo = @"";
        NSString *accTitle = @"登录云信帐号";
        NSDictionary *logoutDict = nil;
        if ([[NIMSDK sharedSDK] loginManager].isLogined) {
            accInfo = [NSString stringWithFormat:@"已登录帐号：%@", QYStrParam([[NIMSDK sharedSDK] loginManager].currentAccount)];
            accTitle = @"切换云信帐号";
            logoutDict = @{
                YSFStyle : @(YSFCommonCellStyleButton),
                YSFTitle : @"注销云信帐号",
                YSFType : @(QYSettingTypeAccountLogout),
            };
        }
        NSMutableArray *accArray = [NSMutableArray array];
        [accArray addObject:@{
            YSFStyle : @(YSFCommonCellStyleButton),
            YSFTitle : accTitle,
            YSFType : @(QYSettingTypeAccountLogin),
        }];
        if (logoutDict) {
            [accArray addObject:logoutDict];
        }
        
        [data addObject:@{
            YSFHeaderTitle : @"",
            YSFRowContent : accArray,
            YSFFooterTitle : accInfo,
        }];
    }
    [data addObject:@{
        YSFHeaderTitle : @"",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"联系客服",
                    YSFType : @(QYSettingTypeChat),
                    YSFBadge : badgeValue,
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"专属客服",
                    YSFType : @(QYSettingTypeUniqueStaff),
                    YSFBadge : badgeValue,
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"会话列表",
                    YSFType : @(QYSettingTypeSessionList),
                },
        ],
        YSFFooterTitle : @"",
    }];
    NSString *openRobotStr = [QYSettingData sharedData].openRobotInShuntMode ? @"开启机器人" : @"不开启机器人";
    NSString *sourceStr = @"";
    if ([QYSettingData sharedData].source) {
        sourceStr = [NSString stringWithFormat:@"标题:%@ 链接:%@ 自定义:%@", QYStrParam([QYSettingData sharedData].source.title), QYStrParam([QYSettingData sharedData].source.urlString), QYStrParam([QYSettingData sharedData].source.customInfo)];
    }
    [data addObject:@{
        YSFHeaderTitle : @"",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"会话来源",
                    YSFType : @(QYSettingTypeSource),
                    YSFResult : sourceStr,
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"客服分组ID",
                    YSFType : @(QYSettingTypeGroupId),
                    YSFResult : (([QYSettingData sharedData].groupId > 0) ? [NSString stringWithFormat:@"%lld/%@", [QYSettingData sharedData].groupId, openRobotStr] : @""),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"客服ID",
                    YSFType : @(QYSettingTypeStaffId),
                    YSFResult : (([QYSettingData sharedData].staffId > 0) ? [NSString stringWithFormat:@"%lld/%@", [QYSettingData sharedData].staffId, openRobotStr] : @""),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"机器人ID",
                    YSFType : @(QYSettingTypeRobotId),
                    YSFResult : (([QYSettingData sharedData].robotId > 0) ? [NSString stringWithFormat:@"%lld", [QYSettingData sharedData].robotId] : @""),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"常见问题模板ID",
                    YSFType : @(QYSettingTypeCommonQuestionTemplateId),
                    YSFResult : (([QYSettingData sharedData].questionTemplateId > 0) ? [NSString stringWithFormat:@"%lld", [QYSettingData sharedData].questionTemplateId] : @""),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"机器人欢迎语模板ID",
                    YSFType : @(QYSettingTypeRobotWelcomeTemplateId),
                    YSFResult : (([QYSettingData sharedData].robotWelcomeTemplateId > 0) ? [NSString stringWithFormat:@"%lld", [QYSettingData sharedData].robotWelcomeTemplateId] : @""),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"VIP等级",
                    YSFType : @(QYSettingTypeVIPLevel),
                    YSFResult : (([QYSettingData sharedData].vipLevel > 0) ? [NSString stringWithFormat:@"%ld", (long)[QYSettingData sharedData].vipLevel] : @""),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"AuthToken验证",
                    YSFType : @(QYSettingTypeAuthToken),
                    YSFResult : QYStrParam([QYSettingData sharedData].authToken),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"测试功能",
                    YSFType : @(QYSettingTypeTestEntry),
                },
        ],
        YSFFooterTitle : @"",
    }];
    NSString *buttonStr = @"";
    if ([QYSettingData sharedData].quickButtonArray.count) {
        for (NSInteger i = 0; i < [QYSettingData sharedData].quickButtonArray.count; i++) {
            QYButtonInfo *buttonInfo = [[QYSettingData sharedData].quickButtonArray objectAtIndex:i];
            if (i > 0) {
                buttonStr = [buttonStr stringByAppendingString:@"/"];
            }
            buttonStr = [buttonStr stringByAppendingString:QYStrParam(buttonInfo.title)];
        }
    }
    [data addObject:@{
        YSFHeaderTitle : @"",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"自定义聊天样式",
                    YSFType : @(QYSettingTypeCustomStyle),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"自定义+按钮",
                    YSFType : @(QYSettingTypeAddMoreButton),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"自定义人工快捷入口",
                    YSFType : @(QYSettingTypeAddButton),
                    YSFResult : QYStrParam(buttonStr),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"自定义顶部视图",
                    YSFType : @(QYSettingTypeAddTopHoverView),
                    YSFSwitchOn : @([QYSettingData sharedData].hoverViewHeight > 0),
                    YSFDetailTitle : (([QYSettingData sharedData].hoverViewHeight > 0) ? [NSString stringWithFormat:@"%0.2f", [QYSettingData sharedData].hoverViewHeight] : @""),
                    YSFRowHeight : @(50),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"自定义评价界面",
                    YSFType : @(QYSettingTypeAddEvaluationView),
                    YSFSwitchOn : @([QYSettingData sharedData].customEvaluation),
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"收起历史消息",
                    YSFType : @(QYSettingTypeHideHistoryMessage),
                    YSFSwitchOn : @([QYSettingData sharedData].hideHistoryMsg),
                    YSFDetailTitle : (([QYSettingData sharedData].hideHistoryMsg) ? QYStrParam([QYSettingData sharedData].historyMsgTip) : @""),
                    YSFRowHeight : @(50),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"拉取漫游消息",
                    YSFType : @(QYSettingTypePullRoamMessage),
                    YSFSwitchOn : @([QYSettingData sharedData].pullRoamMessage),
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"清空未读数",
                    YSFType : @(QYSettingTypeClearUnreadCount),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"清理接收文件",
                    YSFType : @(QYSettingTypeCleanCache),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"清理帐号信息",
                    YSFType : @(QYSettingTypeCleanAccountInfo),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"查看log",
                    YSFType : @(QYSettingTypeLog),
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleButton),
                    YSFTitle : @"关于",
                    YSFType : @(QYSettingTypeAbout),
                },
        ],
        YSFFooterTitle : @"注：部分功能配置仅对 设置-联系客服 入口有效",
    }];
    self.settingDataSource = [YSFCommonTableSection sectionsWithData:data];
}

- (void)makeAppKeyData {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:@{
        YSFHeaderTitle : @"",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"扫一扫绑定",
                    YSFDetailTitle : @"AppKey二维码位于“管理后台-设置-App接入”",
                    YSFType : @(QYAppKeyTypeQRScan),
                    YSFRowHeight : @(50),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleIndicator),
                    YSFTitle : @"输入AppKey绑定",
                    YSFType : @(QYAppKeyTypeInput),
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"请在绑定AppKey前设置是否为融合SDK",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"融合SDK",
                    YSFType : @(QYAppKeyTypeFusion),
                    YSFSwitchOn : @([QYDemoConfig sharedConfig].isFusion),
                },
        ],
        YSFFooterTitle : @"修改此配置项，仅在绑定AppKey并重启后生效",
    }];
    self.appKeyDataSource = [YSFCommonTableSection sectionsWithData:data];
}

- (void)makeUIData {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:@{
        YSFHeaderTitle : @"注：SDK支持所有图片素材替换，为保证效果，应放置同等尺寸的图片",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleButton),
                    YSFTitle : @"恢复默认设置",
                    YSFType : @(QYCustomStyleTypeRestoreDefault),
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"集成方式设置",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"集成方式（push/present）",
                    YSFType : @(QYCustomStyleTypePushMode),
                    YSFSwitchOn : @(YES),
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"聊天背景设置",
        YSFRowContent : @[
                @{
                    YSFTitle : @"聊天背景图片",
                    YSFType : @(QYCustomStyleTypeSessionBackground),
                    YSFResult : @"无",
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"主题色设置",
        YSFRowContent : @[
                @{
                    YSFTitle : @"主题色",
                    YSFType : @(QYCustomStyleTypeThemeColor),
                    YSFResult : @"蓝色",
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"导航栏相关设置（人工/评价按钮可后台关闭显示）",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"按钮风格（灰/白）",
                    YSFType : @(QYCustomStyleTypeRightItemStyle),
                    YSFSwitchOn : @(YES),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"退出会话按钮",
                    YSFType : @(QYCustomStyleTypeCloseSessionEntrance),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"显示消息流头像",
                    YSFType : @(QYCustomStyleTypeShowHeadImage),
                    YSFSwitchOn : @(YES),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"显示导航栏头像",
                    YSFType : @(QYCustomStyleTypeShowTopHeadImage),
                    YSFSwitchOn : @(NO),
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"访客相关设置",
        YSFRowContent : @[
                @{
                    YSFTitle : @"访客头像",
                    YSFType : @(QYCustomStyleTypeCustomerHeadImage),
                    YSFResult : @"默认",
                },
                @{
                    YSFTitle : @"访客消息气泡",
                    YSFType : @(QYCustomStyleTypeCustomerMsgBubble),
                    YSFResult : @"气泡1",
                },
                @{
                    YSFTitle : @"访客消息字体颜色",
                    YSFType : @(QYCustomStyleTypeCustomerMsgTextColor),
                    YSFResult : @"白色",
                },
                @{
                    YSFTitle : @"访客消息链接字体颜色",
                    YSFType : @(QYCustomStyleTypeCustomerMsgLinkColor),
                    YSFResult : @"白色",
                },
                @{
                    YSFTitle : @"访客消息字体大小",
                    YSFType : @(QYCustomStyleTypeCustomerMsgTextSize),
                    YSFResult : @"16.00",
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"客服相关设置",
        YSFRowContent : @[
                @{
                    YSFTitle : @"客服头像",
                    YSFType : @(QYCustomStyleTypeServiceHeadImage),
                    YSFResult : @"默认",
                },
                @{
                    YSFTitle : @"客服消息气泡",
                    YSFType : @(QYCustomStyleTypeServiceMsgBubble),
                    YSFResult : @"气泡1",
                },
                @{
                    YSFTitle : @"客服消息字体颜色",
                    YSFType : @(QYCustomStyleTypeServiceMsgTextColor),
                    YSFResult : @"黑色",
                },
                @{
                    YSFTitle : @"客服消息链接字体颜色",
                    YSFType : @(QYCustomStyleTypeServiceMsgLinkColor),
                    YSFResult : @"蓝色",
                },
                @{
                    YSFTitle : @"客服消息字体大小",
                    YSFType : @(QYCustomStyleTypeServiceMsgTextSize),
                    YSFResult : @"16.00",
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"提示消息相关设置（例：***为你服务）",
        YSFRowContent : @[
                @{
                    YSFTitle : @"提示消息字体颜色",
                    YSFType : @(QYCustomStyleTypeTipMsgTextColor),
                    YSFResult : @"灰色",
                },
                @{
                    YSFTitle : @"提示消息字体大小",
                    YSFType : @(QYCustomStyleTypeTipMsgTextSize),
                    YSFResult : @"12.00",
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"消息相关设置",
        YSFRowContent : @[
                @{
                    YSFTitle : @"消息下拉刷新loading动效",
                    YSFType : @(QYCustomStyleTypeMessagesLoadingStyle),
                    YSFResult : @"系统样式",
                },
                @{
                    YSFTitle : @"访客分流展示样式",
                    YSFType : @(QYCustomStyleTypeBypassDisplayMode),
                    YSFResult : @"底部",
                },
                @{
                    YSFTitle : @"消息竖直方向间距",
                    YSFType : @(QYCustomStyleTypeMsgVerticalSpacing),
                    YSFResult : @"0.00",
                },
                @{
                    YSFTitle : @"头像与消息气泡水平间距",
                    YSFType : @(QYCustomStyleTypeHeadMsgHorizontalSpacing),
                    YSFResult : @"5.00",
                },
                @{
                    YSFTitle : @"消息内强提示按钮文字颜色",
                    YSFType : @(QYCustomStyleTypeMessageButtonTextColor),
                    YSFResult : @"白色",
                },
                @{
                    YSFTitle : @"消息内强提示按钮底色",
                    YSFType : @(QYCustomStyleTypeMessageButtonBorderColor),
                    YSFResult : @"蓝色",
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"输入栏上方操作按钮设置",
        YSFRowContent : @[
                @{
                    YSFTitle : @"按钮文字颜色",
                    YSFType : @(QYCustomStyleTypeActionBarTextColor),
                    YSFResult : @"蓝色",
                },
                @{
                    YSFTitle : @"按钮边框颜色",
                    YSFType : @(QYCustomStyleTypeActionBarBorderColor),
                    YSFResult : @"蓝色",
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"输入栏设置",
        YSFRowContent : @[
                @{
                    YSFTitle : @"输入框字体颜色",
                    YSFType : @(QYCustomStyleTypeInputTextColor),
                    YSFResult : @"黑色",
                },
                @{
                    YSFTitle : @"输入框字体大小",
                    YSFType : @(QYCustomStyleTypeInputTextSize),
                    YSFResult : @"14.00",
                },
                @{
                    YSFTitle : @"输入框占位文案",
                    YSFType : @(QYCustomStyleTypeInputTextPlaceholder),
                    YSFResult : @"请输入您要咨询的问题",
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"人工模式下显示语音按钮",
                    YSFType : @(QYCustomStyleTypeAudioEntrance),
                    YSFSwitchOn : @(YES),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"机器人模式下显示语音按钮",
                    YSFType : @(QYCustomStyleTypeAudioEntranceInRobotMode),
                    YSFSwitchOn : @(YES),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"显示表情按钮",
                    YSFType : @(QYCustomStyleTypeEmoticonEntrance),
                    YSFSwitchOn : @(YES),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"显示照相机按钮",
                    YSFType : @(QYCustomStyleTypeCameraEntrance),
                    YSFSwitchOn : @(YES),
                },
                @{
                    YSFTitle : @"图片/视频选择页面主题色",
                    YSFType : @(QYCustomStyleTypeImagePickerColor),
                    YSFResult : @"蓝色",
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"自动调起键盘",
                    YSFType : @(QYCustomStyleTypeAutoShowKeyboard),
                    YSFSwitchOn : @(YES),
                },
                @{
                    YSFTitle : @"底部间距",
                    YSFType : @(QYCustomStyleTypeBottomMargin),
                    YSFResult : @"0.00",
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"平台电商相关设置",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"商铺入口",
                    YSFType : @(QYCustomStyleTypeShopEntrance),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"会话列表入口",
                    YSFType : @(QYCustomStyleTypeSessionListEntrance),
                },
                @{
                    YSFTitle : @"会话列表入口图片",
                    YSFType : @(QYCustomStyleTypeSessionListEntranceImage),
                    YSFResult : @"默认",
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"会话列表入口位置（右上角/左上角）",
                    YSFType : @(QYCustomStyleTypeSessionListEntrancePosition),
                    YSFSwitchOn : @(YES),
                },
        ],
        YSFFooterTitle : @"",
    }];
    self.uiDataSource = [YSFCommonTableSection sectionsWithData:data];
}

- (void)restoreUIToDefault {
    [self makeUIData];
}

- (void)reloadSettingDataSource {
    [self makeSettingData];
}

- (NSString *)configFilepath {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [dir stringByAppendingPathComponent:@"qy_appkey.plist"];
}

@end

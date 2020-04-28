//
//  QYDataSourceConfig.h
//  YSFDemo
//
//  Created by liaosipei on 2019/3/20.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYSettingData.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QYSettingType) {
    QYSettingTypeNone = 0,
    QYSettingTypeUserInfo,
    QYSettingTypeAppKey,
    QYSettingTypePrivatization,
    
    QYSettingTypeAccountLogin,
    QYSettingTypeAccountLogout,
    
    QYSettingTypeChat,
    QYSettingTypeUniqueStaff,
    QYSettingTypeSessionList,
    
    QYSettingTypeSource,
    QYSettingTypeGroupId,
    QYSettingTypeStaffId,
    QYSettingTypeRobotId,
    QYSettingTypeCommonQuestionTemplateId,
    QYSettingTypeRobotWelcomeTemplateId,
    QYSettingTypeVIPLevel,
    QYSettingTypeAuthToken,
    QYSettingTypeClearUnreadCount,
    QYSettingTypeCleanCache,
    QYSettingTypeCleanAccountInfo,
    QYSettingTypeTestEntry,
    
    QYSettingTypeCustomStyle,
    QYSettingTypeHideHistoryMessage,
    QYSettingTypePullRoamMessage,
    QYSettingTypeAddButton,
    QYSettingTypeAddTopHoverView,
    QYSettingTypeAddMoreButton,
    QYSettingTypeAddEvaluationView,
    
    QYSettingTypeLog,
    QYSettingTypeAbout,
};

typedef NS_ENUM(NSInteger, QYAppKeyType) {
    QYAppKeyTypeNone = 0,
    QYAppKeyTypeQRScan,
    QYAppKeyTypeInput,
    QYAppKeyTypeFusion,
};

typedef NS_ENUM(NSInteger, QYCustomStyleType) {
    QYCustomStyleTypeNone = 0,
    QYCustomStyleTypeRestoreDefault,
    QYCustomStyleTypePushMode,
    QYCustomStyleTypeSessionBackground,
    QYCustomStyleTypeThemeColor,
    QYCustomStyleTypeRightItemStyle,
    QYCustomStyleTypeCloseSessionEntrance,
    QYCustomStyleTypeShowHeadImage,
    QYCustomStyleTypeShowTopHeadImage,
    QYCustomStyleTypeCustomerHeadImage,
    QYCustomStyleTypeCustomerMsgBubble,
    QYCustomStyleTypeCustomerMsgTextColor,
    QYCustomStyleTypeCustomerMsgLinkColor,
    QYCustomStyleTypeCustomerMsgTextSize,
    QYCustomStyleTypeServiceHeadImage,
    QYCustomStyleTypeServiceMsgBubble,
    QYCustomStyleTypeServiceMsgTextColor,
    QYCustomStyleTypeServiceMsgLinkColor,
    QYCustomStyleTypeServiceMsgTextSize,
    QYCustomStyleTypeTipMsgTextColor,
    QYCustomStyleTypeTipMsgTextSize,
    
    QYCustomStyleTypeMessagesLoadingStyle,
    QYCustomStyleTypeBypassDisplayMode,
    QYCustomStyleTypeMsgVerticalSpacing,
    QYCustomStyleTypeHeadMsgHorizontalSpacing,
    QYCustomStyleTypeMessageButtonTextColor,
    QYCustomStyleTypeMessageButtonBorderColor,
    QYCustomStyleTypeActionBarTextColor,
    QYCustomStyleTypeActionBarBorderColor,
    QYCustomStyleTypeInputTextColor,
    QYCustomStyleTypeInputTextSize,
    QYCustomStyleTypeInputTextPlaceholder,
    QYCustomStyleTypeAudioEntrance,
    QYCustomStyleTypeAudioEntranceInRobotMode,
    QYCustomStyleTypeEmoticonEntrance,
    QYCustomStyleTypeCameraEntrance,
    QYCustomStyleTypeImagePickerColor,
    QYCustomStyleTypeAutoShowKeyboard,
    QYCustomStyleTypeBottomMargin,
    
    QYCustomStyleTypeShopEntrance,
    QYCustomStyleTypeSessionListEntrance,
    QYCustomStyleTypeSessionListEntranceImage,
    QYCustomStyleTypeSessionListEntrancePosition,
    
    QYCustomStyleTypeSessionTipColor,
    QYCustomStyleTypeSessionTipTextColor,
    QYCustomStyleTypeSessionTipTextSize,
};


@interface QYDataSourceConfig : NSObject

@property (nonatomic, strong) NSArray *settingDataSource;
@property (nonatomic, strong) NSArray *appKeyDataSource;
@property (nonatomic, strong) NSArray *uiDataSource;

+ (instancetype)sharedConfig;

- (void)restoreUIToDefault;
- (void)reloadSettingDataSource;


@end

NS_ASSUME_NONNULL_END

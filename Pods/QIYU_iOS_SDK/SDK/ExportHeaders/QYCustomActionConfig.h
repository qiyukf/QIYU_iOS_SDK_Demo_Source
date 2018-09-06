//
//  QYCustomActionConfig.h
//  QYSDK
//
//  Created by towik on 7/28/16.
//  Copyright (c) 2017 Netease. All rights reserved.
//

@class QYSelectedCommodityInfo;

/**
 *  退出排队结果类型
 */
typedef NS_ENUM(NSInteger, QuitWaitingType) {
    QuitWaitingTypeNone,     //当前不是在排队状态
    QuitWaitingTypeContinue, //继续排队
    QuitWaitingTypeQuit,     //退出排队
    QuitWaitingTypeCancel,   //取消操作
};

/**
 *  请求客服场景
 */
typedef NS_ENUM(NSInteger, QYRequestStaffScene) {
    QYRequestStaffSceneNone,               //无需关心的请求客服场景
    QYRequestStaffSceneInit,               //进入会话页面，初次请求客服
    QYRequestStaffSceneRobotUnable,        //机器人模式下告知无法解答，点击按钮请求人工客服
    QYRequestStaffSceneNavHumanButton,     //机器人模式下，点击右上角人工按钮
    QYRequestStaffSceneActiveRequest,      //主动请求人工客服
};

/**
 *  提供了所有自定义行为的接口;每个接口对应一个自定义行为的处理，如果设置了，则使用设置的处理，如果不设置，则采用默认处理
 */
typedef void (^QYLinkClickBlock)(NSString *linkAddress);

/**
 *  bot点击事件回调
 */
typedef void (^QYBotClickBlock)(NSString *target, NSString *params);

/**
 *  退出排队回调
 */
typedef void (^QYQuitWaitingBlock)(QuitWaitingType quitType);

/**
 *  显示bot自定义信息回调
 */
typedef void (^QYShowBotCustomInfoBlock)(NSArray *array);

/**
 *  bot商品卡片按钮点击事件回调
 */
typedef void (^QYSelectedCommodityActionBlock)(QYSelectedCommodityInfo *commodityInfo);

/**
 *  请求客服-回传结果
 */
typedef void (^QYRequestStaffCompletion)(BOOL needed);

/**
 *  请求客服前回调
 *
 *  @param scene 请求客服场景
 *  @param completion 处理完成后的回调，若需继续请求客服，则调用completion(YES)；若需停止请求，调用completion(NO)
 */
typedef void (^QYRequestStaffBlock)(QYRequestStaffScene scene, QYRequestStaffCompletion completion);

/**
 *  自定义行为配置类
 */
@interface QYCustomActionConfig : NSObject

+ (instancetype)sharedInstance;

/**
 *  所有消息中的链接（自定义商品消息、文本消息、机器人答案消息）的回调处理
 */
@property (nonatomic, copy) QYLinkClickBlock linkClickBlock;

/**
 *  bot相关点击
 */
@property (nonatomic, copy) QYBotClickBlock botClick;

/**
 *  设置录制或者播放语音完成以后是否自动deactivate AVAudioSession
 *
 *  @param deactivate 是否deactivate，默认为YES
 */
- (void)setDeactivateAudioSessionAfterComplete:(BOOL)deactivate;

/**
 *  显示退出排队提示
 *
 *  @param quitWaitingBlock 选择结果回调
 */
- (void)showQuitWaiting:(QYQuitWaitingBlock)quitWaitingBlock;


/**
 *  推送消息相关点击
 */
@property (nonatomic, copy) QYLinkClickBlock pushMessageClick;

/**
 *  显示bot自定义信息
 */
@property (nonatomic, copy) QYShowBotCustomInfoBlock showBotCustomInfoBlock;

/**
 *  bot商品卡片按钮点击事件
 */
@property (nonatomic, copy) QYSelectedCommodityActionBlock commodityActionBlock;

/**
 *  请求客服前调用
 */
@property (nonatomic, copy) QYRequestStaffBlock requestStaffBlock;

@end




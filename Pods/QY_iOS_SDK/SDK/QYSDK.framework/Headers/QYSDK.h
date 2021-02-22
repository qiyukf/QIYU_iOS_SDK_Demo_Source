//
//  QYSDK.h
//  QYSDK
//
//  version 5.16.0
//
//  Created by Netease on 12/21/15.
//  Copyright (c) 2017 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYHeaders.h"


@protocol NIMCustomAttachmentCoding;

/**
 *  完成回调
 */
typedef void(^QYCompletionBlock)(BOOL success);

/**
 *  完成回调，带错误参数
 */
typedef void(^QYResultCompletionBlock)(BOOL success, NSError *error);

/**
 *  完成结果回调
 */
typedef void(^QYCompletionWithResultBlock)(BOOL isSuccess);

/**
 *  推送消息回调
 */
typedef void(^QYPushMessageBlock)(QYPushMessage *pushMessage);

/**
 *  清理缓存回调
 */
typedef void(^QYCleanCacheCompletion)(NSError *error);

/**
 *  错误码
 */
typedef NS_ENUM(NSInteger, QYLocalErrorCode) {
    QYLocalErrorCodeUnknown         = 0,    //未知错误
    QYLocalErrorCodeInvalidParam    = 1,    //错误参数
    QYLocalErrorCodeFusionNeeded    = 2,    //必须为融合SDK
    QYLocalErrorCodeAccountNeeded   = 3,    //帐号错误-底层通信IM帐号未登录
    QYLocalErrorCodeInvalidUserId   = 4,    //userId错误，应与帐号相同
    QYLocalErrorCodeNeedLogout      = 5,    //userId变化，应走帐号切换逻辑，先调用logout
};

/**
 *  语言
 */
typedef NS_ENUM(NSInteger, QYLanguage) {
    QYLanguageChineseSimplified     = 0,    //简体中文
    QYLanguageChineseTraditional    = 1,    //繁体中文
    QYLanguageEnglish               = 2,    //英语
};


/**
 *  QYSDK：单例模式
 */
@interface QYSDK : NSObject

/**
 *  获取SDK单例
 *
 *  @return SDK单例
 */
+ (instancetype)sharedSDK;

/**
 *  获取七鱼SDK版本号
 *
 *  @return 七鱼SDK版本号
 */
- (NSString *)sdkVersion;

/**
 *  获取融合SDK版本号
 *
 *  @return 融合SDK版本号
 */
- (NSString *)fusionSdkVersion;

/**
 * 当前服务器配置
 * @discussion 私有化需进行自定义配置；必须在注册SDK前配置
 */
@property (nonatomic, strong) QYServerSetting *serverSetting;

/**
 * 语言设置，默认简体中文
 * @discussion 目前仅支持简体中文、繁体中文、英语
 * @discussion 因部分设置项文案需在App启动时刻配置，故修改语言后会影响此部分配置项自定义，即可能会恢复默认设置；因此推荐调用顺序为SDK注册后，即刻设置语言，之后再配置一些自定义属性
 */
@property (nonatomic, assign) QYLanguage language;

/**
 * 是否跟随系统语言自动变化，默认YES
 * @discussion 开启时设置language无效，仅跟随系统变化
 */
@property (nonatomic, assign) BOOL followSystemLanguage;

/**
 *  注册SDK
 *
 *  @param appKey 对应管理后台分配的appkey
 *  @param appName 对应管理后台添加一个App时填写的App名称 (就是SDK1.0.0版本的cerName,参数名变动)
 *  @discussion 如果需要更多注册选项，推荐使用 registerWithOption:
 */
- (void)registerAppId:(NSString *)appKey appName:(NSString *)appName;

/**
 *  注册SDK
 *
 *  @param option 注册选项
 */
- (void)registerWithOption:(QYSDKOption *)option;

/**
 *  获取AppKey
 *
 *  @return 返回当前注册的AppKey
 */
- (NSString *)appKey;

/**
 *  获取客服聊天ViewController，非单例，每次调用新建会话页面
 *
 *  @return 会话ViewController
 *  @discussion 为保证功能完整性，必须嵌入至UINavigationController中使用；保证全局仅有一个VC实例，退出后可正常释放
 */
- (QYSessionViewController *)sessionViewController;

/**
 *  获取自定义UI配置单例，可设置界面内的UI展示效果
 *
 *  @return 自定义UI配置单例
 */
- (QYCustomUIConfig *)customUIConfig;

/**
 *  获取自定义事件配置单例，可设置事件处理
 *
 *  @return 自定义事件配置单例
 */
- (QYCustomActionConfig *)customActionConfig;

/**
 *  返回会话管理类
 *
 *  @return 会话管理类
 */
- (QYConversationManager *)conversationManager;

/**
 *  获取当前设置的用户信息ID
 *
 *  @return 返回当前已设置的用户信息ID
 */
- (NSString *)currentUserID;

/**
 *  获取当前登录的底层IM通信帐号ID，可据此判断当前是否已登录IM帐号
 *
 *  @return 返回当前登录的accountID
 *  @discussion 此帐号与外部设置的userId不同，是底层长连接通信帐号，七鱼内部会自动创建并登录；与外部传入的userId形成映射关系
 */
- (NSString *)currentIMAccountID;

/**
 *  设置用户信息，App帐号登录成功后上传
 *
 *  @param userInfo 用户信息
 *  @discussion 此方法尽量在App帐号登录成功后调用，不应仅在进入客服界面时调用；否则可能会造成客服连接状态不稳定
 *  @discussion 若设置的userId与上次设置不同，即需要实现帐号切换，应先调用logout还原为匿名帐号再进行设置
 */
- (void)setUserInfo:(QYUserInfo *)userInfo;

/**
 *  设置用户信息，App帐号登录成功后上传，带结果回调
 *
 *  @param userInfo 用户信息
 *  @param userInfoBlock userInfo上报结果回调
 *  @discussion 此方法尽量在App帐号登录成功后调用，不应仅在进入客服界面时调用；否则可能会造成客服连接状态不稳定
 *  @discussion 若设置的userId与上次设置不同，即需要实现帐号切换，应先调用logout还原为匿名帐号再进行设置
 */
- (void)setUserInfo:(QYUserInfo *)userInfo userInfoResultBlock:(QYResultCompletionBlock)userInfoBlock;

/**
 *  注销当前帐号，App帐号注销时调用
 *
 *  @param completion 完成回调
 *  @discussion 切换帐号包含注销和登录过程，在注销阶段也要调用此函数
 */
- (void)logout:(QYCompletionBlock)completion;

/**
 *  设置待校验的authToken
 */
- (void)setAuthToken:(NSString *)authToken;

/**
 *  设置用户信息，App帐号登录成功后上传，带authToken校验
 *
 *  @param userInfo 用户信息
 *  @param block authToken校验结果回调
 */
- (void)setUserInfo:(QYUserInfo *)userInfo authTokenVerificationResultBlock:(QYCompletionWithResultBlock)block;

/**
 *  设置用户信息，App帐号登录成功后上传，带authToken校验，带结果回调
 *
 *  @param userInfo 用户信息
 *  @param userInfoBlock userInfo上报结果回调
 *  @param authTokenBlock authToken校验结果回调
 *  @discussion 此方法尽量在App帐号登录成功后调用，不应仅在进入客服界面时调用；否则可能会造成客服连接状态不稳定
 *  @discussion 若设置的userId与上次设置不同，即需要实现帐号切换，应先调用logout还原为匿名帐号再进行设置
 */
- (void)setUserInfo:(QYUserInfo *)userInfo userInfoResultBlock:(QYResultCompletionBlock)userInfoBlock authTokenResultBlock:(QYCompletionBlock)authTokenBlock;

/**
 *  访问轨迹
 *  @param title 标题
 *  @param enterOrOut 进入还是退出
 */
- (void)trackHistory:(NSString *)title enterOrOut:(BOOL)enterOrOut key:(NSString *)key;

/**
 *  行为轨迹
 *  @param title 标题
 *  @param description 具体信息，以key-value表示信息对，例如key为“商品价格”，value为“999”
 */
- (void)trackHistory:(NSString *)title description:(NSDictionary *)description key:(NSString *)key;

/**
 *  更新推送token
 *
 *  @param token 推送token
 *  @discussion 传入DeviceToken原始数据，NSData类型
 */
- (void)updateApnsToken:(NSData *)token;

/**
 *  获取七鱼推送消息，非APNs推送
 *
 *  @param messageId 消息id
 */
- (void)getPushMessage:(NSString *)messageId;

/**
 *  注册七鱼推送消息通知回调
 *
 *  @param block 收到消息的回调
 */
- (void)registerPushMessageNotification:(QYPushMessageBlock)block;

/**
 *  获取七鱼日志文件路径
 *
 *  @return 日志文件路径
 */
- (NSString *)qiyuLogPath;

/**
 *  清理接收文件缓存
 *  @param completion 清理缓存完成回调
 */
- (void)cleanResourceCacheWithBlock:(QYCleanCacheCompletion)completion;

/**
 *  清理帐号信息
 *  @param cleanAll 是否清理当前所有帐号信息，NO表示清理历史无用帐号，YES表示清理全部
 *  @param completion 清理缓存完成回调
 *  @discussion 清理全部帐号信息会登出当前帐号，并新建匿名帐号，请在调用完成后使用setUserInfo:接口恢复为有名帐号；请在合理时机调用本接口
 */
- (void)cleanAccountInfoForAll:(BOOL)cleanAll completion:(QYCleanCacheCompletion)completion;


#pragma mark - Fusion

/**
 *  设置用户信息，带authToken校验，仅融合SDK使用
 *
 *  @param userInfo 用户信息，注意userId应与当前登录的云信帐号相同，否则userInfoBlock返回error
 *  @param userInfoBlock userInfo上报结果回调
 *  @param authTokenBlock authToken校验结果回调
 *  @discussion App帐号登录成功后，调用此函数上报。若非融合SDK调用，则userInfoBlock返回error
 */
- (void)setUserInfoForFusion:(QYUserInfo *)userInfo
         userInfoResultBlock:(QYResultCompletionBlock)userInfoBlock
        authTokenResultBlock:(QYCompletionBlock)authTokenBlock;

/**
 *  注册云信自定义消息解析器，仅融合SDK使用
 *
 *  @param decoder 自定义消息解析器
 *  @discussion 若使用自定义消息类型，需注册自定义消息解析器，将透传过来的消息反序列化成上层应用可识别的对象
 *  @discussion 使用融合SDK时，若需解析自定义消息，请使用该接口设置；若仍使用云信提供接口，则会覆盖七鱼解析器造成部分客服消息无法解析
 */
- (void)registerCustomDecoderForFusion:(id<NIMCustomAttachmentCoding>)decoder;


#pragma mark - Deprecated
///**
// *  已废弃
// *  追踪用户浏览信息;暂时客服端还没有入口可以查看这部分信息
// *  @param urlString  浏览url
// *  @param attributes 附加信息
// */
//- (void)trackHistory:(NSString *)urlString withAttributes:(NSDictionary *)attributes;

///**
// *  已废弃，使用setUserInfo替代
// *  设置userInfo.userId即可，userInfo.data忽略
// *  添加个人信息
// *
// *  @param infos 个人信息；目前有两个key，“foreignid”表示用户id，“name”表示用户名
// */
//- (void)addUserInfo:(NSDictionary *)infos;


@end

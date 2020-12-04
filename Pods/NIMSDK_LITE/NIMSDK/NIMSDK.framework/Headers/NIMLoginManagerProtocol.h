//
//  NIMLoginManagerProtocol.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMLoginClient.h"

#ifndef NIMDeprecated
#define NIMDeprecated(msg) __attribute__((deprecated(msg)))
#endif

@class NIMLoginKickoutResult;

NS_ASSUME_NONNULL_BEGIN
/**
 *  登录服务相关Block
 *
 *  @param error 执行结果,如果成功error为nil
 */
typedef void(^NIMLoginHandler)(NSError * __nullable error);

/**
 *  查询服务端时间Block
 *
 *  @param error 执行结果,如果成功error为nil
 */
typedef void(^NIMLoginGetServerTimeHandle)(NSError * __nullable error, NIMServerTime *time);

/**
 *  登录步骤枚举
 */
typedef NS_ENUM(NSInteger, NIMLoginStep)
{
    /**
     *  连接服务器
     */
    NIMLoginStepLinking = 1,
    /**
     *  连接服务器成功
     */
    NIMLoginStepLinkOK,
    /**
     *  连接服务器失败
     */
    NIMLoginStepLinkFailed,
    /**
     *  登录
     */
    NIMLoginStepLogining,
    /**
     *  登录成功
     */
    NIMLoginStepLoginOK,
    /**
     *  登录失败
     */
    NIMLoginStepLoginFailed,
    /**
     *  开始同步
     */
    NIMLoginStepSyncing,
    /**
     *  同步完成
     */
    NIMLoginStepSyncOK,
    /**
     *  连接断开
     */
    NIMLoginStepLoseConnection,
    /**
     *  网络切换
     *  @discussion 这个并不是登录步骤的一种,但是UI有可能需要通过这个状态进行UI展现
     */
    NIMLoginStepNetChanged,
};

/**
 *  SDK 认证模式
 */
typedef NS_ENUM(NSInteger, NIMSDKAuthMode)
{
    /**
     *  未定义
     *  @discussion SDK 未调用任何登录接时或在 IM/聊天室 模式下调用 logout 接口后变化为未定义模式
     */
    NIMSDKAuthModeUndefined = 0,
    /**
     *  通过 IM 服务器鉴权
     *  @discussion 调用 NIMLoginManager login/autoLogin 接口进行登录即为 IM 鉴权模式
     */
    NIMSDKAuthModeIM,
    /**
     *  聊天室单独鉴权
     *  @discussion 调用 NIMChatroomManager 进入聊天室接口时设置 NIMChatroomIndependentMode 即为聊天室单独聊天鉴权模式
     */
    NIMSDKAuthModeChatroom,
};

/**
 *  被踢下线的原因
 */
typedef NS_ENUM(NSInteger, NIMKickReason)
{
    /**
     *  被另外一个客户端踢下线 (互斥客户端一端登录挤掉上一个登录中的客户端)
     */
    NIMKickReasonByClient = 1,
    /**
     *  被服务器踢下线
     */
    NIMKickReasonByServer = 2,
    /**
     *  被另外一个客户端手动选择踢下线
     */
    NIMKickReasonByClientManually   = 3,
};

/**
*  多端登陆的状态
*/
typedef NS_ENUM(NSInteger, NIMMultiLoginType){
    /**
     *  目前已经有其他端登陆
     */
    NIMMultiLoginTypeInit   =   1,
    /**
     *  其他端上线
     */
    NIMMultiLoginTypeLogin  =   2,
    /**
     *  其他端下线
     */
    NIMMultiLoginTypeLogout =   3,
};

/**
 *  登录相关回调
 */
@protocol NIMLoginManagerDelegate <NSObject>

@optional
/**
 *  被踢(服务器/其他端)回调
 *
 * @deprecated 请使用- (void)onKickout:(NIMLoginKickoutResult *)result;
 *
 *  @param code        被踢原因
 *  @param clientType  发起踢出的客户端类型
 */
- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType NIMDeprecated("Use -onKickout: instead");

/**
 *  被踢(服务器/其他端)回调
*
 *  @param result        被踢原因
 */
- (void)onKickout:(NIMLoginKickoutResult *)result;

/**
 *  登录回调
 *
 *  @param step 登录步骤
 *  @discussion 这个回调主要用于客户端UI的刷新
 */
- (void)onLogin:(NIMLoginStep)step;

/**
 *  自动登录失败回调
 *
 *  @param error 失败原因
 *  @discussion 自动重连不需要上层开发关心，但是如果发生一些需要上层开发处理的错误，SDK 会通过这个方法回调
 *              用户需要处理的情况包括：AppKey 未被设置，参数错误，密码错误，多端登录冲突，账号被封禁，操作过于频繁等
 */
- (void)onAutoLoginFailed:(NSError *)error;

/**
 *  多端登录发生变化
 */
- (void)onMultiLoginClientsChanged;

/**
*  多端登录发生变化
*/
- (void)onMultiLoginClientsChangedWithType:(NIMMultiLoginType)type;

/**
 *  群用户同步完成通知
 *  @param success 群用户信息同步是否成功
 */
- (void)onTeamUsersSyncFinished:(BOOL)success;

/**
 *  超大群用户同步完成通知
 *  @param success 群用户信息同步是否成功
 */
- (void)onSuperTeamUsersSyncFinished:(BOOL)success;

@end

/**
 *  登录协议
 */
@protocol NIMLoginManager <NSObject>

/**
 *  登录
 *
 *  @param account    帐号
 *  @param token      令牌 (在后台绑定的登录token)
 *  @param completion 完成回调
 */
- (void)login:(NSString *)account
        token:(NSString *)token
   completion:(NIMLoginHandler)completion;


/**
 *  自动登录
 *
 *  @param account    帐号
 *  @param token      令牌 (在后台绑定的登录token)
 *  @discussion 启动APP如果已经保存了用户帐号和令牌,建议使用这个登录方式,使用这种方式可以在无网络时直接打开会话窗口
 */
- (void)autoLogin:(NSString *)account
            token:(NSString *)token; 


/**
 *  自动登录
 *
 *  @param loginData 自动登录参数
 *  @discussion 启动APP如果已经保存了用户帐号和令牌,建议使用这个登录方式,使用这种方式可以在无网络时直接打开会话窗口
 */
- (void)autoLogin:(NIMAutoLoginData *)loginData;

/**
 *  登出
 *
 *  @param completion 完成回调
 *  @discussion 用户在登出是需要调用这个接口进行 SDK 相关数据的清理,回调 Block 中的 error 只是指明和服务器的交互流程中可能出现的错误,但不影响后续的流程。
 *              如用户登出时发生网络错误导致服务器没有收到登出请求，客户端仍可以登出(切换界面，清理数据等)，但会出现推送信息仍旧会发到当前手机的问题。
 */
- (void)logout:(nullable NIMLoginHandler)completion;

/**
 *  踢人
 *
 *  @param client     当前登录的其他客户端
 *  @param completion 完成回调
 */
- (void)kickOtherClient:(NIMLoginClient *)client
             completion:(nullable NIMLoginHandler)completion;

/**
 *  返回当前登录帐号
 *
 *  @return 当前登录帐号,如果没有登录成功,这个地方会返回空字符串""
 */
- (NSString *)currentAccount;

/**
 *  当前登录状态
 *
 *  @return 当前登录状态
 */
- (BOOL)isLogined;

/**
 *  当前 SDK 鉴权模式
 *
 *  @return 当前 SDK 鉴权模式
 */
- (NIMSDKAuthMode)currentAuthMode;

/**
 *  返回当前登录的设备列表
 *
 *  @return 当前登录设备列表 内部是NIMLoginClient,不包括自己
 */
- (nullable NSArray<NIMLoginClient *> *)currentLoginClients;

/**
 * 查询服务器时间
 *
 * @param completion 完成回调
 * @discussion 该接口有调用频控，当调用失败时默认返回上一次的时间
 */
- (void)queryServerTimeCompletion:(NIMLoginGetServerTimeHandle)completion;

/**
 *  添加登录委托
 *
 *  @param delegate 登录委托
 */
- (void)addDelegate:(id<NIMLoginManagerDelegate>)delegate;

/**
 *  移除登录委托
 *
 *  @param delegate 登录委托
 */
- (void)removeDelegate:(id<NIMLoginManagerDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END

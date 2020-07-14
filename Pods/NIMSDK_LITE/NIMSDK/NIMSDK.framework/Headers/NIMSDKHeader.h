//
//  NIMSDKHeaders.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NIMSDKOption;
@class NIMServerSetting;

/**
 *  压缩日志回调
 *
 *  @param error 执行结果,如果成功 error 为 nil
 *  @param path  压缩包的路径，只有当执行成功才有值，否则为 nil
 */
typedef void(^NIMArchiveLogsHandler)(NSError *error, NSString *path);

typedef void(^NIMUploadLogsHandler)(NSError *error, NSString *path);


/**
 *  NIMSDK
 */
@interface NIMSDK : NSObject
/**
 *  获取SDK实例
 *
 *  @return NIMSDK实例
 */
+ (instancetype)sharedSDK;

/**
 *  获取SDK版本号
 *
 *  @return SDK版本号
 */
- (NSString *)sdkVersion;

/**
 *  初始化SDK
 *
 *  @param appKey  申请的appKey
 *  @param cerName  推送证书名
 *  @discussion 如果需要更多注册选项，推荐使用 registerWithOption:
 */
- (void)registerWithAppID:(NSString *)appKey
                  cerName:(nullable NSString *)cerName;


/**
 *  初始化SDK
 *
 *  @param option  注册选项
 */
- (void)registerWithOption:(NIMSDKOption *)option;

/**
 *  获取AppKey
 *
 *  @return 返回当前注册的AppKey
 */
- (nullable NSString *)appKey;


/**
 *  是否正在使用Demo AppKey
 *
 *  @return 返回是否正在使用Demo AppKey
 */
- (BOOL)isUsingDemoAppKey;

/**
 *  更新APNS Token
 *
 *  @param token APNS Token
 *  @return 格式化后的APNS Token
 */
- (NSString *)updateApnsToken:(NSData *)token;

/**
 *  更新APNS Token
 *
 *  @param token APNS Token
 *  @param key 自定义本端推送内容, 设置key可对应业务服务器自定义推送文案; 传@"" 清空配置, nil 则不更改
 *  @return 格式化后的APNS Token
 */
- (NSString *)updateApnsToken:(NSData *)token
       customContentKey:(nullable NSString *)key;

/**
 *  更新 PushKit Token
 *
 *  @param token PushKit token
 *  @discussion 目前仅支持 PKPushTypeVoIP
 */
- (void)updatePushKitToken:(NSData *)token;


/**
 *  获得SDK Log路径
 *
 *  @return SDK当天log路径
 *  @discussion 这个接口会返回当前最新的一个 log 文件路径,SDK 会每天生成一个 log 文件方便开发者定位和反馈问题
 */
- (NSString *)currentLogFilepath;


/**
 *  打包当前的日志集合
 *
 *  @param completion 打包后的压缩包路径
 *  @discussion 这个接口会压缩当前所有的日志为 Zip 文件，并输出 Zip 路径，上层可以根据这个文件进行上传反馈
 */
- (void)archiveLogs:(NIMArchiveLogsHandler)completion;

/**
 *  打包并上传当前的日志集合
 *
 *  @param completion 打包后的压缩包路径
 *
 *  @discussion 这个接口会压缩当前所有的日志为 Zip 文件，并输出 Zip 路径，上层可以根据这个文件进行上传反馈
 */
- (void)uploadLogs:(NIMUploadLogsHandler _Nullable)completion;

/**
 *  打包并上传当前的日志集合
 *
 *  @param attach     附言，可为空
 *  @param roomId     聊天室ID，可为空
 *  @param completion 打包后的压缩包路径
 *
 *  @discussion 这个接口会压缩当前所有的日志为 Zip 文件，并输出 Zip 路径，上层可以根据这个文件进行上传反馈
 */
- (void)uploadLogsWithAttach:(nullable NSString *)attach
                      roomId:(nullable NSString *)roomId
                  completion:(NIMUploadLogsHandler _Nullable)completion;


/**
 *  开启控制台Log
 */
- (void)enableConsoleLog;

/**
 *  当前服务器配置
 *  @discussion 私有化需要进行自定义设置，必须在注册 appkey 完成之前设置
 */
@property (nonatomic,strong)           NIMServerSetting    *serverSetting;

/**
 *  资源场景配置
 *  @discussion nos 预设场景和自定义场景规则
 *  可以覆盖设置，如果预设场景不设置，为系统默认设置
 *  sceneDict key-value，系统默认预设场景为3种，自定义场景不超过10种
 *  key 是场景，nsstring类型；value 是资源存活时间，nsnumber类型，精确到天，0为永久存活
 *  例如：@{@"nim_icon":@0,@"nim_msg":@0,@"nim_system":@0,@"nim_custom":@30}
 */
@property (nonatomic,strong)         NSMutableDictionary *sceneDict;

/**
 *  登录管理类 负责登录,注销和相关操作的通知收发
 */
@property (nonatomic,strong,readonly)   id<NIMLoginManager>   loginManager;

/**
 *  聊天管理类,负责消息的收发
 */
@property (nonatomic,strong,readonly)   id<NIMChatManager>     chatManager;

/**
 *  会话管理类,负责消息,最近会话的读写和管理
 */
@property (nonatomic,strong,readonly)   id<NIMConversationManager>  conversationManager;

/**
 *  媒体管理类,负责多媒体相关的接口 (录音等)
 */
@property (nonatomic,strong,readonly)   id<NIMMediaManager>    mediaManager;

/**
 *  群组管理类,负责群组的操作:创建,拉人,踢人,同步等
 */
@property (nonatomic,strong,readonly)   id<NIMTeamManager>    teamManager;

/**
 *  超大群，负责超大群的相关操作
 */
@property (nonatomic,strong,readonly) id<NIMSuperTeamManager> superTeamManager;

/**
 *  好友管理类
 */
@property (nonatomic,strong,readonly)   id<NIMUserManager>      userManager;

/**
 *  系统通知管理类
 */
@property (nonatomic,strong,readonly)   id<NIMSystemNotificationManager>    systemNotificationManager;

/**
 *  APNS推送管理类
 */
@property (nonatomic,strong,readonly)   id<NIMApnsManager> apnsManager;

/**
 *  资源管理器,负责文件上传和下载
 */
@property (nonatomic,strong,readonly)   id<NIMResourceManager> resourceManager;

/**
 *  聊天室管理类
 */
@property (nonatomic,strong,readonly)   id<NIMChatroomManager> chatroomManager;

/**
 *  文档转码管理类
 */
@property (nonatomic,strong,readonly)   id<NIMDocTranscodingManager> docTranscodingManager;

/**
 *  事件订阅管理类
 */
@property (nonatomic,strong,readonly)   id<NIMEventSubscribeManager> subscribeManager;

/**
 *  智能机器人管理类
 */
@property (nonatomic,strong,readonly)   id<NIMRobotManager> robotManager;

/**
 *  红包管理类
 */
@property (nonatomic,strong,readonly)   id<NIMRedPacketManager> redPacketManager;

/**
 *  广播消息管理类
 */
@property (nonatomic,strong,readonly)   id<NIMBroadcastManager> broadcastManager;

/**
 *  反垃圾管理类
 */
@property (nonatomic,strong,readonly)   id<NIMAntispamManager> antispamManager;

/**
 *  通用音视频信令管理类
 */
@property (nonatomic,strong,readonly)   id<NIMSignalManager> signalManager;

/**
 *   透传代理管理类
 */
@property (nonatomic,strong,readonly)   id<NIMPassThroughManager> passThroughManager;


/**
 *   Thread Talk管理类
 */
@property (nonatomic,strong,readonly)   id<NIMChatExtendManager> chatExtendManager;

@end

NS_ASSUME_NONNULL_END

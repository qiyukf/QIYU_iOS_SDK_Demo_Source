//
//  QYSDKOption.h
//  QYBiz
//
//  Created by Netease on 2020/2/17.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 注册选项
 */
@interface QYSDKOption : NSObject

/**
 * AppKey
 */
@property (nonatomic, copy) NSString *appKey;

/**
 * App名称，即七鱼管理后台添加App时填写的App名称；对应云信的Apns推送证书名apnsCername
 */
@property (nullable, nonatomic, copy) NSString *appName;

/**
 * PushKit推送证书名；对应云信的pkCername
 */
@property (nullable, nonatomic, copy) NSString *pkCerName;

/**
 * 是否为融合SDK，默认NO；需同时使用NIMSDK和QYSDK的客户应配置为YES
 */
@property (nonatomic, assign) BOOL isFusion;

/**
 *  注册选项初始化方法
 *  @param appKey  企业AppKey
 */
+ (instancetype)optionWithAppKey:(NSString *)appKey;

@end

NS_ASSUME_NONNULL_END

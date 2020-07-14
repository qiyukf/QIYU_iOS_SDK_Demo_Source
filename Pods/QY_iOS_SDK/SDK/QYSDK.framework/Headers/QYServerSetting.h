//
//  QYServerSetting.h
//  QYSDK
//
//  Created by Netease on 2020/3/3.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYServerSetting : NSObject

/**
 * 七鱼服务器地址
 * @discussion 设置为nil或空串时恢复默认配置
 */
@property (nonatomic, copy) NSString *serverAddress;

/**
 * 轨迹上报服务器地址
 * @discussion 设置为nil或空串时恢复默认配置
 */
@property (nonatomic, copy) NSString *trackAddress;

@end

NS_ASSUME_NONNULL_END

//
//  QYUserInfo.h
//  QYSDK
//
//  Created by Netease on 1/11/16.
//  Copyright (c) 2017 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  个人信息
 */
@interface QYUserInfo : NSObject

/**
 *  个人帐号Id
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  用户详细信息json数据
 */
@property (nonatomic, copy) NSString *data;

@end

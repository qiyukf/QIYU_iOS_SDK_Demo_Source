//
//  QYSource.h
//  QYSDK
//
//  Created by Netease on 12/21/15.
//  Copyright (c) 2017 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  会话来源信息
 */
@interface QYSource : NSObject

/**
 *  来源标题
 *  @discussion title可对应管理后台“App核心页面列表”中“页面名称”（v5.10.0）
 */
@property (nonatomic, copy) NSString *title;

/**
 *  来源链接
 *  @discussion urlString可对应管理后台“App核心页面列表”中“页面链接”（v5.10.0）
 *  @discussion 此处不做链接相关校验，可传任意字符串
 */
@property (nonatomic, copy) NSString *urlString;

/**
 *  来源自定义信息
 */
@property (nonatomic, copy) NSString *customInfo;

@end

//
//  QYCommodityInfo.h
//  QYSDK
//
//  Created by Netease on 16/5/26.
//  Copyright (c) 2017 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  QYCommodityTag：自定义商品信息卡片按钮信息
 */
@interface QYCommodityTag : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *focusIframe;
@property (nonatomic, copy) NSString *data;

@end


/**
 *  商品信息类：QYCommodityInfo
 */
@interface QYCommodityInfo : NSObject

/**
 *  商品图片链接，字符数要求小于1000
 */
@property (nonatomic, copy) NSString *pictureUrlString;

/**
 *  商品标题，字符数要求小于100
 */
@property (nonatomic, copy) NSString *title;

/**
 *  商品描述，字符数要求小于300
 */
@property (nonatomic, copy) NSString *desc;

/**
 *  备注信息，可以显示价格，订单号等，字符数要求小于100
 */
@property (nonatomic, copy) NSString *note;

/**
 *  跳转url，字符数要求小于1000
 */
@property (nonatomic, copy) NSString *urlString;

/**
 *  标签数据，数组类型
 */
@property (nonatomic, copy) NSArray<QYCommodityTag *> *tagsArray;

/**
 *  标签数据，字符串类型，与数组类型二选一
 */
@property (nonatomic, copy) NSString *tagsString;

/**
 *  发送时是否在访客端隐藏，默认隐藏
 */
@property (nonatomic, assign) BOOL show;

/**
 *  是否仅显示商品图片，默认否 (V5.5.0, 为避免歧义由isCustom修改为isPictureLink)
 */
@property (nonatomic, assign) BOOL isPictureLink;

/**
 *  是否由访客主动发送，默认否；设置为YES，消息下方新增发送按钮 (v4.4.0)
 */
@property (nonatomic, assign) BOOL sendByUser;

/**
 *  发送按钮文案 (v4.4.0)
 */
@property (nonatomic, copy) NSString *actionText;

/**
 *  发送按钮文案颜色 (v4.4.0)
 */
@property (nonatomic, strong) UIColor *actionTextColor;

/**
 *  一般用户不需要填这个字段，这个字段仅供特定用户使用
 */
@property (nonatomic, copy) NSString *ext;

@end


/**
 *  自定义商品信息类：QYSelectedCommodityInfo，用于机器人模式下发送商品/订单等场景
 */
@interface QYSelectedCommodityInfo : NSObject

@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSString *params;
@property (nonatomic, copy) NSString *p_status;
@property (nonatomic, copy) NSString *p_img;
@property (nonatomic, copy) NSString *p_name;
@property (nonatomic, copy) NSString *p_price;
@property (nonatomic, copy) NSString *p_count;
@property (nonatomic, copy) NSString *p_stock;
@property (nonatomic, copy) NSString *p_action;
@property (nonatomic, copy) NSString *p_url;
@property (nonatomic, copy) NSString *p_userData;

@end

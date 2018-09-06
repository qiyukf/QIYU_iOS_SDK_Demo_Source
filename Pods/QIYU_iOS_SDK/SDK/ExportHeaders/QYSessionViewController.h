//
//  QYSessionViewController.h
//  QYSDK
//
//  Created by towik on 12/21/15.
//  Copyright (c) 2017 Netease. All rights reserved.
//
#import <UIKit/UIKit.h>

@class QYSource;
@class QYCommodityInfo;

/**
 *  右上角入口以及聊天内容区域的按钮 点击以后的回调
 */
@protocol QYSessionViewDelegate <NSObject>

/**
 *  点击右上角（对于平台电商来说，这里可以考虑放“商铺入口”）按钮回调
 */
- (void)onTapShopEntrance;

/**
 *  点击聊天内容区域的按钮（对于平台电商来说，这里可以考虑放置“会话列表入口“）回调
 */
- (void)onTapSessionListEntrance;

@end


@interface QYSelectedCommodityInfo : NSObject

@property (nonatomic,copy)    NSString *target;
@property (nonatomic,copy)    NSString *params;
@property (nonatomic,copy)    NSString *p_status;
@property (nonatomic,copy)    NSString *p_img;
@property (nonatomic,copy)    NSString *p_name;
@property (nonatomic,copy)    NSString *p_price;
@property (nonatomic,copy)    NSString *p_count;
@property (nonatomic,copy)    NSString *p_stock;
@property (nonatomic,copy)    NSString *p_action;
@property (nonatomic,copy)    NSString *p_userData;

@end

/**
 *  输入区域上方工具栏内的按钮信息
 */
@interface QYButtonInfo : NSObject

@property (nonatomic,strong)    id      buttonId;
@property (nonatomic,copy)      NSString *title;
@property (nonatomic,strong)    id      userData;

@end


/**
 *  输入区域上方工具栏内的按钮点击回调
 */
typedef void (^QYButtonClickBlock)(QYButtonInfo *action);


/**
 *  客服会话ViewController,必须嵌入到UINavigationcontroller中
 */
@interface QYSessionViewController : UIViewController

/**
 *  会话窗口标题
 */
@property (nonatomic,copy)      NSString    *sessionTitle;

/**
 *  访客分流 分组Id
 */
@property (nonatomic,assign)    int64_t groupId;

/**
 *  访客分流 客服Id
 */
@property (nonatomic,assign)    int64_t staffId;

/**
 *  机器人Id
 */
@property (nonatomic,assign)    int64_t robotId;

/**
 *  vip等级
 */
@property (nonatomic,assign)    NSInteger   vipLevel;

/**
 *  访客分流 是否开启机器人
 */
@property (nonatomic,assign)    BOOL openRobotInShuntMode;

/**
 *  常见问题 模版Id
 */
@property (nonatomic,assign)    int64_t commonQuestionTemplateId;

/**
 *  会话窗口来源
 */
@property (nonatomic,strong)    QYSource   *source;

/**
 *  商品信息展示
 */
@property (nonatomic, strong) QYCommodityInfo *commodityInfo;

/**
 *  输入区域上方工具栏内的按钮信息
 */
@property (nonatomic, copy) NSArray<QYButtonInfo *> *buttonInfoArray;

/**
 *  输入区域上方工具栏内的按钮点击回调
 */
@property (nonatomic, copy) QYButtonClickBlock buttonClickBlock;

/**
 *  机器人自动发送商品信息功能
 */
@property (nonatomic,assign) BOOL autoSendInRobot;

/**
 *  发送商品信息展示
 */
- (void)sendCommodityInfo:(QYCommodityInfo *)commodityInfo;

/**
 *  发送订单列表中选中的商品信息
 */
- (void)sendSelectedCommodityInfo:(QYSelectedCommodityInfo *)commodityInfo;

/**
 *  发送图片
 */
- (void)sendPicture:(UIImage *)picture;

/**
 *  请求人工客服
 */
- (void)requestHumanStaff;

@end



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
@class QYStaffInfo;

/**
 *  QYSessionViewDelegate：右上角入口以及聊天内容区域按钮点击回调
 */
@protocol QYSessionViewDelegate <NSObject>

/**
 *  点击右上角按钮回调（对于平台电商来说，这里可以考虑放“商铺入口”）
 */
- (void)onTapShopEntrance;

/**
 *  点击聊天内容区域的按钮回调（对于平台电商来说，这里可以考虑放置“会话列表入口“）
 */
- (void)onTapSessionListEntrance;

@end


/**
 *  自定义商品信息类：QYSelectedCommodityInfo
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
@property (nonatomic, copy) NSString *p_userData;

@end


/**
 *  输入区域上方工具栏内按钮信息类：QYButtonInfo
 *  注: actionType及index为button点击事件传递信息，仅可读
 *  actionType为1表示发送文本消息title，2表示openURL或是自定义行为；index表示该button位置
 */
@interface QYButtonInfo : NSObject

@property (nonatomic, strong) id buttonId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) id userData;
@property (nonatomic, assign, readonly) NSUInteger actionType;
@property (nonatomic, assign, readonly) NSUInteger index;

@end

/**
 *  通用完成回调
 */
typedef void (^QYCompletion)(BOOL success, NSError *error);

/**
 *  工具栏内按钮点击回调定义
 */
typedef void (^QYButtonClickBlock)(QYButtonInfo *action);


/**
 *  会话类：QYSessionViewController
 *  客服会话ViewController,必须嵌入到UINavigationcontroller中
 */
@interface QYSessionViewController : UIViewController

/**
 *  会话窗口标题
 */
@property (nonatomic, copy) NSString *sessionTitle;

/**
 *  访客分流 分组Id
 */
@property (nonatomic, assign) int64_t groupId;

/**
 *  访客分流 客服Id
 */
@property (nonatomic, assign) int64_t staffId;

/**
 *  机器人Id
 */
@property (nonatomic, assign) int64_t robotId;

/**
 *  vip等级
 */
@property (nonatomic, assign) NSInteger vipLevel;

/**
 *  访客分流 是否开启机器人
 */
@property (nonatomic, assign) BOOL openRobotInShuntMode;

/**
 *  常见问题 模版Id
 */
@property (nonatomic, assign) int64_t commonQuestionTemplateId;

/**
 *  会话窗口来源
 */
@property (nonatomic, strong) QYSource *source;

/**
 *  商品信息展示
 */
@property (nonatomic, strong) QYCommodityInfo *commodityInfo;

/**
 *  人工客服信息
 */
@property (nonatomic, strong) QYStaffInfo *staffInfo;

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
@property (nonatomic, assign) BOOL autoSendInRobot;

/**
 *  请求人工客服
 */
- (void)requestHumanStaff;

/**
 *  切换人工客服
 *
 *  @param staffId 客服ID
 *  @param groupId 分组ID
 *  @param closetip 切换提示语
 *  @param closeCompletion 退出旧会话完成的回调
 *  @param requestCompletion 请求新会话完成的回调
 */
- (void)changeHumanStaffWithStaffId:(int64_t)staffId
                            groupId:(int64_t)groupId
                           closetip:(NSString *)closetip
                    closeCompletion:(QYCompletion)closeCompletion
                  requestCompletion:(QYCompletion)requestCompletion;

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

@end



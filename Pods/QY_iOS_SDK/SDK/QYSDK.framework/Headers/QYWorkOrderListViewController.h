//
//  YSFWorkOrderListViewController.h
//  QYBiz
//
//  Created by Netease on 2020/6/9.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  错误码
 */
typedef NS_ENUM(NSInteger, QYWorkOrderErrorCode) {
    QYWorkOrderErrorCodeUnknown         = 0,    //未知错误
    QYWorkOrderErrorCodeInvalidAccount  = 1,    //无效帐号，当前帐号未登录
    QYWorkOrderErrorCodeInvalidParam    = 2,    //错误参数，一般是templateIDList错误
};


@interface QYWorkOrderListViewController : UIViewController

/**
 * 校验结果
 * 使用方法：调用初始化方法创建VC后，需判断此项，若为nil说明参数无误可正常使用查询工单功能，可push/present进入VC
 * 常见错误code：
 * 1.QYWorkOrderErrorCodeInvalidAccount：当前访客帐号未登录，不可使用查询工单功能
 * 2.QYWorkOrderErrorCodeInvalidParam：templateIDList有误，必须是元素为NSNumber的数组
 */
@property (nonatomic, strong, readonly) NSError *verifyError;

/**
 * 初始化方法
 * @param templateIDList 查询工单限制条件：模板ID列表
 * @param canReminder 访客是否可催单
 * @param shopId 商户ID，若为非平台企业可不传，若为平台子商户则需传商户ID，主商户可不传
 */
- (instancetype)initWithTemplateIDList:(NSArray <NSNumber *> *)templateIDList
                           canReminder:(BOOL)canReminder
                                shopId:(NSString *)shopId;


@end


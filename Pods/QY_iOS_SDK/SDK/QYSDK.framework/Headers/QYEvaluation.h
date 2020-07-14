//
//  QYEvaluation.h
//  YSFSDK
//
//  Created by Netease on 2019/6/6.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  满意度评价模式
 */
typedef NS_ENUM(NSUInteger, QYEvaluationMode) {
    QYEvaluationModeTwoLevel = 2,       //模式一（二级满意度）：满意/不满意
    QYEvaluationModeThreeLevel = 3,     //模式二（三级满意度）：满意/一般/不满意
    QYEvaluationModeFourLevel = 4,      //模式三（四级满意度）：非常满意/满意/不满意/非常不满意
    QYEvaluationModeFiveLevel = 5,      //模式四（五级满意度）：非常满意/满意/一般/不满意/非常不满意
};

/**
 *  满意度评价选项
 */
typedef NS_ENUM(NSUInteger, QYEvaluationOption) {
    QYEvaluationOptionVerySatisfied = 1,   //非常满意
    QYEvaluationOptionSatisfied,           //满意
    QYEvaluationOptionOrdinary,            //一般
    QYEvaluationOptionDissatisfied,        //不满意
    QYEvaluationOptionVeryDissatisfied,    //非常不满意
};

/**
 *  满意度评价结果返回值
 */
typedef NS_ENUM(NSInteger, QYEvaluationState) {
    QYEvaluationStateSuccessFirst = 1,  //成功-首次评价
    QYEvaluationStateSuccessRevise,     //成功-修改评价
    QYEvaluationStateFailParamError,    //失败-发送参数错误
    QYEvaluationStateFailNetError,      //失败-网络错误
    QYEvaluationStateFailNetTimeout,    //失败-网络超时
    QYEvaluationStateFailTimeout,       //失败-评价超时
    QYEvaluationStateFailUnknown,       //失败-未知原因不可评价
};

/**
 *  满意度评价是否解决选择项
 */
typedef NS_ENUM(NSInteger, QYEvaluationResolveStatus) {
    QYEvaluationResolveStatusNone = 0,
    QYEvaluationResolveStatusResolved = 1,
    QYEvaluationResolveStatusUnsolved = 2,
};


/**
 *  满意度选项数据
 */
@interface QYEvaluationOptionData : NSObject

/**
 *  选项类型
 */
@property (nonatomic, assign) QYEvaluationOption option;

/**
 *  选项名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  选项分值
 */
@property (nonatomic, assign) NSInteger score;

/**
 *  标签
 */
@property (nonatomic, strong) NSArray <NSString *> *tagList;

/**
 *  标签是否必填
 */
@property (nonatomic, assign) BOOL tagRequired;

/**
 *  备注是否必填
 */
@property (nonatomic, assign) BOOL remarkRequired;

@end


/**
 *  满意度评价结果
 */
@interface QYEvaluactionResult : NSObject

/**
 *  评价会话ID，不可为空
 */
@property (nonatomic, assign) long long sessionId;

/**
 *  评价模式，透传 QYEvaluactionData.mode（提交机器人评价结果时此项必须）
 */
@property (nonatomic, assign) QYEvaluationMode mode;

/**
 *  选中的选项，不可为空
 */
@property (nonatomic, strong) QYEvaluationOptionData *selectOption;

/**
 *  选中的标签，若selectOption的tagRequired必填，则selectTags不可为空
 */
@property (nonatomic, strong) NSArray <NSString *> *selectTags;

/**
 *  评价备注，若selectOption的remarkRequired必填，则remarkString不可为空
 */
@property (nonatomic, copy) NSString *remarkString;

/**
 *  是否解决，若resolvedRequired必填，则resolveStatus不可为None
 */
@property (nonatomic, assign) QYEvaluationResolveStatus resolveStatus;

@end


/**
 *  满意度评价数据
 */
@interface QYEvaluactionData : NSObject

/**
 *  评价页面URL，对应“管理后台-评价样式-新页面”填写的字符串
 */
@property (nonatomic, copy) NSString *urlString;

/**
 *  评价会话ID，提交评价结果时需透传
 */
@property (nonatomic, assign) long long sessionId;

/**
 *  评价模式
 */
@property (nonatomic, assign) QYEvaluationMode mode;

/**
 *  选项数据
 */
@property (nonatomic, strong) NSArray <QYEvaluationOptionData *> *optionList;

/**
 *  是否向访客收集“您的问题是否解决”
 */
@property (nonatomic, assign) BOOL resolvedEnabled;

/**
 *  “您的问题是否解决”是否必填
 */
@property (nonatomic, assign) BOOL resolvedRequired;

/**
 *  上次评价结果
 */
@property (nonatomic, strong) QYEvaluactionResult *lastResult;

@end


//
//  QYEvaluationViewController.h
//  YSFDemo
//
//  Created by liaosipei on 2019/6/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QYSDK/QYEvaluation.h>

@class QYSessionViewController;

@interface QYEvaluationViewController : UIViewController

- (instancetype)initWithEvaluationData:(QYEvaluactionData *)evaluationData sessionVC:(QYSessionViewController *)sessionVC;

@end


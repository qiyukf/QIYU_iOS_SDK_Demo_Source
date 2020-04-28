//
//  QYEvaluationResolveView.h
//  YSFDemo
//
//  Created by liaosipei on 2019/7/19.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QYSDK/QYEvaluation.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat QYEvaluationResolveHeight = 28.0f;
static CGFloat QYEvaluationResolveButtonWidth = 60.0f;
static CGFloat QYEvaluationResolveSpace = 10.0f;


@protocol QYEvaluationResolveViewDelegate <NSObject>

- (void)didSelectResolveButton:(QYEvaluationResolveStatus)status;

@end

@interface QYEvaluationResolveView : UIView

@property (nonatomic, weak) id<QYEvaluationResolveViewDelegate> delegate;
@property (nonatomic, assign) QYEvaluationResolveStatus status;

@end

NS_ASSUME_NONNULL_END

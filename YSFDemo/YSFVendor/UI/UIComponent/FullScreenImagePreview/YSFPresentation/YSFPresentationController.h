//
//  YXPresentationController.h
//  yixin_iphone
//
//  Created by ght on 14-9-26.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSFPresentConfigDelegate <NSObject>

-(UIView*)animatedViewForPresentation;
-(UIView*)touchViewForPresentation;
@end


@interface YSFPresentationController : UIPresentationController
@property (nonatomic, weak) id<YSFPresentConfigDelegate> configDelegate;
@end


//动画
@interface YSFPresentAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL isPresentation;//true为出现动画，fasle为消失动画
@end
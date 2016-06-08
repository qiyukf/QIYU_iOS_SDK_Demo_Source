//
//  YXPresentTransitioningDelegate.h
//  yixin_iphone
//
//  Created by ght on 14-9-28.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSFPresentationController.h"

@interface YSFPresentTransitioningDelegate : NSObject<UIViewControllerTransitioningDelegate>
@property (nonatomic, weak) id<YSFPresentConfigDelegate> configDelegate;
@end

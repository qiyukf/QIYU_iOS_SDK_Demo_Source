//
//  YXPresentViewController.h
//  yixin_iphone
//
//  Created by amao on 3/7/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSFPresentViewController : UIViewController
@property (nonatomic,assign)    BOOL isAnimating;
@property (nonatomic,weak)      UIWindow *attachedWindow;
- (void)present:(UIViewController *)presentingViewController touchView:(UIView *)touchView;
- (void)present:(UIViewController *)presentingViewController touchView:(UIView *)touchView
      completed:(void(^)(void))completed;
- (void)dismiss: (BOOL)animated;

#pragma mark - 配置项
- (UIView *)animatedView;
- (UIColor *)bkColor;
- (UIView*) touchView;
@end



@interface YSFPresentManager : NSObject
+ (YSFPresentManager *)sharedManager;
- (void)dismiss: (BOOL)animated;
- (void)dismiss:(BOOL)animated completion: (void (^)(void))completionBlock;

- (UIView *)dismissFromPanGesture;
- (void)updateBackgroundViewFrame;
- (void)cancelDismissFromPanGesture;
- (void)dismissFromPanGestureToBack:(UIView *)animatedView;
- (void)setPresentViewBackgroundAlpha:(float)alpha;
@end
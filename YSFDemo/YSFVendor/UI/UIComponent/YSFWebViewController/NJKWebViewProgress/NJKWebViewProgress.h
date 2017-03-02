//
//  NJKWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const float YSF_NJKInitialProgressValue;
extern const float YSF_NJKInteractiveProgressValue;
extern const float YSF_NJKFinalProgressValue;

typedef void (^YSF_NJKWebViewProgressBlock)(float progress);
@protocol YSF_NJKWebViewProgressDelegate;
@interface YSF_NJKWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, weak) id<YSF_NJKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) YSF_NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol YSF_NJKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(YSF_NJKWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end


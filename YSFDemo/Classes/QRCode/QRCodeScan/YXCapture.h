//
//  YXCapture.h
//  ZXingObjC
//
//  Created by zdy on 14-1-22.
//  Copyright (c) 2014年 zxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class AVCaptureVideoPreviewLayer;
@class ZXResult;
@class YXCapture;

// 扫描delegate
@protocol YXCaptureDelegate <NSObject>

@required
- (void)captureCameraIsReady:(YXCapture *)capture;
- (void)captureResult:(YXCapture *)capture result:(id)result;

@end

@interface YXCapture : NSObject

@property (nonatomic, weak) id<YXCaptureDelegate> delegate;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;
@property (nonatomic, assign) CGRect cropRect;      // 设置扫描识别区域
@property (nonatomic, assign) CGSize scaleSize;     // 设置扫描识别区域所在的区域大小
@property (nonatomic, assign) BOOL   oneDMode;      // 是否是条形码
@property (nonatomic, assign) CGFloat scale;        // 扫描显示Layer缩放度

- (instancetype)initWithOneDMode:(BOOL)oneDMode;
// 开始扫描
- (void)start;

// 停止扫描，不会将layer移除
- (void)stop;
- (void)stopAsync;
@end

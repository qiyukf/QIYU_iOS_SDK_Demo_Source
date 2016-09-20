//
//  YXCapture.m
//  ZXingObjC
//
//  Created by zdy on 14-1-22.
//  Copyright (c) 2014年 zxing. All rights reserved.
//

#import "YXCapture.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import "ZXingObjc.h"

@interface YXCapture ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL cameraIsReady;
    CGRect cropRectForImage;
    dispatch_queue_t _captureOutputBufferQueue;
    AVCaptureDevice *_captureDevice;
    BOOL            _isRunning;
    BOOL            _isProcessing;
    NSInteger       _frameNum;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@end

@implementation YXCapture

- (void)dealloc
{
    if (_captureOutputBufferQueue)
    {
        dispatch_sync(_captureOutputBufferQueue, ^{
            for (AVCaptureOutput *output in [_captureSession outputs])
            {
                if ([output isKindOfClass:[AVCaptureVideoDataOutput class]])
                {
                    [(AVCaptureVideoDataOutput *)output setSampleBufferDelegate:nil
                                                                          queue:NULL];
                }
                if ([output isKindOfClass:[AVCaptureMetadataOutput class]])
                {
                    [(AVCaptureMetadataOutput *)output setMetadataObjectsDelegate:nil queue:NULL];
                }

            }
        });
    }

    self.captureSession = nil;
    [_captureDevice removeObserver:self forKeyPath:@"adjustingFocus"];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        cameraIsReady = NO;
        _isRunning = NO;
        [self resetConfig];
        cropRectForImage = CGRectZero;
        _captureOutputBufferQueue = dispatch_queue_create("yixin.qrcode.capture_queue", 0);
    }
    
    return self;
}

- (instancetype)initWithOneDMode:(BOOL)oneDMode
{
    if (self = [self init]) {
        _oneDMode = oneDMode;
        [self initCaptureSession];
    }
    return self;
}

- (void)setOutputAttributes:(AVCaptureVideoDataOutput *)output
{
//    http://stackoverflow.com/questions/7967937/avcapturevideodataoutput-and-setting-kcvpixelbufferwidthkey-kcvpixelbufferheig
//    当前只支持kCVPixelBufferPixelFormatTypeKey,kCVPixelBufferWidthKey和kCVPixelBufferHeightKey不支持
    NSDictionary *attributes = @{(NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
    [output setVideoSettings:attributes];
}

- (void)initCaptureSession
{
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    if ([captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure] &&
        [captureDevice lockForConfiguration:&error]) {
        [captureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        [captureDevice unlockForConfiguration];
    } else
    {
       //YXLogErr(@"captureDevice setExposureModeContinuousAutoExpose failed");
    }
//
    if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance] &&
        [captureDevice lockForConfiguration:&error]) {
        [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        [captureDevice unlockForConfiguration];
    } else
    {
        //YXLogErr(@"captureDevice setWhiteBalanceMode failed");
    }
//
    if ([captureDevice isFocusPointOfInterestSupported] &&
        [captureDevice lockForConfiguration:&error]) {
        [captureDevice setFocusPointOfInterest:CGPointMake(0.5, 0.5)];
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
        [captureDevice unlockForConfiguration];
    }
    
    [captureDevice addObserver:self forKeyPath:@"adjustingFocus" options:NSKeyValueObservingOptionNew context:nil];
    _captureDevice = captureDevice;
    
    // capture device inputx
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if ([self.captureSession canAddInput:deviceInput]) {
        [self.captureSession addInput:deviceInput];
    }
    
    // capture device video output
    if (!_oneDMode) {
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        if ([self.captureSession canAddOutput:output]) {
            [self.captureSession addOutput:output];
            [output setMetadataObjectsDelegate:self queue:_captureOutputBufferQueue];
            //奇怪的bug,暂时判断是否支持QRcode https://www.crashlytics.com/netease2345678/ios/apps/com.yixin.yixin/issues/53f847abe3de5099bab5baa2
            if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
                output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            } else
            {
                [output setMetadataObjectsDelegate:nil queue:NULL];
                [self.captureSession removeOutput:output];
                output = nil;
            }
        }
    }
    [self setDeviceOutput];

    // previewlayer
    self.captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)setDeviceOutput
{
    AVCaptureVideoDataOutput *deviceOutput = [[AVCaptureVideoDataOutput alloc] init]; 
    [deviceOutput setSampleBufferDelegate:self queue:_captureOutputBufferQueue];
    [deviceOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [self setOutputAttributes:deviceOutput];
    if ([self.captureSession canAddOutput:deviceOutput]) {
        [self.captureSession addOutput:deviceOutput];
    }
    
    _videoConnection = [deviceOutput connectionWithMediaType:AVMediaTypeVideo];
    [_videoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
}

#pragma mark - control capture
- (void)start
{
    if (_isRunning) {
        return;
    }
    _isRunning = YES;
    NSError *error = nil;
    //第一次初始化的时候使用auto focus，第一次对焦完成之后，使用continuous auto focus
    if ([_captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus] &&
        [_captureDevice lockForConfiguration:&error]) {
        [_captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        [_captureDevice unlockForConfiguration];
    } else
    {
      //YXLogErr(@"captureDevice setFoucsModeAutoFocus failed");
    }
    [self resetConfig];
    [self.captureSession startRunning];
}

- (void)stopAsync
{
    if (!_isRunning) {
        return;
    }
    _isRunning = NO;
    __weak typeof(self) wself;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [wself.captureSession stopRunning];
        [wself resetConfig];
    });
}

- (void)stop
{
    if (!_isRunning) {
        return;
    }
    _isRunning = NO;
    [self.captureSession stopRunning];
    [self resetConfig];
}

- (void)resetConfig
{
    _isProcessing = NO;
    _frameNum = 0;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (_isProcessing) {
        return;
    }
    
    NSString *stringValue = nil;
    for(AVMetadataObject *metadata in metadataObjects)
    {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode] && [metadata isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *metadataObject = (AVMetadataMachineReadableCodeObject*)metadata;
            stringValue = [metadataObject stringValue];
            break;
        }
    }
    
    if (stringValue && !_isProcessing) {
        _isProcessing = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate captureResult:self result:stringValue];
        });
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    @autoreleasepool {
        
        if (_isProcessing && connection != _videoConnection) {
            return;
        }
        // camera ready
        if (!cameraIsReady && self.delegate) {
            
            cameraIsReady = YES;
            
            // 计算cropRect 对应到videoFrame 中的裁剪区域
            CVImageBufferRef videoFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
        
            //得到的是图像帧size
            CGSize size = CVImageBufferGetDisplaySize(videoFrame);

            CGSize cropSize = self.scaleSize;
           
            cropRectForImage = CGRectMake((size.width - cropSize.width * 2)/2.0,
                                          (size.height - cropSize.height * 2)/2.0,
                                          cropSize.width * 2, cropSize.height * 2);
 
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate captureCameraIsReady:self];
            });
        }
        _frameNum ++;
        if (_frameNum < 3) {  //舍弃第一帧
            return;
        }
        // 有回调处理
        if (self.delegate) {
    
            CVImageBufferRef videoFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
 
            CGImageRef videoFrameImage = [ZXCGImageLuminanceSource createImageFromBuffer:videoFrame
                                                                                    left:cropRectForImage.origin.x
                                                                                     top:cropRectForImage.origin.y
                                                                                   width:cropRectForImage.size.width
                                                                                  height:cropRectForImage.size.height];
            
            // 必需旋转，否则条形码不能识别
            CGImageRef rotatedImage = videoFrameImage;
            if (_oneDMode) {
                 rotatedImage = [self createRotatedImage:videoFrameImage degrees:90];
                 CGImageRelease(videoFrameImage);
            }
            
            ZXCGImageLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:rotatedImage];
            CGImageRelease(rotatedImage);
            
            ZXHybridBinarizer *binarizer = [[ZXHybridBinarizer alloc] initWithSource:source];
            ZXBinaryBitmap* bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:binarizer];
            
            ZXMultiFormatReader* reader = [ZXMultiFormatReader reader];
            ZXDecodeHints* hints = [ZXDecodeHints hints];
            if (!_oneDMode) {
                [hints addPossibleFormat:kBarcodeFormatQRCode];  //二维码 － ZXQRCodeReader解析
            }
            
            NSError *error = nil;
            ZXResult *result = [reader decode:bitmap hints:hints error:&error];
            //YXLogPro(@"scan _frameNum=%d end, reuslt=%@",_frameNum,result);
            if (result && !_isProcessing) {
                _isProcessing = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate captureResult:self result:result];
                });
            }
        }
    }
}

- (CGImageRef)createRotatedImage:(CGImageRef)original degrees:(float)degrees CF_RETURNS_RETAINED {
    if (degrees == 0.0f) {
        CGImageRetain(original);
        return original;
    } else {
        double radians = degrees * M_PI / 180;
        
#if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
        radians = -1 * radians;
#endif
        
        size_t _width = CGImageGetWidth(original);
        size_t _height = CGImageGetHeight(original);
        
        CGRect imgRect = CGRectMake(0, 0, _width, _height);
        CGAffineTransform _transform = CGAffineTransformMakeRotation(radians);
        CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, _transform);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     rotatedRect.size.width,
                                                     rotatedRect.size.height,
                                                     CGImageGetBitsPerComponent(original),
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
        CGContextSetAllowsAntialiasing(context, FALSE);
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGColorSpaceRelease(colorSpace);
        
        CGContextTranslateCTM(context,
                              +(rotatedRect.size.width/2),
                              +(rotatedRect.size.height/2));
        CGContextRotateCTM(context, radians);
        
        CGContextDrawImage(context, CGRectMake(-imgRect.size.width/2,
                                               -imgRect.size.height/2,
                                               imgRect.size.width,
                                               imgRect.size.height),
                           original);
        
        CGImageRef rotatedImage = CGBitmapContextCreateImage(context);
        CFRelease(context);
        
        return rotatedImage;
    }
}

#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _captureDevice &&
        [keyPath isEqualToString:@"adjustingFocus"] &&
        _captureDevice.focusMode == AVCaptureFocusModeAutoFocus) {
        if (!_captureDevice.adjustingFocus) { //对焦完成,将对焦模式切换为连续自动对焦
            NSError *error = nil;
            if ([_captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] &&
                [_captureDevice lockForConfiguration:&error]) {
                [_captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [_captureDevice unlockForConfiguration];
            }
        }
    }
}

@end

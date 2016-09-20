//
//  QRcodeScanController.m
//  Barcodes
//
//  Created by Pan Fengfeng on 13-4-2.
//
//

#import "QRcodeScanController.h"
#import "YXCapture.h"
#import "AVFoundation/AVFoundation.h"
#import "ZXingObjC.h"
#import "UIView+YSFToast.h"
#import "UIAlertView+YSF.h"
#import "UIView+YSF.h"
#include "UIView+Animation.h"


#define kNetworkTipView     10010

@interface QRcodeScanController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,YXCaptureDelegate> {

}

@property (nonatomic, strong) YXCapture* capture;

// 测试使用
@property (nonatomic, strong) UIImageView *resultView;
@property (nonatomic, strong) UIImageView *captureLayer;

@end

@implementation QRcodeScanController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initCapture];
    
    self.navigationItem.title = NSLocalizedString(@"扫一扫", nil);
    
    _captureLayer = [[UIImageView alloc] init];
    _captureLayer.ysf_frameWidth = self.view.ysf_frameWidth;
    _captureLayer.ysf_frameHeight = self.view.ysf_frameHeight;
    [self.view addSubview:_captureLayer];
    
    UIImageView *top = [[UIImageView alloc] init];
    top.backgroundColor = YSFRGBA(0x000000, 0.5);
    top.ysf_frameWidth = self.view.ysf_frameWidth;
    top.ysf_frameHeight = (self.view.ysf_frameHeight - 300)/2;
    [self.view addSubview:top];
    
    UIImageView *bottom = [[UIImageView alloc] init];
    bottom.backgroundColor = YSFRGBA(0x000000, 0.5);
    bottom.ysf_frameWidth = self.view.ysf_frameWidth;
    bottom.ysf_frameTop = (self.view.ysf_frameHeight - 300)/2 + 300;
    bottom.ysf_frameHeight = (self.view.ysf_frameHeight - 300)/2;
    [self.view addSubview:bottom];
    UILabel *tip = [[UILabel alloc] init];
    tip.textColor = [UIColor whiteColor];
    tip.text = @"AppKey二维码位于<管理后台－设置－App接入>";
    tip.font = [UIFont systemFontOfSize:14];
    [tip sizeToFit];
    tip.ysf_frameTop = 20;
    tip.ysf_frameCenterX = bottom.ysf_frameWidth/2;
    [bottom addSubview:tip];
    
    UIImageView *left = [[UIImageView alloc] init];
    left.backgroundColor = YSFRGBA(0x000000, 0.5);
    left.ysf_frameWidth = (self.view.ysf_frameWidth - 300)/2;
    left.ysf_frameTop = top.ysf_frameHeight;
    left.ysf_frameHeight = 300;
    [self.view addSubview:left];
    
    UIImageView *right = [[UIImageView alloc] init];
    right.backgroundColor = YSFRGBA(0x000000, 0.5);
    right.ysf_frameWidth = (self.view.ysf_frameWidth - 300)/2;
    right.ysf_frameRight = self.view.ysf_frameWidth;
    right.ysf_frameTop = top.ysf_frameHeight;
    right.ysf_frameHeight = 300;
    [self.view addSubview:right];
    
    UIImageView *center = [[UIImageView alloc] init];
    center.ysf_frameLeft = left.ysf_frameRight;
    center.ysf_frameWidth = 300;
    center.ysf_frameTop = top.ysf_frameBottom;
    center.ysf_frameHeight = 300;
    center.layer.borderWidth = 1;
    center.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:center];
    
    UIImageView *leftTop = [[UIImageView alloc] init];
    leftTop.image = [UIImage imageNamed:@"scan_lefttop"];
    [leftTop sizeToFit];
    [center addSubview:leftTop];
    UIImageView *leftBottom = [[UIImageView alloc] init];
    leftBottom.image = [UIImage imageNamed:@"scan_leftbottom"];
    [leftBottom sizeToFit];
    leftBottom.ysf_frameBottom = center.ysf_frameHeight;
    [center addSubview:leftBottom];
    UIImageView *rightTop = [[UIImageView alloc] init];
    rightTop.image = [UIImage imageNamed:@"scan_topright"];
    [rightTop sizeToFit];
    rightTop.ysf_frameRight = center.ysf_frameWidth;
    [center addSubview:rightTop];
    UIImageView *rightBottom = [[UIImageView alloc] init];
    rightBottom.image = [UIImage imageNamed:@"scan_rightbottom"];
    [rightBottom sizeToFit];
    rightBottom.ysf_frameBottom = center.ysf_frameHeight;
    rightBottom.ysf_frameRight = center.ysf_frameWidth;
    [center addSubview:rightBottom];
}

- (void)viewDidUnload
{
    self.capture = nil;
    
    [super viewDidUnload];
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.capture.delegate = nil;
    self.capture.captureLayer = nil;
    
}

- (void)initCapture
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.capture = [[YXCapture alloc] initWithOneDMode:(NO)];
        self.capture.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //中间扫描区域框width&height为300
            CGRect scanRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2, ([UIScreen mainScreen].bounds.size.height - 300) / 2, 300, 300);
            self.capture.cropRect = scanRect;
            self.capture.scaleSize = scanRect.size;
            self.capture.scale = 1.0f;
            
            self.capture.captureLayer.frame = self.view.frame;
            //[self.view.layer addSublayer:self.capture.captureLayer];
            [self.captureLayer.layer addSublayer:self.capture.captureLayer];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                [self.capture start];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(!self.capture.oneDMode)
                    {
                        [self captureCameraIsReady:self.capture];
                    }
                });
            });
            
        });
    });
}

#pragma mark - Action
- (void)back:(id)sender
{
    // 提前释放内存，防止出现上一个capture还没释放，又进入扫描界面再次返回，出现混乱
    //    http://blog.csdn.net/aldridge1/article/details/17682555
    [self.capture.captureLayer removeFromSuperlayer];
    [self.capture stop];
}


#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(YXCapture*)capture result:(id)result
{
    NSString *scanResult = [result isKindOfClass:[ZXResult class]]? ((ZXResult*)result).text :result;
    NSRange range = [scanResult rangeOfString:@"key="];
    NSString *appkey = nil;
    if (range.location != NSNotFound) {
        unsigned long startIndex = range.location + range.length;
        appkey = [scanResult substringWithRange:NSMakeRange(startIndex, 32)];
    }
    NSRange range2 = [scanResult rangeOfString:@"testing="];
    NSUInteger isTesting = 0;
    if (range2.location != NSNotFound) {
        unsigned long startIndex2 = range2.location + range2.length;
        isTesting = [[scanResult substringWithRange:NSMakeRange(startIndex2, 1)] integerValue];
    }
    
    if (!appkey) {
        [self.capture stop];
//        [self.view ysf_makeToast:@"二维码错误" duration:4.0 position:YSFToastPositionCenter];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
                                                        message:@"二维码错误"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil, nil];
        [alert ysf_showWithCompletion:^(NSInteger index)
         {
             [self.capture start];
         }];
    }
    else {
        [_delegate qRcodeScanSucess:appkey isTesting:isTesting];
    }
}

- (void)captureCameraIsReady:(YXCapture *)capture
{

}

@end

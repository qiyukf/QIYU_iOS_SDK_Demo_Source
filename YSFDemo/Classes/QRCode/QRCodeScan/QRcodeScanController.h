//
//  QRcodeScanController.h
//  Barcodes
//
//  Created by Pan Fengfeng on 13-4-2.
//
//

#include <UIKit/UIKit.h>


/*
 *  V1.6.1 需求，公众账号聊天界面添加调用条形码和二维码扫描功能，将扫描结果回调发送给公众账号，屏蔽从相册选择入口
 *  易信界面进入还保持原来的功能，扫描二维码名片
 */
@protocol QRCodeScanDelegate <NSObject>

- (void)qRcodeScanSucess:(NSString *)appkey isTesting:(NSInteger)isTesting;

@end

#pragma mark -
#pragma mark QRcodeScanController
@interface QRcodeScanController : UIViewController

@property (nonatomic, weak) id<QRCodeScanDelegate> delegate;
@end

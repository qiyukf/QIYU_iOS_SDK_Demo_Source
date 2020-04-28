//
//  QRcodeScanController.h
//  Barcodes
//
//  Created by Pan Fengfeng on 13-4-2.
//
//

#include <UIKit/UIKit.h>


@protocol QRCodeScanDelegate <NSObject>

- (void)qRcodeScanSucess:(NSString *)appkey isTesting:(NSInteger)isTesting;

@end

#pragma mark -
#pragma mark QRcodeScanController
@interface QRcodeScanController : UIViewController

@property (nonatomic, weak) id<QRCodeScanDelegate> delegate;
@end

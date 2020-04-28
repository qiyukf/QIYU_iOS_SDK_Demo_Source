#import <UIKit/UIKit.h>


@interface QYWebViewController : UIViewController

- (instancetype)initWithUrl:(NSString *)urlString
                 needOffset:(BOOL)needOffset
                 errorImage:(UIImage *)errorImage;

- (instancetype)initWithUrl:(NSString *)urlString
                 needOffset:(BOOL)needOffset
                 errorImage:(UIImage *)errorImage
              progressColor:(UIColor *)progressColor;

@end


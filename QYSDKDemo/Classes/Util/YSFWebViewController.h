#import <UIKit/UIKit.h>


@interface YSFWebViewController : UIViewController

- (instancetype)initWithUrl:(NSString *)urlString
                 needOffset:(BOOL)needOffset
                 errorImage:(UIImage *)errorImage;

- (instancetype)initWithUrl:(NSString *)urlString
                 needOffset:(BOOL)needOffset
                 errorImage:(UIImage *)errorImage
              progressColor:(UIColor *)progressColor;

@end


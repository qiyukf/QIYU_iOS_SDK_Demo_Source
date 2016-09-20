
#import <UIKit/UIKit.h>

@interface QYAppKeyConfig : NSObject<NSCoding>
@property (nonatomic,copy)      NSString    *appKey;
@property (nonatomic,assign)    NSInteger   useDevEnvironment;
@end

@interface QYBindAppkeyViewController : UITableViewController
@end

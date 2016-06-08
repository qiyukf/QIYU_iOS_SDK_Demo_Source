
#import <UIKit/UIKit.h>

@interface QYAppKeyConfig : NSObject<NSCoding>
@property (nonatomic,copy)      NSString    *appKey;
@property (nonatomic,assign)    BOOL        useDevEnvironment;
@end

@interface QYBindAppkeyViewController : UITableViewController
@end

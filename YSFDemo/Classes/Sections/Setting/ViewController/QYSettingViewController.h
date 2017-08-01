
#import <UIKit/UIKit.h>


extern BOOL g_isDefault;
extern int64_t    g_groupId;
extern int64_t    g_staffId;
extern int64_t    g_questionId;
extern BOOL    g_openRobotInShuntMode;

@interface QYSettingViewController : UITableViewController

- (void)onChat;

@end

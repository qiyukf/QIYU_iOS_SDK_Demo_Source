#import "QYSettingViewController.h"
#import "QYUserTableViewController.h"
#import "QYBindAppkeyViewController.h"
#import "QYDemoConfig.h"
#import "QYSDK.h"
#import "YSFCommonTableData.h"
#import "YSFCommonTableDelegate.h"
#import "YSFCommonTableViewCell.h"
#import "UIView+YSFToast.h"
#import "QYDemoBadgeView.h"
#import "UIView+YSF.h"
#import "QYLogViewController.h"


@interface YSFUnReadCount : UITableViewCell<YSFCommonTableViewCell, QYConversationManagerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) YSFDemoBadgeView *badgeView;
@end

@implementation YSFUnReadCount

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _badgeView = [[YSFDemoBadgeView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self addSubview:_badgeView];
    }
    return self;
}

- (void)refreshData:(YSFCommonTableRow *)rowData tableView:(UITableView *)tableView{
    self.textLabel.text    = rowData.title;
    self.detailTextLabel.text = rowData.detailTitle;
    [self configBadgeView];
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
}

- (void)onUnreadCountChanged:(NSInteger)count
{
    [self configBadgeView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _badgeView.ysf_frameRight = self.ysf_frameRight - 50;
    _badgeView.ysf_frameCenterY = self.ysf_frameHeight / 2;
}

- (void)configBadgeView
{
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [_badgeView setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",count];
    [_badgeView setBadgeValue:value];
}

@end



@interface QYSettingViewController ()

@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) YSFCommonTableDelegate *delegator;
@property (nonatomic,assign) BOOL isDefault;

@property (nonatomic,assign)      int64_t    groupId;
@property (nonatomic,assign)      int64_t    staffId;
@end

@implementation QYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isDefault = true;
    self.navigationItem.title = @"设置";
    self.tableView.backgroundColor = YSFColorFromRGB(0xeeeeee);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) wself = self;
    self.delegator = [[YSFCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    [self buildData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self buildData];
    [self.tableView reloadData];
}

- (void)buildData
{
    NSString *appkey = [QYDemoConfig sharedConfig].appKey;
    NSString *bindAppkey;
    NSString *bindAppkeyDetail;
    if (!appkey) {
        bindAppkey = @"绑定appkey";
    }
    else {
        bindAppkey = @"已绑定AppKey";
        bindAppkeyDetail = @"AppKey: ";
        bindAppkeyDetail = [bindAppkeyDetail stringByAppendingString:appkey];
    }

    NSArray *data = @[

                      @{
                          YSFHeaderTitle:@"",
                          YSFRowContent :@[
                                  @{
                                      YSFTitle      :@"个人信息",
                                      YSFCellAction :@"onChangeUserInfo:",
                                      YSFShowAccessory : @(YES)
                                      },
                                  @{
                                      YSFTitle      :bindAppkey,
                                      YSFDetailTitle:bindAppkeyDetail,
                                      YSFCellAction :@"onBindAppkey:",
                                      YSFShowAccessory : @(YES)
                                      },
                                  ],
                          YSFFooterTitle:@""
                          },

                      @{
                          YSFHeaderTitle:@"",
                          YSFRowContent :@[
                                  @{
                                      YSFTitle      :@"切换聊天窗口样式",
                                      YSFCellAction :@"onChangeSkin:",
                                      },
                                  
                                  @{
                                      YSFTitle      :@"查看云信log",
                                      YSFCellAction :@"viewNimLog:",
                                      YSFShowAccessory : @(YES)
                                      },
                                  
                                  @{
                                      YSFTitle      :@"查看七鱼log",
                                      YSFCellAction :@"viewYsfLog:",
                                      YSFShowAccessory : @(YES)
                                      },
                                  
                                  ],
                          YSFFooterTitle:@""
                          },
                      
                      @{
                          YSFHeaderTitle:@"",
                          YSFRowContent :@[
                                  @{
                                      YSFTitle      :@"分组ID",
                                      YSFCellAction :@"onInputGroupId:",
                                      YSFShowAccessory : @(YES)
                                      },
                                  
                                  @{
                                      YSFTitle      :@"客服ID",
                                      YSFCellAction :@"onInputStaffId:",
                                      YSFShowAccessory : @(YES)
                                      },
                                  
                                  @{
                                      YSFCellClass  :@"YSFUnReadCount",
                                      YSFTitle      :@"联系客服",
                                      YSFCellAction :@"onChat:",
                                      YSFShowAccessory : @(YES)
                                      },
                                  ],
                          YSFFooterTitle:@""
                          },
                      

                      ];
    self.data = [YSFCommonTableSection sectionsWithData:data];
}

- (void)onChangeUserInfo:(id)sender
{
    QYUserTableViewController *vc = [[QYUserTableViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)onChangeSkin:(id)sender
{
    if (_isDefault) {
        _isDefault = false;
//        [[QYSDK sharedSDK] customUIConfig].sessionTipTextColor = [UIColor blackColor];
//        [[QYSDK sharedSDK] customUIConfig].sessionTipTextFontSize = 20;
//        [[QYSDK sharedSDK] customUIConfig].customMessageTextFontSize = 20;
//        [[QYSDK sharedSDK] customUIConfig].serviceMessageTextFontSize = 20;
//        [[QYSDK sharedSDK] customUIConfig].tipMessageTextColor = [UIColor blueColor];
//        [[QYSDK sharedSDK] customUIConfig].tipMessageTextFontSize = 16;
//        [[QYSDK sharedSDK] customUIConfig].inputTextColor = [UIColor blueColor];
//        [[QYSDK sharedSDK] customUIConfig].inputTextFontSize = 20;
        
        //[[QYSDK sharedSDK] customUIConfig].sessionTipBackgroundColor = [UIColor blueColor];
        //[[QYSDK sharedSDK] customUIConfig].sessionMessageSpacing = 20;
        
        [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [UIColor blackColor];
        [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [UIColor blackColor];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"session_bg"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;

        [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageNamed:@"customer_head"];
        [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"service_head"];
        
        [[QYSDK sharedSDK] customUIConfig].customerMessageBubbleNormalImage = [[UIImage imageNamed:@"icon_sender_node"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
                                             resizingMode:UIImageResizingModeStretch];
        [[QYSDK sharedSDK] customUIConfig].customerMessageBubblePressedImage = [[UIImage imageNamed:@"icon_sender_node"]
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
                                              resizingMode:UIImageResizingModeStretch];
        [[QYSDK sharedSDK] customUIConfig].serviceMessageBubbleNormalImage = [[UIImage imageNamed:@"icon_receiver_node"]
                                            resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
                                            resizingMode:UIImageResizingModeStretch];
        [[QYSDK sharedSDK] customUIConfig].serviceMessageBubblePressedImage = [[UIImage imageNamed:@"icon_receiver_node"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
                                             resizingMode:UIImageResizingModeStretch];
        [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = NO;
        
        
    }
    else {
        _isDefault = true;
        [[[QYSDK sharedSDK] customUIConfig] restoreToDefault];
    }
    
    [self.view ysf_makeToast:@"切换成功" duration:2.0 position:YSFToastPositionCenter];
}

- (void)viewNimLog:(id)sender
{
    NSString *path = [[QYSDK sharedSDK] performSelector:@selector(nimLog)];
    QYLogViewController *vc = [[QYLogViewController alloc] initWithFilepath:path];
    vc.title = @"云信log";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewYsfLog:(id)sender
{
    NSString *path =  [[QYSDK sharedSDK] performSelector:@selector(ysfLog)];
    QYLogViewController *vc = [[QYLogViewController alloc] initWithFilepath:path];
    vc.title = @"七鱼log";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onChat:(id)sender
{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    sessionViewController.groupId = _groupId;
    sessionViewController.staffId = _staffId;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    
    //如果您的代码要求所有viewController继承某个公共基类，并且公共基类对UINavigationController统一做了某些处理，
    //或者对UINavigationController做了自己的扩展，并且这会导致无法正常集成，
    //或者其他原因导致使用第一种方式集成会有问题，这些情况下，建议您使用第二种方式集成。
    if (_isDefault) {
        //集成方式一
        [self.navigationController pushViewController:sessionViewController animated:YES];
    }
    else {
        //集成方式二
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
        sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite == NO) {
        sessionViewController.navigationController.navigationBar.translucent = NO;
        NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        sessionViewController.navigationController.navigationBar.titleTextAttributes = dict;
        [sessionViewController.navigationController.navigationBar setBarTintColor:YSFRGB(0x62a8ea)];
    }
    else {
        sessionViewController.navigationController.navigationBar.translucent = YES;
        NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        sessionViewController.navigationController.navigationBar.titleTextAttributes = dict;
        [sessionViewController.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    }

}

- (void)onBindAppkey:(id)sender
{
    QYBindAppkeyViewController *vc = [[QYBindAppkeyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onInputGroupId:(id)sender
{
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入分组ID"
                                                     message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [dialog show];
}

- (void)onInputStaffId:(id)sender
{
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入客服ID"
                                                     message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [dialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        int64_t longlongId = [[alertView textFieldAtIndex:0].text longLongValue];
        if ([alertView.title isEqualToString:@"请输入分组ID"]) {
            self.groupId = longlongId;
            self.staffId = 0;
        }
        else if ([alertView.title isEqualToString:@"请输入客服ID"]) {
            self.staffId = longlongId;
            self.groupId = 0;
        }
    }
    
}

@end

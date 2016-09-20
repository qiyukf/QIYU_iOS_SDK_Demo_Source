#import "QYBindAppkeyViewController.h"
#import "QYUserTableViewController.h"
#import "QRcodeScanController.h"
#import "QYAddAppKeyViewController.h"
#import "QYSDK.h"
#import "QYDemoConfig.h"
#import "YSFCommonTableData.h"
#import "YSFCommonTableDelegate.h"
#import "YSFCommonTableViewCell.h"
#import "UIView+YSFToast.h"
#import "UIAlertView+YSF.h"


@implementation QYAppKeyConfig
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_appKey
                  forKey:@"appkey"];
    [aCoder encodeObject:@(_useDevEnvironment)
                  forKey:@"dev"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _appKey             = [aDecoder decodeObjectForKey:@"appkey"];
        _useDevEnvironment  = [[aDecoder decodeObjectForKey:@"dev"] integerValue];
    }
    return self;
}
@end

@interface QYBindAppkeyViewController () <QYAppKeyAddDelegate, QRCodeScanDelegate>
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) YSFCommonTableDelegate *delegator;
@end

@implementation QYBindAppkeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定AppKey";
    
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


- (void)buildData
{

    NSArray *data = @[
                      @{
                          YSFHeaderTitle:@"",
                          YSFHeaderHeight:@(50),
                          YSFRowContent :@[
                                  @{
                                      YSFCellClass  :@"YSFUserCell",
                                      YSFTitle      :@"扫一扫绑定",
                                      YSFDetailTitle:@"AppKey二维码位于“管理后台-设置-App接入”",
                                      YSFCellAction :@"onSelectRow1:",
                                      YSFShowAccessory : @(YES),
                                      },
                                  @{
                                      YSFCellClass  :@"YSFUserCell",
                                      YSFTitle      :@"输入AppKey绑定",
                                      YSFCellAction :@"onSelectRow2:",
                                      YSFShowAccessory : @(YES),
                                      },
                                  ],
                          YSFFooterTitle:@""
                          },
                      ];
    self.data = [YSFCommonTableSection sectionsWithData:data];
}

- (void)onSelectRow1:(id)sender
{
    QRcodeScanController *vc = [[QRcodeScanController alloc] init];
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onSelectRow2:(id)sender
{
    QYAddAppKeyViewController *vc = [[QYAddAppKeyViewController alloc] init];
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)qRcodeScanSucess:(NSString *)appkey isTesting:(NSInteger)isTesting
{
    [self save:appkey isTesting:isTesting];
}

- (void)onAddAppKey:(NSString *)appkey isTesting:(BOOL)isTesting
{
    [self save:appkey isTesting:isTesting];
}


#pragma mark - 配置文件读取
- (NSString *)configFilepath
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [dir stringByAppendingPathComponent:@"qy_appkey.plist"];
}

- (void)save:(NSString *)appkey isTesting:(NSInteger)isTesting
{
    [[QYDemoConfig sharedConfig] setAppKey:appkey];
    [[QYDemoConfig sharedConfig] setEnvironment:isTesting];
    NSString *appKey = [[QYDemoConfig sharedConfig] appKey];
    NSString *appName= [[QYDemoConfig sharedConfig] appName];
    [[QYSDK sharedSDK] registerAppId:appKey appName:appName];
    
    QYAppKeyConfig *config = [[QYAppKeyConfig alloc] init];
    config.appKey = appkey;
    config.useDevEnvironment = isTesting;
    NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:config];
    [data writeToFile:[self configFilepath] atomically:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"绑定成功"
                                                    message:@"需要重启app才能生效；请点击确定然后手动打开app"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert ysf_showWithCompletion:^(NSInteger index)
     {
         exit(0);
     }];
}

- (void)changeSkin
{

}

#pragma mark - 事件处理
- (void)onChat
{

}

@end

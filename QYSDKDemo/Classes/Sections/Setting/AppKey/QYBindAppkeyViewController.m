@import AVFoundation;

#import "QYBindAppkeyViewController.h"
#import "QYUserTableViewController.h"
#import "QRcodeScanController.h"
#import "QYAddAppKeyViewController.h"
#import "QYDemoConfig.h"
#import "YSFCommonTableData.h"
#import "YSFCommonTableDelegate.h"
#import "YSFCommonTableViewCell.h"
#import "UIView+YSFToast.h"
#import "QYCommonCell.h"
#import "QYDataSourceConfig.h"
#import "QYAppKeyConfig.h"
#import <QYSDK/QYSDK.h>


static NSString * const kQYAppKeyCellIdentifier = @"kQYAppKeyCellIdentifier";



@interface QYBindAppkeyViewController () <UITableViewDataSource, UITableViewDelegate, QYAppKeyAddDelegate, QRCodeScanDelegate, UIAlertViewDelegate, QYCommonCellActionDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, assign) NSInteger isTesting;
@property (nonatomic, assign) BOOL isFusion;

@end


@implementation QYBindAppkeyViewController

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定AppKey";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[QYSDK sharedSDK] trackHistory:@"绑定AppKey" enterOrOut:YES key:_key];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[QYSDK sharedSDK] trackHistory:@"绑定AppKey" enterOrOut:NO key:_key];
    self.key = [[NSUUID UUID] UUIDString];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[QYDataSourceConfig sharedConfig].appKeyDataSource count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].appKeyDataSource[section];
    return tableSection.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].appKeyDataSource[section];
    return tableSection.footerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].appKeyDataSource[section];
    return [tableSection.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:kQYAppKeyCellIdentifier];
    if (!cell) {
        cell = [[QYCommonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kQYAppKeyCellIdentifier];
    }
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].appKeyDataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    cell.rowData = tableRow;
    cell.actionDelegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].appKeyDataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    if (tableRow.uiRowHeight > 0) {
        return tableRow.uiRowHeight;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].appKeyDataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    [self didSelectRow:tableRow indexPath:indexPath];
}

#pragma mark - Action
- (void)didSelectRow:(YSFCommonTableRow *)rowData indexPath:(NSIndexPath *)indexPath {
    if (rowData.type == QYAppKeyTypeQRScan) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"检测不到相机设备"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
            return;
        }
        NSString *mediaType = AVMediaTypeVideo;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [[[UIAlertView alloc] initWithTitle:@"没有相机权限"
                                        message:@"请在iPhone的“设置-隐私-相机”选项中，允许访问你的相机。"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
            return;
            
        }

        QRcodeScanController *vc = [[QRcodeScanController alloc] init];
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (rowData.type == QYAppKeyTypeInput) {
        QYAddAppKeyViewController *vc = [[QYAddAppKeyViewController alloc] init];
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - QYCommonCellActionDelegate
- (void)onTapSwitch:(YSFCommonTableRow *)cellData {
    if (cellData.type == QYAppKeyTypeFusion) {
        _isFusion = cellData.switchOn;
    }
}

#pragma mark - QRCodeScanDelegate
- (void)qRcodeScanSucess:(NSString *)appkey isTesting:(NSInteger)isTesting {
    [self save:appkey isTesting:isTesting];
}

#pragma mark - QYAppKeyAddDelegate
- (void)onAddAppKey:(NSString *)appkey isTesting:(NSInteger)isTesting {
    [self save:appkey isTesting:isTesting];
}

#pragma mark - 配置文件读取
- (NSString *)configFilepath {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [dir stringByAppendingPathComponent:@"qy_appkey.plist"];
}

- (void)save:(NSString *)appkey isTesting:(NSInteger)isTesting {
    self.appKey = appkey;
    self.isTesting = isTesting;
    
    [QYDemoConfig sharedConfig].appKey = appkey;
    [QYDemoConfig sharedConfig].isFusion = self.isFusion;
    [[QYDemoConfig sharedConfig] setEnvironment:isTesting];
    
    QYAppKeyConfig *saveData = [[QYAppKeyConfig alloc] init];
    saveData.appKey = appkey;
    saveData.environment = isTesting;
    saveData.isFusion = self.isFusion;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:saveData];
    BOOL result = [data writeToFile:[self configFilepath] atomically:YES];
    
    NSString *title = nil;
    NSString *message = nil;
    if (result) {
        title = @"绑定成功";
#if YSFDemoEnvironmentDebug
        message = @"需重启APP才可生效\n请点击确定后手动打开APP\n\n如有需要，请输入测试环境\n0-线上; 1-预发; 2-测试; 3-开发";
#else
        message = @"需重启APP才可生效\n请点击确定后手动打开APP";
#endif
    } else {
        title = @"绑定失败";
        message = @"请重新绑定";
    }
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
    
#if YSFDemoEnvironmentDebug
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
#else
    dialog.alertViewStyle = UIAlertViewStyleDefault;
#endif
    [dialog show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#if YSFDemoEnvironmentDebug
    if (UIAlertViewStylePlainTextInput == alertView.alertViewStyle) {
        NSString *text = [alertView textFieldAtIndex:0].text;
        NSInteger env = [text integerValue];
        if (text.length == 0 || text.length > 1 || env < 0 || env > 3) {
            env = self.isTesting;
        }
        [QYDemoConfig sharedConfig].appKey = self.appKey;
        [QYDemoConfig sharedConfig].isFusion = self.isFusion;
        [[QYDemoConfig sharedConfig] setEnvironment:env];
        
        QYAppKeyConfig *config = [[QYAppKeyConfig alloc] init];
        config.appKey = self.appKey;
        config.environment = env;
        config.isFusion = self.isFusion;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:config];
        BOOL result = [data writeToFile:[self configFilepath] atomically:YES];
        
        if (result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exit(0);
            });
        }
    }
#else
    if (UIAlertViewStyleDefault == alertView.alertViewStyle) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }
#endif
}

@end

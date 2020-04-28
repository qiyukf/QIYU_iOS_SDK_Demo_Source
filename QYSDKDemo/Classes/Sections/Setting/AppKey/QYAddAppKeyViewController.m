//
//  YSFAddAppKeyViewController.m
//  YSFDemo
//
//  Created by amao on 9/24/15.
//  Copyright © 2015 Netease. All rights reserved.
//

#import "QYAddAppKeyViewController.h"
#import "YSFCommonTableData.h"
#import "QYCommonCell.h"
#import "UIView+YSFToast.h"
#import <QYSDK/QYSDK.h>
#import "QYMacro.h"

static NSString * const kAddAppKeyCellIdentifier = @"kAddAppKeyCellIdentifier";

typedef NS_ENUM(NSInteger, QYAddAppKeyType) {
    QYAddAppKeyTypeNone = 0,
    QYAddAppKeyTypeInput,
    QYAddAppKeyTypeOnline,
    QYAddAppKeyTypePre,
    QYAddAppKeyTypeTest,
    QYAddAppKeyTypeDev,
};


@interface QYAddAppKeyViewController () <UITableViewDataSource, UITableViewDelegate, QYCommonCellActionDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, assign) BOOL isPre;
@property (nonatomic, assign) BOOL isTest;
@property (nonatomic, assign) BOOL isDev;

@end


@implementation QYAddAppKeyViewController

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"输入AppKey绑定";
    self.key = [[NSUUID UUID] UUIDString];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onAddAppKey:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
                                                          forState:UIControlStateNormal];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    self.isOnline = YES;
    self.isPre = NO;
    self.isTest = NO;
    self.isDev = NO;
    [self makeData];
}

- (void)makeData {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:@{
        YSFHeaderTitle : @"请输入32位AppKey完成绑定",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleNormal),
                    YSFTitle : @"输入AppKey",
                    YSFDetailTitle : QYStrParam(self.appKey),
                    YSFType : @(QYAddAppKeyTypeInput),
                },
        ],
        YSFFooterTitle : @"",
    }];
    [data addObject:@{
        YSFHeaderTitle : @"环境选择",
        YSFRowContent : @[
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"正式环境",
                    YSFType : @(QYAddAppKeyTypeOnline),
                    YSFSwitchOn : @(self.isOnline),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"预发环境",
                    YSFType : @(QYAddAppKeyTypePre),
                    YSFSwitchOn : @(self.isPre),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"测试环境",
                    YSFType : @(QYAddAppKeyTypeTest),
                    YSFSwitchOn : @(self.isTest),
                },
                @{
                    YSFStyle : @(YSFCommonCellStyleSwitch),
                    YSFTitle : @"开发环境",
                    YSFType : @(QYAddAppKeyTypeDev),
                    YSFSwitchOn : @(self.isDev),
                },
        ],
        YSFFooterTitle : @"",
    }];
    self.dataSource = [YSFCommonTableSection sectionsWithData:data];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[QYSDK sharedSDK] trackHistory:@"输入AppKey绑定" enterOrOut:YES key:_key];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[QYSDK sharedSDK] trackHistory:@"输入AppKey绑定" enterOrOut:NO key:_key];
    self.key = [[NSUUID UUID] UUIDString];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)onAddAppKey:(id)sender {
    if (self.appKey.length == 32) {
        NSInteger env = 0;
        if (_isTest) {
            env = 1;
        } else if (_isPre) {
            env = 2;
        } else if (_isDev) {
            env = 3;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(onAddAppKey:isTesting:)]) {
            [self.delegate onAddAppKey:self.appKey isTesting:env];
        }
    } else {
        [self showToast:@"请输入正确的AppKey"];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = self.dataSource[section];
    return tableSection.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = self.dataSource[section];
    return tableSection.footerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = self.dataSource[section];
    return [tableSection.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddAppKeyCellIdentifier];
    if (!cell) {
        cell = [[QYCommonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kAddAppKeyCellIdentifier];
    }
    YSFCommonTableSection *tableSection = self.dataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    cell.rowData = tableRow;
    cell.actionDelegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFCommonTableSection *tableSection = self.dataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    if (tableRow.uiRowHeight > 0) {
        return tableRow.uiRowHeight;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSFCommonTableSection *tableSection = self.dataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    [self didSelectRow:tableRow indexPath:indexPath];
}

#pragma mark - Action
- (void)didSelectRow:(YSFCommonTableRow *)rowData indexPath:(NSIndexPath *)indexPath {
    if (rowData.type == QYAddAppKeyTypeInput) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入32位AppKey完成绑定"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.placeholder = @"AppKey";
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([alert.textFields count] >= 1) {
                UITextField *textField = [alert.textFields firstObject];
                if (textField.text.length == 32) {
                    weakSelf.appKey = textField.text;
                    [weakSelf makeData];
                    [weakSelf.tableView reloadData];
                } else {
                    [weakSelf showToast:@"请输入正确的AppKey"];
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - QYCommonCellActionDelegate
- (void)onTapSwitch:(YSFCommonTableRow *)cellData {
    if (cellData.type == QYAddAppKeyTypeOnline) {
        _isOnline = cellData.switchOn;
        if (_isOnline) {
            _isPre = NO;
            _isTest = NO;
            _isDev = NO;
        }
    } else if (cellData.type == QYAddAppKeyTypePre) {
        _isPre = cellData.switchOn;
        if (_isPre) {
            _isOnline = NO;
            _isTest = NO;
            _isDev = NO;
        }
    } else if (cellData.type == QYAddAppKeyTypeTest) {
        _isTest = cellData.switchOn;
        if (_isTest) {
            _isOnline = NO;
            _isPre = NO;
            _isDev = NO;
        }
    } else if (cellData.type == QYAddAppKeyTypeDev) {
        _isDev = cellData.switchOn;
        if (_isDev) {
            _isOnline = NO;
            _isPre = NO;
            _isTest = NO;
        }
    }
    [self makeData];
    [self.tableView reloadData];
}

- (void)showToast:(NSString *)toast {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC.view ysf_makeToast:toast duration:2.0 position:YSFToastPositionCenter];
}

@end

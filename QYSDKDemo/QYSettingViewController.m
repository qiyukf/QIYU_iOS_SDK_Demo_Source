//
//  QYSettingViewController.m
//  QYSDKDemo
//
//  Created by liaosipei on 2020/3/2.
//  Copyright © 2020 Netease. All rights reserved.
//

#import "QYSettingViewController.h"
#import "QYCommonTableData.h"
#import <QYSDK/QYPOPSDK.h>


static NSString * const kQYSettingCellIdentifier = @"kQYSettingCellIdentifier";

typedef NS_ENUM(NSInteger, QYSettingType) {
    QYSettingTypeNone = 0,
    QYSettingTypePushQY,
    QYSettingTypePresentQY,
};


@interface QYSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
/**
 * 注意这里用weak修饰
 */
@property (nonatomic, weak) QYSessionViewController *sessionVC;

@end


@implementation QYSettingViewController

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    [self makeDataSource];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
}

- (void)makeDataSource {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:@{
        QYHeaderTitle : @"",
        QYRowContent : @[
                @{
                    QYTitle : @"联系客服（push）",
                    QYType : @(QYSettingTypePushQY),
                    QYShowAccessory : @(YES),
                },
                @{
                    QYTitle : @"联系客服（present）",
                    QYType : @(QYSettingTypePresentQY),
                    QYShowAccessory : @(YES),
                },
        ],
        QYFooterTitle : @"",
    }];
    self.dataSource = [QYCommonSectionData sectionsWithData:data];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QYCommonSectionData *tableSection = self.dataSource[section];
    return [tableSection.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQYSettingCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kQYSettingCellIdentifier];
    }
    QYCommonSectionData *tableSection = self.dataSource[indexPath.section];
    QYCommonRowData *tableRow = tableSection.rows[indexPath.row];
    cell.textLabel.text = tableRow.title;
    cell.detailTextLabel.text = tableRow.detailTitle;
    cell.accessoryType = tableRow.showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QYCommonSectionData *tableSection = self.dataSource[indexPath.section];
    QYCommonRowData *tableRow = tableSection.rows[indexPath.row];
    if (tableRow.type == QYSettingTypePushQY) {
        [self pushQYService];
    } else if (tableRow.type == QYSettingTypePresentQY) {
        [self presentQYService];
    }
}

#pragma mark - Action
- (void)pushQYService {
    /**
     * 配置
     */
    
    
    /**
     * 进入客服页面
     */
    QYSource *source = [[QYSource alloc] init];
    source.title = @"七鱼客服";
    source.urlString = @"https://qiyukf.com/";

    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼客服";
    sessionViewController.source = source;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionViewController animated:YES];
    
    self.sessionVC = sessionViewController;
}

- (void)presentQYService {
    QYSource *source = [[QYSource alloc] init];
    source.title = @"七鱼客服";
    source.urlString = @"https://qiyukf.com/";

    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼客服";
    sessionViewController.source = source;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
    [self presentViewController:nav animated:YES completion:nil];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(onBack:)];
    sessionViewController.navigationItem.leftBarButtonItem = leftItem;
}

- (void)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

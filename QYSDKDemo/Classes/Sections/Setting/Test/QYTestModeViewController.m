//
//  QYTestModeViewController.m
//  YSFDemo
//
//  Created by JackyYu on 2016/12/12.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "QYTestModeViewController.h"
#import "QYCommodityInfoViewController.h"
#import "QYShopInfoViewController.h"
#import "QYTestModeViewController.h"
#import "UIView+YSF.h"
#import "UIView+YSFToast.h"
#import "QYSessionListViewController.h"
#import "QYSettingViewController.h"
#import "QYTrackViewController.h"
#import "YSFCommonTableData.h"
#import "QYCommonCell.h"
#import "QYDemoConfig.h"
#import "QYSettingData.h"
#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYPOPSDK.h>


static NSString * const kTestModeCellIdentifier = @"kTestModeCellIdentifier";

typedef NS_ENUM(NSInteger, QYTestModeType) {
    QYTestModeTypeNone = 0,
    QYTestModeTypeCommodityInfo,
    QYTestModeTypeShopInfo,
    QYTestModeTypeTarck,
};


@interface QYTestModeViewController () <UITableViewDataSource, UITableViewDelegate, QYSessionViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation QYTestModeViewController
- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试功能";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"联系客服"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onChat:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
                                                          forState:UIControlStateNormal];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[QYCommonCell class] forCellReuseIdentifier:kTestModeCellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self makeData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)makeData {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:@{
        YSFHeaderTitle : @"",
        YSFRowContent : @[
                @{
                    YSFTitle : @"自定义商品信息",
                    YSFType : @(QYTestModeTypeCommodityInfo)
                },
                @{
                    YSFTitle : @"商铺信息",
                    YSFType : @(QYTestModeTypeShopInfo)
                },
                @{
                    YSFTitle : @"行为轨迹",
                    YSFType : @(QYTestModeTypeTarck)
                },
        ],
        YSFFooterTitle : @"",
    }];
    self.dataSource = [YSFCommonTableSection sectionsWithData:data];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = self.dataSource[section];
    return [tableSection.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:kTestModeCellIdentifier forIndexPath:indexPath];
    YSFCommonTableSection *tableSection = self.dataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    cell.rowData = tableRow;
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
    if (tableRow.type == QYTestModeTypeCommodityInfo) {
        QYCommodityInfoViewController *vc = [QYCommodityInfoViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tableRow.type == QYTestModeTypeShopInfo) {
        QYShopInfoViewController *vc = [QYShopInfoViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tableRow.type == QYTestModeTypeTarck) {
        QYTrackViewController *vc = [[QYTrackViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Action
- (void)onChat:(id)sender {
    if ([QYDemoConfig sharedConfig].isFusion) {
        if (![[NIMSDK sharedSDK] loginManager].isLogined) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:kQYInvalidAccountTitle
                                                                           message:kQYInvalidAccountMessage
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    /**
     * 创建QYSessionViewController
     */
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"测试功能";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionVC = [[QYSDK sharedSDK] sessionViewController];
    sessionVC.delegate = self;
    sessionVC.sessionTitle = @"七鱼金融";
    sessionVC.source = source;
    //shopID
    NSString *shopId = [[NSUserDefaults standardUserDefaults] valueForKey:YSFDemoShopInfoShopId];
    if (shopId.length) {
        sessionVC.shopId = [[NSUserDefaults standardUserDefaults] valueForKey:YSFDemoShopInfoShopId];
    }
    //商品卡片
    sessionVC.commodityInfo = [self makeCommodityInfo];
    //请求客服参数
    sessionVC.groupId = [QYSettingData sharedData].groupId;
    sessionVC.staffId = [QYSettingData sharedData].staffId;
    sessionVC.robotId = [QYSettingData sharedData].robotId;
    sessionVC.vipLevel = [QYSettingData sharedData].vipLevel;
    sessionVC.commonQuestionTemplateId = [QYSettingData sharedData].questionTemplateId;
    sessionVC.robotWelcomeTemplateId = [QYSettingData sharedData].robotWelcomeTemplateId;
    sessionVC.openRobotInShuntMode = [QYSettingData sharedData].openRobotInShuntMode;
    [[QYSettingData sharedData] resetEntranceParameter];
    //收起历史消息
    sessionVC.hideHistoryMessages = [QYSettingData sharedData].hideHistoryMsg;
    sessionVC.historyMessagesTip = [QYSettingData sharedData].historyMsgTip;
    /**
     * push
     */
    sessionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionVC animated:YES];
}

- (QYCommodityInfo *)makeCommodityInfo {
    QYCommodityInfo *commodityInfo = nil;
    if ([[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoTitle]) {
        commodityInfo = [[QYCommodityInfo alloc] init];
        commodityInfo.title = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoTitle];
        commodityInfo.desc = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoDesc];
        commodityInfo.urlString = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoUrlString];
        commodityInfo.pictureUrlString = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoPictureUrlString];
        commodityInfo.note = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoNote];
        commodityInfo.show = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowKey];
        NSMutableArray<QYCommodityTag *> *array = [NSMutableArray<QYCommodityTag *> new];
        QYCommodityTag *buttonInfo = [QYCommodityTag new];
        buttonInfo.label = @"测试1";
        buttonInfo.url = @"www.baidu.com";
        buttonInfo.focusIframe = @"iframe1";
        buttonInfo.data = @"userdata";
        [array addObject:buttonInfo];
        buttonInfo = [QYCommodityTag new];
        buttonInfo.label = @"测试2";
        buttonInfo.url = @"www.163.com";
        buttonInfo.focusIframe = @"iframe1";
        buttonInfo.data = @"userdata";
        [array addObject:buttonInfo];
        buttonInfo = [QYCommodityTag new];
        buttonInfo.label = @"测试3";
        buttonInfo.url = @"www.sina.com";
        buttonInfo.focusIframe = @"iframe1";
        buttonInfo.data = @"userdata";
        [array addObject:buttonInfo];
        commodityInfo.tagsArray = array;
    }
    return commodityInfo;
}

#pragma mark - Delegates
- (void)onTapShopEntrance {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"你点击了商铺入口"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)onTapSessionListEntrance {
    QYSessionListViewController *vc = [QYSessionListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

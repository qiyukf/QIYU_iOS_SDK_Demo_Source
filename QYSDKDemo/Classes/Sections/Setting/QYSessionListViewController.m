//
//  QYSessionListViewController.m
//  YSFSDK
//
//  Created by JackyYu on 16/12/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "QYSessionListViewController.h"
#import "QYSessionListCell.h"
#import "QYShopInfoViewController.h"
#import "QYSettingViewController.h"
#import "QYCommodityInfoViewController.h"
#import "UIView+YSFToast.h"
#import "QYDemoConfig.h"
#import "QYSettingData.h"
#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYPOPSDK.h>


#define kCellHeight 70.0
#define kCellReuseIdentify  @"cell"


@interface QYSessionListViewController ()<UITableViewDelegate, UITableViewDataSource, QYSessionViewDelegate, QYConversationManagerDelegate>

@property (nonatomic, strong) NSArray<QYSessionInfo *> *recentSessionArray;
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation QYSessionListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    
    [self setMainView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)setMainView {
    self.navigationItem.title = @"会话列表";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[QYSessionListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (void)reloadData:(NSArray<QYSessionInfo *> *)sessionList {
    self.recentSessionArray = sessionList;
    [_tableView reloadData];
}

- (void)reloadData {
    self.recentSessionArray = [[[QYSDK sharedSDK] conversationManager] getSessionList];
    [_tableView reloadData];
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    NSString *shopName = _recentSessionArray[indexPath.row].sessionName;
    shopName = shopName.length ? shopName : @"平台商铺";
    
    QYSource *source = [[QYSource alloc] init];
    source.title =  shopName;
    source.urlString = @"https://www.qiyukf.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.delegate = self;
    sessionViewController.sessionTitle = shopName;
    sessionViewController.source = source;
    //shopID
    sessionViewController.shopId = _recentSessionArray[indexPath.row].shopId;
    //请求客服参数
    sessionViewController.groupId = [QYSettingData sharedData].groupId;
    sessionViewController.staffId = [QYSettingData sharedData].staffId;
    sessionViewController.robotId = [QYSettingData sharedData].robotId;
    sessionViewController.vipLevel = [QYSettingData sharedData].vipLevel;
    sessionViewController.commonQuestionTemplateId = [QYSettingData sharedData].questionTemplateId;
    sessionViewController.robotWelcomeTemplateId = [QYSettingData sharedData].robotWelcomeTemplateId;
    sessionViewController.openRobotInShuntMode = [QYSettingData sharedData].openRobotInShuntMode;
    [[QYSettingData sharedData] resetEntranceParameter];
    //收起历史消息
    sessionViewController.hideHistoryMessages = [QYSettingData sharedData].hideHistoryMsg;
    sessionViewController.historyMessagesTip = [QYSettingData sharedData].historyMsgTip;
    /**
     * push
     */
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self onTapDeleteAtIndexPath:indexPath];
    }
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recentSessionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYSessionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[QYSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    QYSessionInfo *sessionInfo = _recentSessionArray[indexPath.row];
    cell.sessionInfo = sessionInfo;
    
    return cell;
}

#pragma mark - Delegate
- (void)onTapShopEntrance {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"你点击了商铺入口"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onTapSessionListEntrance {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSessionListChanged:(NSArray<QYSessionInfo *> *)sessionList {
    [self reloadData:sessionList];
}

- (void)onReceiveMessage:(QYMessageInfo *)message {
    NSString *messageString = [NSString stringWithFormat:@"shopid: %@\navatarImageUrlString: %@\nsessionName: %@\nlastMessageText: %@\nlastMessageTimeStamp: %lf", message.shopId, message.avatarImageUrlString, message.sender, message.text, message.timeStamp];
   [self.view ysf_makeToast:messageString duration:2.0 position:YSFToastPositionCenter];
}

#pragma mark - Private Method
- (void)onTapDeleteAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    [[[QYSDK sharedSDK] conversationManager] deleteRecentSessionByShopId:_recentSessionArray[indexPath.row].shopId
                                                          deleteMessages:[[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoShopInfoOnNeedDeleteChatHistory]];
    [self reloadData];
}

















@end

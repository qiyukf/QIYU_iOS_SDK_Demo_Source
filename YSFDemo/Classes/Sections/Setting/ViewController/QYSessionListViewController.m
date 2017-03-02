//
//  QYSessionListViewController.m
//  YSFSDK
//
//  Created by JackyYu on 16/12/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "QYSessionListViewController.h"
#import "QYSessionListCell.h"
#import "QYPOPSDK.h"
#import "QYShopInfoViewController.h"
#import "UIAlertView+YSF.h"
#import "QYSettingViewController.h"
#import "QYCommodityInfoViewController.h"
#import "UIView+YSFToast.h"
#import "QYPOPMessageInfo.h"


#define kCellHeight 70.0
#define kCellReuseIdentify  @"cell"



@interface QYSessionListViewController ()<UITableViewDelegate, UITableViewDataSource, QYSessionViewDelegate, QYPOPConversationManagerDelegate>


@property (nonatomic, strong) NSArray<QYPOPSessionInfo*> *recentSessionArray;


@property (nonatomic, strong) UITableView *tableView;



@end

@implementation QYSessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
    [self setMainView];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
}


- (void)initialize
{
    [[[QYSDK sharedSDK] conversationManager] popSetDelegate:self];
    
}

- (void)setMainView
{
    self.navigationItem.title = @"会话列表";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[QYSessionListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    

    
    
    
}

- (void)reloadData
{
    self.recentSessionArray = [[[QYSDK sharedSDK] conversationManager] getSessionList];
    [_tableView reloadData];
}





#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"我是来自电商平台";
    source.urlString = @"https://www.qiyukf.com/";
    
    QYCommodityInfo *commodityInfo = nil;
    if ([[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoTitle]) {
        commodityInfo = [[QYCommodityInfo alloc] init];
        commodityInfo.title = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoTitle];
        commodityInfo.desc = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoDesc];
        commodityInfo.urlString = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoUrlString];
        commodityInfo.pictureUrlString = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoPictureUrlString];
        commodityInfo.note = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoCommodityInfoNote];
        commodityInfo.show = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowKey];
    }
    
    QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
    vc.delegate = self;
    vc.shopId = _recentSessionArray[indexPath.row].shopId;
    vc.sessionTitle = _recentSessionArray[indexPath.row].sessionName;
    vc.source = source;
    vc.commodityInfo = commodityInfo;
    vc.groupId = g_groupId;
    vc.staffId = g_staffId;
    vc.commonQuestionTemplateId = g_questionId;
    vc.openRobotInShuntMode = g_openRobotInShuntMode;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self onTapDeleteAtIndexPath:indexPath];
    }
}


#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recentSessionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYSessionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[QYSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    QYPOPSessionInfo *sessionInfo = _recentSessionArray[indexPath.row];
    cell.sessionInfo = sessionInfo;
    
    return cell;
}


#pragma mark - Delegate
- (void)onTapShopEntrance
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了商铺入口" delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView ysf_showWithCompletion:nil];
}

- (void)onTapSessionListEntrance
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSessionListChanged
{
    [self reloadData];
}

- (void)onReceiveMessage:(QYPOPMessageInfo *)message
{
    NSString *messageString = [NSString stringWithFormat:@"shopid: %@\navatarImageUrlString: %@\nsessionName: %@\nlastMessageText: %@\nlastMessageTimeStamp: %lf",
                        message.shopId, message.avatarImageUrlString, message.sender,
                        message.text, message.timeStamp];
    
   [self.view ysf_makeToast:messageString duration:2.0 position:YSFToastPositionCenter];
}


#pragma mark - Private Method
- (void)onTapDeleteAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath) {
        return;
    }
    [[[QYSDK sharedSDK] conversationManager] deleteRecentSessionByShopId:_recentSessionArray[indexPath.row].shopId deleteMessages:[[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoShopInfoOnNeedDeleteChatHistory]];
    [self reloadData];
}

















@end

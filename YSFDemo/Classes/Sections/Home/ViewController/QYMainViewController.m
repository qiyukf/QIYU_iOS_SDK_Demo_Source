//
//  ViewController.m
//  YSFDemo
//
//  Created by amao on 8/25/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "QYMainViewController.h"
#import "QYPOPSDK.h"
#import "QYDemoBadgeView.h"
#import "QYLogViewController.h"
#import "UIView+YSFToast.h"
#import "QYUserTableViewController.h"
#import "QYDetailViewController.h"
#import "UIView+YSF.h"
#import "UIAlertView+YSF.h"
#import "QYSettingViewController.h"
#import "QYSessionListViewController.h"


@interface QYMainViewController () <QYConversationManagerDelegate, QYSessionViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *h1;
@property (strong, nonatomic) IBOutlet UIImageView *h2;
@property (strong, nonatomic) IBOutlet UIImageView *h3;
@property (strong, nonatomic) IBOutlet UIImageView *h4;
@property (strong, nonatomic) YSFDemoBadgeView *badgeView;

@end

@implementation QYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"七鱼金融";
    
    UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectZero];
    contactButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [contactButton setTitle:@"联系客服" forState:UIControlStateNormal];
    [contactButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(onChat:) forControlEvents:UIControlEventTouchUpInside];
    [contactButton sizeToFit];
    contactButton.ysf_frameTop = 8;
    UIButton *rightButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
    [rightButtonView addSubview:contactButton];
    _badgeView = [[YSFDemoBadgeView alloc] initWithFrame:CGRectMake(-20, 3, 50, 50)];
    [rightButtonView addSubview:_badgeView];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onTap1:)];
    [_h1 addGestureRecognizer:tapRecognizer1];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onTap2:)];
    [_h2 addGestureRecognizer:tapRecognizer2];
    
    UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onTap1:)];
    [_h3 addGestureRecognizer:tapRecognizer3];
    
    UITapGestureRecognizer *tapRecognizer4 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onTap2:)];
    [_h4 addGestureRecognizer:tapRecognizer4];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    [self configBadgeView];
}

#pragma mark - 事件处理
- (void)onChat:(id)sender {
    
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.delegate = self;
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    sessionViewController.groupId = g_groupId;
    sessionViewController.staffId = g_staffId;
    sessionViewController.commonQuestionTemplateId = g_questionId;
    sessionViewController.openRobotInShuntMode = g_openRobotInShuntMode;
    
    if (iPadDevice) {
        UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
        navi.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        sessionViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sessionViewController animated:YES];
    }
    
    [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
}

- (void)onTapShopEntrance
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了商铺入口" delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView ysf_showWithCompletion:nil];
}

- (void)onTapSessionListEntrance
{
    QYSessionListViewController *vc = [QYSessionListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTap1:(UIGestureRecognizer *)recognizer
{
    QYDetailViewController *vc = [[QYDetailViewController alloc] init];
    vc.firstOrSecond = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTap2:(UIGestureRecognizer *)recognizer
{
    QYDetailViewController *vc = [[QYDetailViewController alloc] init];
    vc.firstOrSecond = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configBadgeView
{
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [_badgeView setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",count];
    [_badgeView setBadgeValue:value];
}

- (void)onUnreadCountChanged:(NSInteger)count
{
    [self configBadgeView];
}

@end

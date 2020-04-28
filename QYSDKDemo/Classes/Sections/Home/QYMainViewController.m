//
//  ViewController.m
//  YSFDemo
//
//  Created by amao on 8/25/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "QYMainViewController.h"
#import "QYDemoBadgeView.h"
#import "QYLogViewController.h"
#import "UIView+YSFToast.h"
#import "QYUserTableViewController.h"
#import "QYDetailViewController.h"
#import "UIView+YSF.h"
#import "QYSettingViewController.h"
#import "QYSessionListViewController.h"
#import "QYDemoConfig.h"
#import "QYSettingData.h"
#import "QYMacro.h"
#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYPOPSDK.h>


@interface QYMainViewController () <QYConversationManagerDelegate, QYSessionViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *h1;
@property (strong, nonatomic) IBOutlet UIImageView *h2;
@property (strong, nonatomic) IBOutlet UIImageView *h3;
@property (strong, nonatomic) IBOutlet UIImageView *h4;
@property (strong, nonatomic) YSFDemoBadgeView *badgeView;
@property (nonatomic, copy) NSString *key;

@end


@implementation QYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.key = [[NSUUID UUID] UUIDString];
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
    _badgeView.hidden = YES;
    [rightButtonView addSubview:_badgeView];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap1:)];
    [_h1 addGestureRecognizer:tapRecognizer1];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap2:)];
    [_h2 addGestureRecognizer:tapRecognizer2];
    
    UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap3:)];
    [_h3 addGestureRecognizer:tapRecognizer3];
    
    UITapGestureRecognizer *tapRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap4:)];
    [_h4 addGestureRecognizer:tapRecognizer4];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[QYSDK sharedSDK] trackHistory:@"七鱼金融" enterOrOut:YES key:_key];
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    [self configBadgeView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[QYSDK sharedSDK] trackHistory:@"七鱼金融" enterOrOut:NO key:_key];
    self.key = [[NSUUID UUID] UUIDString];
}

#pragma mark - 事件处理
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
    __weak typeof(self) weakSelf = self;
    /**
     * 创建QYSessionViewController
     */
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.delegate = self;
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    //请求客服参数
    sessionViewController.groupId = [QYSettingData sharedData].groupId;
    sessionViewController.staffId = [QYSettingData sharedData].staffId;
    sessionViewController.robotId = [QYSettingData sharedData].robotId;
    sessionViewController.vipLevel = [QYSettingData sharedData].vipLevel;
    sessionViewController.commonQuestionTemplateId = [QYSettingData sharedData].questionTemplateId;
    sessionViewController.robotWelcomeTemplateId = [QYSettingData sharedData].robotWelcomeTemplateId;
    sessionViewController.openRobotInShuntMode = [QYSettingData sharedData].openRobotInShuntMode;
    [[QYSettingData sharedData] resetEntranceParameter];
    /**
     * bot消息url类型action
     */
    [[QYSDK sharedSDK] customActionConfig].botClick = ^(NSString *target, NSString *params) {
        NSString *tip = [NSString stringWithFormat:@"target: %@\nparams: %@", QYStrParam(target), QYStrParam(params)];
        [weakSelf showToast:tip];
    };
    /**
     * push消息点击
     */
    [[QYSDK sharedSDK] customActionConfig].pushMessageClick = ^(NSString *actionUrl) {
        NSString *tip = [NSString stringWithFormat:@"actionUrl: %@", QYStrParam(actionUrl)];
        [weakSelf showToast:tip];
    };
    /**
     * 自定义事件按钮点击
     */
    [[QYSDK sharedSDK] customActionConfig].customButtonClickBlock = ^(NSDictionary *dict) {
        NSString *toast = @"您点击了自定义事件按钮\n";
        id data = [dict objectForKey:@"data"];
        if (data && [data isKindOfClass:[NSString class]] && ((NSString *)data).length) {
            toast = [toast stringByAppendingString:[NSString stringWithFormat:@"数据：%@", data]];
        } else {
            toast = [toast stringByAppendingString:@"未传数据"];
        }
        [weakSelf showToast:toast];
    };
    /**
     * push/present
     */
    if (iPadDevice) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(onBack:)];
        sessionViewController.navigationItem.leftBarButtonItem = item;
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        sessionViewController.hidesBottomBarWhenPushed = YES;
        if ([QYSettingData sharedData].isPushMode) {
            [self.navigationController pushViewController:sessionViewController animated:YES];
        } else {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
            sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                                                      style:UIBarButtonItemStylePlain
                                                                                                     target:self
                                                                                                     action:@selector(onBack:)];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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

- (IBAction)onTap1:(UIGestureRecognizer *)recognizer {
    QYDetailViewController *vc = [[QYDetailViewController alloc] init];
    vc.index = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTap2:(UIGestureRecognizer *)recognizer {
    QYDetailViewController *vc = [[QYDetailViewController alloc] init];
    vc.index = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTap3:(UIGestureRecognizer *)recognizer {
    QYDetailViewController *vc = [[QYDetailViewController alloc] init];
    vc.index = 3;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTap4:(UIGestureRecognizer *)recognizer {
    QYDetailViewController *vc = [[QYDetailViewController alloc] init];
    vc.index = 4;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configBadgeView {
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [_badgeView setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%ld",(long)count];
    [_badgeView setBadgeValue:value];
}

- (void)onUnreadCountChanged:(NSInteger)count {
    [self configBadgeView];
}

- (void)showToast:(NSString *)toast {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC.view ysf_makeToast:toast duration:2.0 position:YSFToastPositionCenter];
}

@end

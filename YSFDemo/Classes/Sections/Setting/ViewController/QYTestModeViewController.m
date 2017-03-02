//
//  QYTestModeViewController.m
//  YSFDemo
//
//  Created by JackyYu on 2016/12/12.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "QYTestModeViewController.h"
#import "QYPOPSDK.h"
#import "QYSource.h"
#import "QYCommodityInfo.h"
#import "QYCustomUIConfig.h"
#import "QYCommodityInfoViewController.h"
#import "QYShopInfoViewController.h"
#import "QYTestModeViewController.h"
#import "UIView+YSFToast.h"
#import "UIAlertView+YSF.h"
#import "QYSessionListViewController.h"
#import "QYSettingViewController.h"


@interface QYTestModeViewController ()<QYSessionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *commodityInfoSettingButton;
@property (weak, nonatomic) IBOutlet UIButton *shopInfoSettingButton;






@end

@implementation QYTestModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    
}

- (void)initData
{
    [_chatButton addTarget:self action:@selector(onTapChatButton:) forControlEvents:UIControlEventTouchUpInside];
    [_commodityInfoSettingButton addTarget:self action:@selector(onTapcommodityInfoSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    [_shopInfoSettingButton addTarget:self action:@selector(onTapshopInfoSettingButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapChatButton:(id)sender
{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    
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
    vc.sessionTitle = @"七鱼金融";
    vc.shopId = [[NSUserDefaults standardUserDefaults] valueForKey:YSFDemoShopInfoShopId];
    vc.delegate = self;
    vc.source = source;
    vc.commodityInfo = commodityInfo;
    vc.groupId = g_groupId;
    vc.staffId = g_staffId;
    vc.commonQuestionTemplateId = g_questionId;
    vc.openRobotInShuntMode = g_openRobotInShuntMode;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
    [QYCustomUIConfig sharedInstance].showAudioEntry = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowAudio];
    [QYCustomUIConfig sharedInstance].showAudioEntryInRobotMode = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowAudioInRobotMode];
    [QYCustomUIConfig sharedInstance].showEmoticonEntry = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowEmoticon];
    [QYCustomUIConfig sharedInstance].autoShowKeyboard = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowKeyboard];
    [QYCustomUIConfig sharedInstance].showShopEntrance = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoShopInfoOnShowShopEntrance];
    [self setShopEntranceImage];
    [QYCustomUIConfig sharedInstance].shopEntranceText = [[NSUserDefaults standardUserDefaults] valueForKey:YSFDemoShopInfoShopName];
    [QYCustomUIConfig sharedInstance].showSessionListEntrance = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoShopInfoOnShowSessionListEntrance];;
    [QYCustomUIConfig sharedInstance].sessionListEntrancePosition = ![[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoShopInfoOnSessionListEntrancePosition];
    [self setSessionListEntranceImage];
}

- (void)setShopEntranceImage
{
    float value = [[NSUserDefaults standardUserDefaults] floatForKey:YSFDemoShopInfoOnShopEntranceIconValue];
    if (value > 0.9) {
        [QYCustomUIConfig sharedInstance].shopEntranceImage = [UIImage imageNamed:@"service_head"];
    } else if (value > 0.5) {
        [QYCustomUIConfig sharedInstance].shopEntranceImage = [UIImage imageNamed:@"customer_head"];
    } else if (value > 0.2) {
        [QYCustomUIConfig sharedInstance].shopEntranceImage = [UIImage imageNamed:@"icon_homepage_selected"];
    } else {
        [QYCustomUIConfig sharedInstance].shopEntranceImage = nil;
    }
}

- (void)setSessionListEntranceImage
{
    float value = [[NSUserDefaults standardUserDefaults] floatForKey:YSFDemoShopInfoOnSessionListEntranceIconValue];
    if (value > 0.9) {
        [QYCustomUIConfig sharedInstance].sessionListEntranceImage = [UIImage imageNamed:@"service_head"];
    } else if (value > 0.5) {
        [QYCustomUIConfig sharedInstance].sessionListEntranceImage = [UIImage imageNamed:@"customer_head"];
    } else if (value > 0.2) {
        [QYCustomUIConfig sharedInstance].sessionListEntranceImage = [UIImage imageNamed:@"icon_homepage_selected"];
    } else {
        [QYCustomUIConfig sharedInstance].sessionListEntranceImage = nil;
    }
}






#pragma mark - onTapEvent

- (void)onTapcommodityInfoSettingButton:(id)sender
{
    QYCommodityInfoViewController *vc = [QYCommodityInfoViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTapshopInfoSettingButton:(id)sender
{
    QYShopInfoViewController *vc = [QYShopInfoViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Delegates

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








@end

//
//  YSFUserTableViewController.m
//  YSFDemo
//
//  Created by amao on 9/9/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "QYUserTableViewController.h"
#import "UIView+YSFToast.h"
#import "UIView+YSF.h"
#import "YSFCommonTableData.h"
#import "YSFCommonTableDelegate.h"
#import "YSFCommonTableViewCell.h"
#import "QYReportUserInfoViewController.h"
#import "NSString+QY.h"
#import "QYCommonCell.h"
#import "QYDemoConfig.h"
#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYSDK.h>


BOOL isTestMode = NO;

static NSString * const kQYUserCellIdentifier = @"kQYUserCellIdentifier";


@interface QYUserTableViewController () <UITableViewDataSource, UITableViewDelegate, QYCommonCellActionDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation QYUserTableViewController
- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QYChangeUserInfoNotificationKey object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.key = [[NSUUID UUID] UUIDString];
    self.navigationItem.title = @"用户信息";
    //dataSource
    QYUserInfoType type = [self buildData];
    //table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    //注销
    _logoutBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _logoutBtn.backgroundColor = [UIColor systemRedColor];
    _logoutBtn.layer.cornerRadius = 2.0f;
    _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    [_logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logoutBtn];
    
    _logoutBtn.ysf_frameSize = CGSizeMake(300, 40);
    _logoutBtn.ysf_frameTop = self.view.ysf_frameHeight - 120;
    _logoutBtn.ysf_frameCenterX = (self.view.ysf_frameWidth / 2);
    if ([QYDemoConfig sharedConfig].isFusion) {
        _logoutBtn.hidden = YES;
    } else {
        _logoutBtn.hidden = (type == QYUserInfoTypeNone);
    }
    
    //增加测试模式
    UITapGestureRecognizer *testTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testTap:)];
    testTap.numberOfTapsRequired = 10;
    [self.view addGestureRecognizer:testTap];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChangeUserInfo:)
                                                 name:QYChangeUserInfoNotificationKey
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[QYSDK sharedSDK] trackHistory:@"用户信息" enterOrOut:YES key:self.key];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[QYSDK sharedSDK] trackHistory:@"用户信息" enterOrOut:NO key:self.key];
    self.key = [[NSUUID UUID] UUIDString];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (QYUserInfoType)buildData {
    NSString *info = [QYDemoConfig sharedConfig].isFusion ? @"用户信息" : @"帐号";
    
    QYUserInfoType type = QYUserInfoTypeNone;
    NSString *curForeignId = [[QYSDK sharedSDK] performSelector:@selector(currentForeignUserId)];
    NSString *customID = [[NSUserDefaults standardUserDefaults] objectForKey:QYCustomUserInfoIDKey];
    
    NSString *name = nil;
    if (curForeignId.length) {
        //1. 若UserDefaults中存有信息，且当前登录的foreignId即为该信息ID，则表明使用了自定义帐号登录，读出name
        //2. 否则判断curForeignId是1-5，分别对应帐号A-E
        if (customID.length && [curForeignId isEqualToString:customID]) {
            type = QYUserInfoTypeCustom;
            NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:QYCustomUserInfoDataKey];
            name = [self.class getNameForUserInfoData:data];
        } else {
            if ([curForeignId isEqualToString:@"1"]) {
                type = QYUserInfoTypeA;
                name = [NSString stringWithFormat:@"%@A", info];
            } else if ([curForeignId isEqualToString:@"2"]) {
                type = QYUserInfoTypeB;
                name = [NSString stringWithFormat:@"%@B", info];
            } else if ([curForeignId isEqualToString:@"3"]) {
                type = QYUserInfoTypeC;
                name = [NSString stringWithFormat:@"%@C", info];
            } else if ([curForeignId isEqualToString:@"4"]) {
                type = QYUserInfoTypeD;
                name = [NSString stringWithFormat:@"%@D", info];
            } else if ([curForeignId isEqualToString:@"5"]) {
                type = QYUserInfoTypeE;
                name = [NSString stringWithFormat:@"%@E", info];
            }
        }
    }
    NSArray *data = @[
        @{
            YSFHeaderTitle:@"",
            YSFRowContent :@[
                    @{
                        YSFStyle : @(YSFCommonCellStyleNormal),
                        YSFTitle : [NSString stringWithFormat:@"当前%@：%@", info, name ? name : @"匿名用户"],
                        YSFDetailTitle : @"非匿名状态下，客服系统可获取到应用上报的用户信息",
                        YSFType : @(QYUserInfoTypeNone),
                        YSFRowHeight : @(50),
                    },
                    
            ],
            YSFFooterTitle:@"",
        },
        
        @{
            YSFHeaderTitle:@"切换为：",
            YSFRowContent :@[
                    @{
                        YSFStyle : @(YSFCommonCellStyleNormal),
                        YSFTitle : [NSString stringWithFormat:@"%@A", info],
                        YSFType : @(QYUserInfoTypeA),
                        YSFExtraInfo : @"1",
                        YSFDisable: @(type == QYUserInfoTypeA),
                    },
                    @{
                        YSFStyle : @(YSFCommonCellStyleNormal),
                        YSFTitle : [NSString stringWithFormat:@"%@B", info],
                        YSFType : @(QYUserInfoTypeB),
                        YSFExtraInfo : @"2",
                        YSFDisable: @(type == QYUserInfoTypeB),
                    },
                    @{
                        YSFStyle : @(YSFCommonCellStyleNormal),
                        YSFTitle : [NSString stringWithFormat:@"%@C", info],
                        YSFType : @(QYUserInfoTypeC),
                        YSFExtraInfo : @"3",
                        YSFDisable: @(type == QYUserInfoTypeC),
                    },
                    @{
                        YSFStyle : @(YSFCommonCellStyleNormal),
                        YSFTitle : [NSString stringWithFormat:@"%@D", info],
                        YSFType : @(QYUserInfoTypeD),
                        YSFExtraInfo : @"4",
                        YSFDisable: @(type == QYUserInfoTypeD),
                    },
                    @{
                        YSFStyle : @(YSFCommonCellStyleNormal),
                        YSFTitle : [NSString stringWithFormat:@"%@E", info],
                        YSFType : @(QYUserInfoTypeE),
                        YSFExtraInfo : @"5",
                        YSFDisable: @(type == QYUserInfoTypeE),
                    },
            ],
            YSFFooterTitle:@""
        },
        
        @{
            YSFHeaderTitle:@"",
            YSFRowContent :@[
                    @{
                        YSFStyle : @(YSFCommonCellStyleNormal),
                        YSFTitle : [NSString stringWithFormat:@"自定义%@", info],
                        YSFType : @(QYUserInfoTypeCustom),
                        YSFShowAccessory : @(YES),
                    },
                    
            ],
            YSFFooterTitle:@"",
        },
    ];
    self.dataSource = [YSFCommonTableSection sectionsWithData:data];
    if ([QYDemoConfig sharedConfig].isFusion) {
        _logoutBtn.hidden = YES;
    } else {
        _logoutBtn.hidden = (type == QYUserInfoTypeNone);
    }
    
    return type;
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
    QYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:kQYUserCellIdentifier];
    if (!cell) {
        cell = [[QYCommonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kQYUserCellIdentifier];
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
    if (rowData.type == QYUserInfoTypeNone) {
        
    } else if (rowData.type == QYUserInfoTypeCustom) {
        QYReportUserInfoViewController *vc = [[QYReportUserInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSString *index = rowData.extraInfo;
        //融合
        if ([QYDemoConfig sharedConfig].isFusion) {
            [QYUserTableViewController selectUserInfoByID:index];
            [self buildData];
            [self.tableView reloadData];
            return;
        }
        //非融合
        NSString *curForeignId = [[QYSDK sharedSDK] performSelector:@selector(currentForeignUserId)];
        if (curForeignId.length) {
            //当前为有名帐号，需调用logout
            [QYUserTableViewController showToast:@"正在注销"];
            __weak typeof(self) weakSelf = self;
            [[QYSDK sharedSDK] logout:^(BOOL success) {
                if (success) {
                    NSString *name = [QYUserTableViewController selectUserInfoByID:index];
                    [QYUserTableViewController showToast:[NSString stringWithFormat:@"已切换为%@", name]];
                    
                    [weakSelf buildData];
                    [weakSelf.tableView reloadData];
                } else {
                    [QYUserTableViewController showToast:@"注销失败"];
                }
            }];
        } else {
            //当前为匿名帐号，无需调用logout
            NSString *name = [QYUserTableViewController selectUserInfoByID:index];
            [QYUserTableViewController showToast:[NSString stringWithFormat:@"已切换为%@", name]];
            
            [self buildData];
            [self.tableView reloadData];
        }
    }
}

+ (NSString *)selectUserInfoByID:(NSString *)userId {
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    //自定义帐号
    NSString *customID = [[NSUserDefaults standardUserDefaults] objectForKey:QYCustomUserInfoIDKey];
    if (customID.length && [userId isEqualToString:customID]) {
        userInfo.userId = customID;
        userInfo.data = [[NSUserDefaults standardUserDefaults] objectForKey:QYCustomUserInfoDataKey];
        NSLog(@"-----%@------",userInfo.data);
        [QYUserTableViewController reportUserInfo:userInfo isCustom:YES];
        return [self.class getNameForUserInfoData:userInfo.data];
    }
    //帐号A-E
    userInfo.userId = userId;
    NSString *name = @"";
    if ([userInfo.userId isEqualToString:@"1"]) {
        name = @"帐号A";
        NSMutableArray *array = [NSMutableArray new];
        NSMutableDictionary *dictRealName = [NSMutableDictionary new];
        [dictRealName setObject:@"real_name" forKey:@"key"];
        [dictRealName setObject:@"边晨" forKey:@"value"];
        [array addObject:dictRealName];
        NSMutableDictionary *dictAvatar = [NSMutableDictionary new];
        [dictAvatar setObject:@"avatar" forKey:@"key"];
        [dictAvatar setObject:@"http://i1.hexunimg.cn/2014-08-15/167580248.jpg" forKey:@"value"];
        [array addObject:dictAvatar];
        NSMutableDictionary *dictMobilePhone = [NSMutableDictionary new];
        [dictMobilePhone setObject:@"mobile_phone" forKey:@"key"];
        [dictMobilePhone setObject:@"13805713536" forKey:@"value"];
        [dictMobilePhone setObject:@(NO) forKey:@"hidden"];
        [array addObject:dictMobilePhone];
        NSMutableDictionary *dictEmail = [NSMutableDictionary new];
        [dictEmail setObject:@"email" forKey:@"key"];
        [dictEmail setObject:@"bianchen@163.com" forKey:@"value"];
        [array addObject:dictEmail];
        NSMutableDictionary *dictAuthentication = [NSMutableDictionary new];
        [dictAuthentication setObject:@(0) forKey:@"index"];
        [dictAuthentication setObject:@"authentication" forKey:@"key"];
        [dictAuthentication setObject:@"实名认证" forKey:@"label"];
        [dictAuthentication setObject:@"已认证" forKey:@"value"];
        [array addObject:dictAuthentication];
        NSMutableDictionary *dictBankcard = [NSMutableDictionary new];
        [dictBankcard setObject:@(1) forKey:@"index"];
        [dictBankcard setObject:@"bankcard" forKey:@"key"];
        [dictBankcard setObject:@"绑定银行卡" forKey:@"label"];
        [dictBankcard setObject:@"622202******01116068" forKey:@"value"];
        [array addObject:dictBankcard];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0
                                                         error:nil];
        if (data) {
            userInfo.data = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
        }
        
    } else if ([userInfo.userId isEqualToString:@"2"]) {
        name = @"帐号B";
        userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"欧阳\"},"
        "{\"key\":\"avatar\", \"value\":\"http://www.274745.cc/imgall/obuwgnjonzuxa2ldfzrw63i/20100121/1396946_104643942888_2.jpg\"},"
        "{\"key\":\"mobile_phone\", \"value\":\"13511250981\", \"hidden\":false},"
        "{\"key\":\"email\", \"value\":\"ouyang@163.com\"},"
        "{\"index\":0, \"key\":\"authentication\", \"label\":\"实名认证\", \"value\":\"未认证\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"622202******01110520\"},"
        "{\"index\":2, \"key\":\"lastorder\", \"label\":\"最近订单\", \"value\":\"七鱼银票（2016010703）\"}]";
    } else if ([userInfo.userId isEqualToString:@"3"]) {
        name = @"帐号C";
        userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"晓彤\"},"
        "{\"key\":\"avatar\", \"value\":\"http://pic33.nipic.com/20130916/3420027_192919547000_2.jpg\"},"
        "{\"key\":\"mobile_phone\", \"value\":\"13503286027\", \"hidden\":false},"
        "{\"key\":\"email\", \"value\":\"xiaotong@163.com\"},"
        "{\"index\":0, \"key\":\"authentication\", \"label\":\"实名认证\", \"value\":\"已认证\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"622202******0111015\"},"
        "{\"index\":2, \"key\":\"lastorder\", \"label\":\"最近订单\", \"value\":\"七鱼银票(2016010702)\"}]";
    } else if ([userInfo.userId isEqualToString:@"4"]) {
        name = @"帐号D";
        userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"雨悦\"},"
        "{\"key\":\"avatar\", \"value\":\"http://photo.enterdesk.com/2010-10-24/enterdesk.com-3B11711A460036C51C19F87E7064FE9D.jpg\"},"
        "{\"key\":\"mobile_phone\", \"value\":\"13509736808\", \"hidden\":false},"
        "{\"key\":\"email\", \"value\":\"yuyue@163.com\"},"
        "{\"index\":0, \"key\":\"authentication\", \"label\":\"实名认证\", \"value\":\"已认证\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"622202******01111125\"}]";
    } else if ([userInfo.userId isEqualToString:@"5"]) {
        name = @"帐号E";
        userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"俞皓\"},"
        "{\"key\":\"avatar\", \"value\":\"http://imgstore.cdn.sogou.com/app/a/100540002/503008.png\"},"
        "{\"key\":\"mobile_phone\", \"value\":\"15106943618\", \"hidden\":false},"
        "{\"key\":\"email\", \"value\":\"yuhao@163.com\"},"
        "{\"index\":0, \"key\":\"authentication\", \"label\":\"实名认证\", \"value\":\"未认证\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"未绑定\"}]";
    }
    NSLog(@"-----%@------",userInfo.data);
    [self.class reportUserInfo:userInfo isCustom:NO];
    
    return name;
}

+ (void)reportUserInfo:(QYUserInfo *)userInfo isCustom:(BOOL)isCustom {
    if ([QYDemoConfig sharedConfig].isFusion) {
        [[QYSDK sharedSDK] setUserInfoForFusion:userInfo
                            userInfoResultBlock:^(BOOL success, NSError *error) {
            NSString *tip = nil;
            if (success) {
                tip = @"用户信息上报成功";
                if (!isCustom) {
                    [QYUserTableViewController removeCustomUserInfo];
                }
                [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = [QYUserTableViewController getAvatarForUserInfoData:userInfo.data];
            } else {
                tip = @"用户信息上报失败";
                if (error.code == QYLocalErrorCodeAccountNeeded) {
                    tip = @"用户信息上报失败\n云信帐号未登录";
                } else if (error.code == QYLocalErrorCodeInvalidUserId) {
                    tip = @"用户信息上报失败\nuserId应与云信帐号相同";
                }
            }
            [QYUserTableViewController showToast:tip];
        }
                           authTokenResultBlock:nil];
    } else {
        [[QYSDK sharedSDK] setUserInfo:userInfo authTokenVerificationResultBlock:nil];
        if (!isCustom) {
            [QYUserTableViewController removeCustomUserInfo];
        }
        [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = [QYUserTableViewController getAvatarForUserInfoData:userInfo.data];
    }
}

//移除存储的自定义用户信息
+ (void)removeCustomUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:QYCustomUserInfoIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:QYCustomUserInfoDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Logout
- (void)logout:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"注销", nil)
                                                                   message:@"注销后返回至匿名帐号，确定要注销吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [QYUserTableViewController showToast:@"正在注销"];
        [[QYSDK sharedSDK] logout:^(BOOL success) {
            if (success) {
                [QYUserTableViewController showToast:@"注销成功"];
                [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = nil;
                //移除存储的自定义用户信息
                [QYUserTableViewController removeCustomUserInfo];
                //reload
                [weakSelf buildData];
                [weakSelf.tableView reloadData];
            } else {
                [QYUserTableViewController showToast:@"注销失败"];
            }
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - QYChangeUserInfoNotificationKey
- (void)onChangeUserInfo:(NSNotification *)notification {
    if (!notification || !notification.object) {
        return;
    }
    if (![notification.object isKindOfClass:[QYUserInfo class]]) {
        return;
    }
    QYUserInfo *userInfo = (QYUserInfo *)notification.object;
    if (userInfo.userId.length) {
        if (![QYDemoConfig sharedConfig].isFusion) {
            NSString *tip = [NSString stringWithFormat:@"帐号ID：%@，姓名：%@", userInfo.userId, [self.class getNameForUserInfoData:userInfo.data]];
            [self.view ysf_makeToast:tip duration:1.5 position:YSFToastPositionCenter title:@"切换成功"];
        }
        
        [self buildData];
        [self.tableView reloadData];
    }
}

+ (NSString *)getNameForUserInfoData:(NSString *)data {
    NSString *name = @"";
    if (data.length) {
        NSArray *array = [data qy_toArray];
        for (NSDictionary *dict in array) {
            NSString *key = [dict objectForKey:@"key"];
            if ([key isEqualToString:@"real_name"]) {
                name = [dict objectForKey:@"value"];
            }
        }
    }
    return name;
}

+ (NSString *)getAvatarForUserInfoData:(NSString *)data {
    NSString *avatar = @"";
    if (data.length) {
        NSArray *array = [data qy_toArray];
        for (NSDictionary *dict in array) {
            NSString *key = [dict objectForKey:@"key"];
            if ([key isEqualToString:@"avatar"]) {
                avatar = [dict objectForKey:@"value"];
            }
        }
    }
    return avatar;
}

#pragma mark - Tap Gesture
- (void)testTap:(id)sender {
    if (!isTestMode) {
        isTestMode = YES;
        [QYUserTableViewController showToast:@"Test Mode"];
    } else {
        isTestMode = NO;
        [QYUserTableViewController showToast:@"Normal Mode"];
    }
}

+ (void)showToast:(NSString *)toast {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC.view ysf_makeToast:toast duration:2.0 position:YSFToastPositionCenter];
}

@end



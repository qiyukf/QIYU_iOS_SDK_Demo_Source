//
//  YSFUserTableViewController.m
//  YSFDemo
//
//  Created by amao on 9/9/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "QYUserTableViewController.h"
#import "QYSDK.h"
#import "UIView+YSFToast.h"
#import "UIView+YSF.h"
#import "YSFCommonTableData.h"
#import "YSFCommonTableDelegate.h"
#import "YSFCommonTableViewCell.h"
#import "QYReportUserInfoViewController.H"
#import "UIAlertView+YSF.h"


@interface YSFUserCell : UITableViewCell<YSFCommonTableViewCell>
@property (assign, nonatomic) NSString *index;
@end

@implementation YSFUserCell

- (void)refreshData:(YSFCommonTableRow *)rowData tableView:(UITableView *)tableView{
    self.textLabel.text    = rowData.title;
    self.detailTextLabel.text = rowData.detailTitle;
    self.index = rowData.extraInfo;
}
@end



@interface QYUserTableViewController ()
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) YSFCommonTableDelegate *delegator;
@property (assign, nonatomic) NSString *userName;
@property (strong, nonatomic) UIButton *logout;

@end

@implementation QYUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"个人信息";
    self.tableView.backgroundColor = YSFColorFromRGB(0xeeeeee);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) wself = self;
    self.delegator = [[YSFCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    
    _logout = [[UIButton alloc] initWithFrame:CGRectZero];
    [_logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logout setTitle:@"注销" forState:UIControlStateNormal];
    _logout.titleLabel.font = [UIFont systemFontOfSize:18];
    _logout.backgroundColor = [UIColor redColor];
    _logout.ysf_frameWidth = 300;
    _logout.ysf_frameHeight = 40;
    _logout.ysf_frameTop = 450;
    _logout.ysf_frameCenterX = self.view.ysf_frameWidth/2;
    [_logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logout];
    
    [self buildData];
    [self.tableView reloadData];
    

}


- (void)buildData
{
    NSString *currentForeignUserId = [[QYSDK sharedSDK] performSelector:@selector(currentForeignUserId)];
    _userName = @"当前账号：匿名用户";
    NSString *name = nil;
    if ([currentForeignUserId isEqualToString:@"1"]) {
        name = @"账号A";
    }
    else if ([currentForeignUserId isEqualToString:@"2"]) {
        name = @"账号B";
    }
    else if ([currentForeignUserId isEqualToString:@"3"]) {
        name = @"账号C";
    }
    else if ([currentForeignUserId isEqualToString:@"4"]) {
        name = @"账号D";
    }
    else if ([currentForeignUserId isEqualToString:@"5"]) {
        name = @"账号E";
    }
    _logout.hidden = name ? NO : YES;
    if (name) {
        _userName = [NSString stringWithFormat:@"当前账号：%@", name];
    }
    
    NSArray *data = @[
                      @{
                          YSFHeaderTitle:@"",
                          YSFRowContent :@[
                                  @{
                                      YSFCellClass  :@"YSFUserCell",
                                      YSFTitle      :_userName,
                                      YSFDetailTitle:@"非匿名状态下，客服系统可获取到应用上报的用户信息",
                                      YSFShowAccessory : @(NO),
                                      },
                                  
                                  ],
                          YSFFooterTitle:@"",
                          },
                      

                      @{
                          YSFHeaderTitle:@"切换为：",
                          YSFHeaderHeight:@(50),
                          YSFRowContent :@[
                                  @{
                                      YSFCellClass  :@"YSFUserCell",
                                      YSFTitle      :@"账号A",
                                      YSFCellAction :@"onSelectRow:",
                                      YSFShowAccessory : @(NO),
                                      YSFExtraInfo:@"1",
                                      YSFDisable:@([currentForeignUserId isEqualToString:@"1"]),
                                      },
                                  @{
                                      YSFCellClass  :@"YSFUserCell",
                                      YSFTitle      :@"账号B",
                                      YSFCellAction :@"onSelectRow:",
                                      YSFShowAccessory : @(NO),
                                      YSFExtraInfo:@"2",
                                      YSFDisable:@([currentForeignUserId isEqualToString:@"2"]),
                                      },
                                  @{
                                      YSFCellClass  :@"YSFUserCell",
                                      YSFTitle      :@"账号C",
                                      YSFCellAction :@"onSelectRow:",
                                      YSFShowAccessory : @(NO),
                                      YSFExtraInfo:@"3",
                                      YSFDisable:@([currentForeignUserId isEqualToString:@"3"]),
                                      },
                                  @{
                                      YSFCellClass  :@"YSFUserCell",
                                      YSFTitle      :@"账号D",
                                      YSFCellAction :@"onSelectRow:",
                                      YSFShowAccessory : @(NO),
                                      YSFExtraInfo:@"4",
                                      YSFDisable:@([currentForeignUserId isEqualToString:@"4"]),
                                      },
                                  @{
                                      YSFCellClass  :@"YSFUserCell",
                                      YSFTitle      :@"账号E",
                                      YSFCellAction :@"onSelectRow:",
                                      YSFShowAccessory : @(NO),
                                      YSFExtraInfo:@"5",
                                      YSFDisable:@([currentForeignUserId isEqualToString:@"5"]),
                                      },
                                  ],
                          YSFFooterTitle:@""
                          },
                      ];
    self.data = [YSFCommonTableSection sectionsWithData:data];
}

- (void)onSelectRow:(YSFUserCell *)sender
{
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = sender.index;
    NSString *name = @"";
    if ([userInfo.userId isEqualToString:@"1"]) {
        name = @"账号A";
        userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"边晨\"},"
                         "{\"key\":\"mobile_phone\", \"value\":\"13805713536\", \"hidden\":false},"
                         "{\"key\":\"email\", \"value\":\"bianchen@163.com\"},"
                         "{\"index\":0, \"key\":\"authentication\", \"label\":\"实名认证\", \"value\":\"已认证\"},"
                        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"622202******01116068\"},"
                        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"最近订单\", \"value\":\"七鱼宝（2016010701）\"}]";

    }
    else if ([userInfo.userId isEqualToString:@"2"]) {
        name = @"账号B";
        userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"欧阳\"},"
        "{\"key\":\"mobile_phone\", \"value\":\"13511250981\", \"hidden\":false},"
        "{\"key\":\"email\", \"value\":\"ouyang@163.com\"},"
        "{\"index\":0, \"key\":\"authentication\", \"label\":\"实名认证\", \"value\":\"未认证\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"622202******01110520\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"最近订单\", \"value\":\"七鱼银票（2016010703）\"}]";
    }
    else if ([userInfo.userId isEqualToString:@"3"]) {
        name = @"账号C";
        userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"晓彤\"},"
        "{\"key\":\"mobile_phone\", \"value\":\"13503286027\", \"hidden\":false},"
        "{\"key\":\"email\", \"value\":\"xiaotong@163.com\"},"
        "{\"index\":0, \"key\":\"authentication\", \"label\":\"实名认证\", \"value\":\"已认证\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"622202******0111015\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"最近订单\", \"value\":\"七鱼银票(2016010702)\"}]";
    }
    else if ([userInfo.userId isEqualToString:@"4"]) {
        name = @"账号D";
        userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"雨悦\"},"
        "{\"key\":\"mobile_phone\", \"value\":\"13509736808\", \"hidden\":false},"
        "{\"key\":\"email\", \"value\":\"yuyue@163.com\"},"
        "{\"index\":0, \"key\":\"authentication\", \"label\":\"实名认证\", \"value\":\"已认证\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"622202******01111125\"}]";
    }
    else if ([userInfo.userId isEqualToString:@"5"]) {
        name = @"账号E";
        userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"俞皓\"},"
        "{\"key\":\"mobile_phone\", \"value\":\"15106943618\", \"hidden\":false},"
        "{\"key\":\"email\", \"value\":\"yuhao@163.com\"},"
        "{\"index\":0, \"key\":\"authentication\", \"label\":\"实名认证\", \"value\":\"未认证\"},"
        "{\"index\":1, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"未绑定\"}]";
    }
    else if ([userInfo.userId isEqualToString:@"6"]) {
        QYReportUserInfoViewController *vc = [[QYReportUserInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [[QYSDK sharedSDK] setUserInfo:userInfo];
    
    NSString *changeAccountTip = [NSString stringWithFormat:@"已切换为%@", name];
    [self.view ysf_makeToast:changeAccountTip
                duration:2
                position:YSFToastPositionCenter];

    [self buildData];
    [self.tableView reloadData];
}

- (void)logout:(id)sender
{
    __weak typeof(self) weakSelf = self;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注销", nil)
                                                    message:@"注销后返回至匿名账号，确定要注销吗？"
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert ysf_showWithCompletion:^(NSInteger index)
     {
         if (index == 1) {
             [weakSelf.view ysf_makeToast:@"正在注销" duration:2
                             position:YSFToastPositionCenter];
             [[QYSDK sharedSDK] logout:^{
                 [weakSelf.view ysf_makeToast:@"注销成功" duration:2
                                 position:YSFToastPositionCenter];
                 
                 [weakSelf buildData];
                 [weakSelf.tableView reloadData];
             }];
         }

     }];
    
    

}

@end



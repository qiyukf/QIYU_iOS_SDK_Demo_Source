//
//  YSFAddAppKeyViewController.m
//  YSFDemo
//
//  Created by amao on 9/24/15.
//  Copyright © 2015 Netease. All rights reserved.
//

#import "QYReportUserInfoViewController.h"
#import "QYSDK.h"

@interface QYReportUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userId;
@property (weak, nonatomic) IBOutlet UITextView *userInfo;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@end


@implementation QYReportUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置个人信息";
}

- (IBAction)onAdd:(id)sender
{
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = _userId.text;
    userInfo.data = _userInfo.text;
    [[QYSDK sharedSDK] setUserInfo:userInfo];
}



@end

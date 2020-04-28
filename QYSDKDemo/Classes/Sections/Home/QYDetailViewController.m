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
#import "QYUserTableViewController.h"
#import "QYDetailViewController.h"
#import "UIView+YSF.h"
#import "QYDemoConfig.h"
#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYSDK.h>


@interface QYDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *h1;
@property (strong, nonatomic) IBOutlet UIImageView *h2;
@property (strong, nonatomic) IBOutlet UIImageView *h4;
@property (strong, nonatomic) UIButton *contact;

@end

@implementation QYDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.index == 1 || self.index == 3) {
        self.navigationItem.title = @"七鱼银票";
        _h1.image = [UIImage imageNamed:@"detail_1"];
    } else {
        self.navigationItem.title = @"七鱼宝";
        _h1.image = [UIImage imageNamed:@"detail_21"];
    }

    _h2.image = [UIImage imageNamed:@"detail_2"];
    _h4.image = [UIImage imageNamed:@"detail_3"];
    
    _contact = [[UIButton alloc] initWithFrame:CGRectZero];
    [_contact setImage:[UIImage imageNamed:@"button_contact"] forState:UIControlStateNormal];
    [_contact sizeToFit];
    [_h4 addSubview:_contact];
    _contact.ysf_frameTop = 155;
    
    [_contact addTarget:self action:@selector(onContact:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews
{
    _contact.ysf_frameWidth = (self.view.ysf_frameWidth - 40)/2;
    _contact.ysf_frameRight = self.view.ysf_frameWidth - 10;
}

#pragma mark - 事件处理
- (IBAction)onContact:(id)sender {
    if (self.index == 3 || self.index == 4) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入客服分配参数" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入客服分组ID";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入客服ID";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入机器人ID";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入常见问题模板ID";
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (alert.textFields.count == 4) {
                UITextField *field_1 = [alert.textFields objectAtIndex:0];
                UITextField *field_2 = [alert.textFields objectAtIndex:1];
                UITextField *field_3 = [alert.textFields objectAtIndex:2];
                UITextField *field_4 = [alert.textFields objectAtIndex:3];
                int64_t groupId = field_1.text.length ? [field_1.text longLongValue] : 0;
                int64_t staffId = field_2.text.length ? [field_2.text longLongValue] : 0;
                int64_t robotId = field_3.text.length ? [field_3.text longLongValue] : 0;
                int64_t templateId = field_4.text.length ? [field_4.text longLongValue] : 0;
                
                [weakSelf onChatWithGroupId:groupId staffId:staffId robotId:robotId templateId:templateId];
            }
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self onChatWithGroupId:0 staffId:0 robotId:0 templateId:0];
    }
}

- (void)onChatWithGroupId:(int64_t)groupId staffId:(int64_t)staffId robotId:(int64_t)robotId templateId:(int64_t)templateId {
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
    
    NSString *title;
    NSString *pageUrl;
    if (self.index == 1 || self.index == 3) {
        title = @"七鱼银票";
        pageUrl = @"https://8.163.com/billList.htm";
    } else {
        title = @"七鱼宝";
        pageUrl = @"https://8.163.com/dqlc/dqlcList.htm";
    }
    
    QYSource *source = [[QYSource alloc] init];
    source.title =  title;
    source.urlString = pageUrl;
    
    QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
    vc.sessionTitle = @"七鱼金融";
    vc.source = source;
    vc.groupId = groupId;
    vc.staffId = staffId;
    vc.robotId = robotId;
    vc.commonQuestionTemplateId = templateId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

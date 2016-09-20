//
//  ViewController.m
//  YSFDemo
//
//  Created by amao on 8/25/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "QYMainViewController.h"
#import "QYSDK.h"
#import "QYDemoBadgeView.h"
#import "QYLogViewController.h"
#import "UIView+YSFToast.h"
#import "QYUserTableViewController.h"
#import "QYDetailViewController.h"
#import "UIVIew+YSF.h"


@interface QYDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *h1;
@property (strong, nonatomic) IBOutlet UIImageView *h2;
@property (strong, nonatomic) IBOutlet UIImageView *h4;
@property (strong, nonatomic) UIButton *contact;

@end

@implementation QYDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    if (_firstOrSecond) {
        self.navigationItem.title = @"七鱼银票";
        _h1.image = [UIImage imageNamed:@"detail_1"];
    }
    else {
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
    
    [_contact addTarget:self action:@selector(onChat:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews
{
    _contact.ysf_frameWidth = (self.view.ysf_frameWidth - 40)/2;
    _contact.ysf_frameRight = self.view.ysf_frameWidth - 10;
}

#pragma mark - 事件处理
- (IBAction)onChat:(id)sender {
    NSString *title;
    NSString *pageUrl;
    if (_firstOrSecond) {
        title = @"七鱼银票";
        pageUrl = @"https://8.163.com/billList.htm";
    }
    else {
        title = @"七鱼宝";
        pageUrl = @"https://8.163.com/dqlc/dqlcList.htm";
    }
    
    QYSource *source = [[QYSource alloc] init];
    source.title =  title;
    source.urlString = pageUrl;
    
    
    QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
    vc.sessionTitle = @"七鱼金融";
    vc.source = source;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

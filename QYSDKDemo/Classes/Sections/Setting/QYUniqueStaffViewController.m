//
//  QYUniqueStaffViewController.m
//  YSFDemo
//
//  Created by liaosipei on 2018/10/18.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QYUniqueStaffViewController.h"
#import "UIView+YSF.h"
#import "UIView+YSFToast.h"
#import "QYSettingViewController.h"
#import "QYDemoConfig.h"
#import "QYSettingData.h"
#import "QYMacro.h"
#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYSDK.h>
#import <IQKeyboardManager/IQKeyboardManager.h>


@interface QYUniqueStaffViewController ()

@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UITextField *idTextField;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UITextField *iconTextField;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITextField *tipTextField;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITextField *descTextField;

@end

@implementation QYUniqueStaffViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专属客服设置";
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [IQKeyboardManager sharedManager].enable = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"联系客服"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onChat:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
                                                          forState:UIControlStateNormal];
    
    self.idLabel = [[UILabel alloc] init];
    self.idLabel.font = [UIFont systemFontOfSize:13];
    self.idLabel.textColor = [UIColor systemGrayColor];
    self.idLabel.numberOfLines = 0;
    self.idLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.idLabel.text = @"客服ID 默认：12345678";
    [self.view addSubview:self.idLabel];
    
    self.idTextField = [[UITextField alloc] init];
    self.idTextField.font = [UIFont systemFontOfSize:14];
    if (@available(iOS 13.0, *)) {
        self.idTextField.textColor = [UIColor labelColor];
    } else {
        self.idTextField.textColor = [UIColor blackColor];
    }
    self.idTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.idTextField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.idTextField.layer.cornerRadius = 4.0f;
    self.idTextField.leftViewMode = UITextFieldViewModeAlways;
    self.idTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    [self.view addSubview:self.idTextField];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.textColor = [UIColor systemGrayColor];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.nameLabel.text = @"昵称 默认：阿满";
    [self.view addSubview:self.nameLabel];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.font = [UIFont systemFontOfSize:14];
    if (@available(iOS 13.0, *)) {
        self.nameTextField.textColor = [UIColor labelColor];
    } else {
        self.nameTextField.textColor = [UIColor blackColor];
    }
    self.nameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameTextField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.nameTextField.layer.cornerRadius = 4.0f;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    [self.view addSubview:self.nameTextField];
    
    self.iconLabel = [[UILabel alloc] init];
    self.iconLabel.font = [UIFont systemFontOfSize:13];
    self.iconLabel.textColor = [UIColor systemGrayColor];
    self.iconLabel.numberOfLines = 0;
    self.iconLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.iconLabel.text = @"头像URL 默认：http://ysf.nosdn.127.net/151029566488C67A9DE6B8C6C1A026ED";
    [self.view addSubview:self.iconLabel];
    
    self.iconTextField = [[UITextField alloc] init];
    self.iconTextField.font = [UIFont systemFontOfSize:14];
    if (@available(iOS 13.0, *)) {
        self.iconTextField.textColor = [UIColor labelColor];
    } else {
        self.iconTextField.textColor = [UIColor blackColor];
    }
    self.iconTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.iconTextField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.iconTextField.layer.cornerRadius = 4.0f;
    self.iconTextField.leftViewMode = UITextFieldViewModeAlways;
    self.iconTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    [self.view addSubview:self.iconTextField];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor systemGrayColor];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.tipLabel.text = @"接入语 默认：专属客服 阿满 为您服务";
    [self.view addSubview:self.tipLabel];
    
    self.tipTextField = [[UITextField alloc] init];
    self.tipTextField.font = [UIFont systemFontOfSize:14];
    if (@available(iOS 13.0, *)) {
        self.tipTextField.textColor = [UIColor labelColor];
    } else {
        self.tipTextField.textColor = [UIColor blackColor];
    }
    self.tipTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tipTextField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.tipTextField.layer.cornerRadius = 4.0f;
    self.tipTextField.leftViewMode = UITextFieldViewModeAlways;
    self.tipTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    [self.view addSubview:self.tipTextField];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:13];
    self.descLabel.textColor = [UIColor systemGrayColor];
    self.descLabel.numberOfLines = 0;
    self.descLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.descLabel.text = @"描述信息 默认：系统提示：当前用户选择了专属客服，客服昵称【阿满】，客服标签【XXX】，服务时请披好马甲";
    [self.view addSubview:self.descLabel];
    
    self.descTextField = [[UITextField alloc] init];
    self.descTextField.font = [UIFont systemFontOfSize:14];
    if (@available(iOS 13.0, *)) {
        self.descTextField.textColor = [UIColor labelColor];
    } else {
        self.descTextField.textColor = [UIColor blackColor];
    }
    self.descTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.descTextField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.descTextField.layer.cornerRadius = 4.0f;
    self.descTextField.leftViewMode = UITextFieldViewModeAlways;
    self.descTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    [self.view addSubview:self.descTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (self.unreadCount) {
        [self onChat:nil];
    }
}

- (void)viewWillLayoutSubviews {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat topSpace = 10;
    CGFloat bottomSpace_1 = 3;
    CGFloat bottomSpace_2 = 10;
    CGFloat leftSpace_label = 22;
    CGFloat leftSpace_field = 20;
    CGFloat fieldHeight = 35;
    
    CGFloat label_w = (width - 2 * leftSpace_label);
    CGFloat field_w = (width - 2 * leftSpace_field);
    
    self.idLabel.ysf_frameLeft = leftSpace_label;
    self.idLabel.ysf_frameTop = YSFNavigationBarHeight + topSpace;
    self.idLabel.ysf_frameWidth = label_w;
    [self.idLabel sizeToFit];
    self.idTextField.frame = CGRectMake(leftSpace_field, ceilf(CGRectGetMaxY(self.idLabel.frame) + bottomSpace_1), field_w, fieldHeight);
    
    self.nameLabel.ysf_frameLeft = leftSpace_label;
    self.nameLabel.ysf_frameTop = ceilf(CGRectGetMaxY(self.idTextField.frame) + bottomSpace_2);
    self.nameLabel.ysf_frameWidth = label_w;
    [self.nameLabel sizeToFit];
    self.nameTextField.frame = CGRectMake(leftSpace_field, ceilf(CGRectGetMaxY(self.nameLabel.frame) + bottomSpace_1), field_w, fieldHeight);
    
    self.iconLabel.ysf_frameLeft = leftSpace_label;
    self.iconLabel.ysf_frameTop = ceilf(CGRectGetMaxY(self.nameTextField.frame) + bottomSpace_2);
    self.iconLabel.ysf_frameWidth = label_w;
    [self.iconLabel sizeToFit];
    self.iconTextField.frame = CGRectMake(leftSpace_field, ceilf(CGRectGetMaxY(self.iconLabel.frame) + bottomSpace_1), field_w, fieldHeight);
    
    self.tipLabel.ysf_frameLeft = leftSpace_label;
    self.tipLabel.ysf_frameTop = ceilf(CGRectGetMaxY(self.iconTextField.frame) + bottomSpace_2);
    self.tipLabel.ysf_frameWidth = label_w;
    [self.tipLabel sizeToFit];
    self.tipTextField.frame = CGRectMake(leftSpace_field, ceilf(CGRectGetMaxY(self.tipLabel.frame) + bottomSpace_1), field_w, fieldHeight);
    
    self.descLabel.ysf_frameLeft = leftSpace_label;
    self.descLabel.ysf_frameTop = ceilf(CGRectGetMaxY(self.tipTextField.frame) + bottomSpace_2);
    self.descLabel.ysf_frameWidth = label_w;
    [self.descLabel sizeToFit];
    self.descTextField.frame = CGRectMake(leftSpace_field, ceilf(CGRectGetMaxY(self.descLabel.frame) + bottomSpace_1), field_w, fieldHeight);
}

#pragma mark - Notification
- (void)keyboardWillChangeFrame:(NSNotification *)note{
    // 取出键盘最终的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘弹出需要花费的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 修改transform
    [UIView animateWithDuration:duration animations:^{
        if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        } else {
            CGRect firstRect = [self firstResponderTextFieldRect];
            CGFloat rest_y = (CGRectGetMaxY(firstRect) + rect.size.height) - [UIScreen mainScreen].bounds.size.height;
            if (rest_y > 0) {
                rest_y += 5;
                self.view.transform = CGAffineTransformMakeTranslation(0, -rest_y);
            } else {
                self.view.transform = CGAffineTransformMakeTranslation(0, 0);
            }
        }
    }];
}

- (CGRect)firstResponderTextFieldRect {
    if (_idTextField.isFirstResponder) {
        return _idTextField.frame;
    } else if (_nameTextField.isFirstResponder) {
        return _nameTextField.frame;
    } else if (_iconTextField.isFirstResponder) {
        return _iconTextField.frame;
    } else if (_tipTextField.isFirstResponder) {
        return _tipTextField.frame;
    } else if (_descTextField.isFirstResponder) {
        return _descTextField.frame;
    }
    return CGRectZero;
}

#pragma mark - Action
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
    /**
     * 创建QYSessionViewController
     */
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"专属客服";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"专属客服";
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
    //收起历史消息
    sessionViewController.hideHistoryMessages = [QYSettingData sharedData].hideHistoryMsg;
    sessionViewController.historyMessagesTip = [QYSettingData sharedData].historyMsgTip;
    /**
     * 客服信息staffInfo
     */
    QYStaffInfo *staffInfo = [[QYStaffInfo alloc] init];
    staffInfo.staffId = self.idTextField.text.length ? self.idTextField.text : @"12345678";
    staffInfo.nickName = self.nameTextField.text.length ? self.nameTextField.text : @"阿满";
    staffInfo.iconURL = self.iconTextField.text.length ? self.iconTextField.text : @"http://ysf.nosdn.127.net/151029566488C67A9DE6B8C6C1A026ED";
    staffInfo.accessTip = self.tipTextField.text.length ? self.tipTextField.text : @"专属客服 阿满 为您服务";
    staffInfo.infoDesc = self.descTextField.text.length ? self.descTextField.text : @"系统提示：当前用户选择了专属客服，客服昵称【阿满】，客服标签【XXX】，服务时请披好马甲";
    sessionViewController.staffInfo = staffInfo;
    /**
     * push
     */
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionViewController animated:YES];
}

- (void)showToast:(NSString *)toast {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC.view ysf_makeToast:toast duration:2.0 position:YSFToastPositionCenter];
}

@end

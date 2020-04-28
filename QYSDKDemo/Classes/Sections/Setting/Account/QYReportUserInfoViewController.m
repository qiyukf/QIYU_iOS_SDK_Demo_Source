//
//  YSFAddAppKeyViewController.m
//  YSFDemo
//
//  Created by amao on 9/24/15.
//  Copyright © 2015 Netease. All rights reserved.
//

#import "QYReportUserInfoViewController.h"
#import "UIView+YSF.h"
#import "UIView+YSFToast.h"
#import "NSString+QY.h"
#import "QYDemoConfig.h"
#import "QYMacro.h"
#import <QYSDK/QYSDK.h>
#import <IQKeyboardManager/IQKeyboardManager.h>


NSString *const QYChangeUserInfoNotificationKey = @"QYChangeUserInfoNotificationKey";
NSString *const QYCustomUserInfoIDKey = @"QYCustomUserInfoIDKey";
NSString *const QYCustomUserInfoDataKey = @"QYCustomUserInfoDataKey";


@interface QYReportUserInfoViewController ()

@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UITextField *idTextField;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UITextField *iconTextField;

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UITextField *emailTextField;

@property (nonatomic, strong) UIButton *changeButton;

@end


@implementation QYReportUserInfoViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [QYDemoConfig sharedConfig].isFusion ? @"自定义用户信息" : @"自定义帐号";
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [IQKeyboardManager sharedManager].enable = NO;
    
    self.idLabel = [[UILabel alloc] init];
    self.idLabel.font = [UIFont systemFontOfSize:13];
    self.idLabel.textColor = [UIColor systemGrayColor];
    self.idLabel.numberOfLines = 0;
    self.idLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.idLabel.text = @"帐号ID（必须）";
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
    self.nameLabel.text = @"姓名（默认：无）";
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
    self.iconLabel.text = @"头像URL（默认：无）";
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
    
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.font = [UIFont systemFontOfSize:13];
    self.phoneLabel.textColor = [UIColor systemGrayColor];
    self.phoneLabel.numberOfLines = 0;
    self.phoneLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.phoneLabel.text = @"电话号码（默认：无）";
    [self.view addSubview:self.phoneLabel];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.font = [UIFont systemFontOfSize:14];
    if (@available(iOS 13.0, *)) {
        self.phoneTextField.textColor = [UIColor labelColor];
    } else {
        self.phoneTextField.textColor = [UIColor blackColor];
    }
    self.phoneTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.phoneTextField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.phoneTextField.layer.cornerRadius = 4.0f;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    [self.view addSubview:self.phoneTextField];
    
    self.emailLabel = [[UILabel alloc] init];
    self.emailLabel.font = [UIFont systemFontOfSize:13];
    self.emailLabel.textColor = [UIColor systemGrayColor];
    self.emailLabel.numberOfLines = 0;
    self.emailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.emailLabel.text = @"电子邮箱（默认：无）";
    [self.view addSubview:self.emailLabel];
    
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.font = [UIFont systemFontOfSize:14];
    if (@available(iOS 13.0, *)) {
        self.emailTextField.textColor = [UIColor labelColor];
    } else {
        self.emailTextField.textColor = [UIColor blackColor];
    }
    self.emailTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.emailTextField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.emailTextField.layer.cornerRadius = 4.0f;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    [self.view addSubview:self.emailTextField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:([QYDemoConfig sharedConfig].isFusion ? @"上报" : @"切换")
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onChangeUserInfo:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
                                                          forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
    
    self.phoneLabel.ysf_frameLeft = leftSpace_label;
    self.phoneLabel.ysf_frameTop = ceilf(CGRectGetMaxY(self.iconTextField.frame) + bottomSpace_2);
    self.phoneLabel.ysf_frameWidth = label_w;
    [self.phoneLabel sizeToFit];
    self.phoneTextField.frame = CGRectMake(leftSpace_field, ceilf(CGRectGetMaxY(self.phoneLabel.frame) + bottomSpace_1), field_w, fieldHeight);
    
    self.emailLabel.ysf_frameLeft = leftSpace_label;
    self.emailLabel.ysf_frameTop = ceilf(CGRectGetMaxY(self.phoneTextField.frame) + bottomSpace_2);
    self.emailLabel.ysf_frameWidth = label_w;
    [self.emailLabel sizeToFit];
    self.emailTextField.frame = CGRectMake(leftSpace_field, ceilf(CGRectGetMaxY(self.emailLabel.frame) + bottomSpace_1), field_w, fieldHeight);
    
    self.changeButton.ysf_frameWidth = 300;
    self.changeButton.ysf_frameHeight = 40;
    self.changeButton.ysf_frameTop = ceilf(CGRectGetMaxY(self.emailTextField.frame) + bottomSpace_2 * 2);
    self.changeButton.ysf_frameCenterX = width / 2;
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
    } else if (_phoneTextField.isFirstResponder) {
        return _phoneTextField.frame;
    } else if (_emailTextField.isFirstResponder) {
        return _emailTextField.frame;
    }
    return CGRectZero;
}

#pragma mark - Action
- (void)onChangeUserInfo:(id)sender {
    if (!self.idTextField.text.length) {
        [self.view ysf_makeToast:@"请设置帐号ID" duration:2 position:YSFToastPositionCenter title:@"切换失败"];
        return;
    }
    //融合
    if ([QYDemoConfig sharedConfig].isFusion) {
        [self changeAccount];
        return;
    }
    //非融合
    NSString *curForeignId = [[QYSDK sharedSDK] performSelector:@selector(currentForeignUserId)];
    if (curForeignId.length) {
        //当前为有名帐号，需调用logout
        [self.view ysf_makeToast:@"正在注销" duration:2 position:YSFToastPositionCenter];
        __weak typeof(self) weakSelf = self;
        [[QYSDK sharedSDK] logout:^(BOOL success) {
            if (success) {
                [weakSelf changeAccount];
            } else {
                [weakSelf.view ysf_makeToast:@"注销失败" duration:2 position:YSFToastPositionCenter];
            }
        }];
    } else {
        //当前为匿名帐号，无需调用logout
        [self changeAccount];
    }
}

- (void)changeAccount {
    QYUserInfo *info = [[QYUserInfo alloc] init];
    info.userId = self.idTextField.text;
    
    NSMutableArray *array = [NSMutableArray array];
    //姓名
    if (self.nameTextField.text.length) {
        NSDictionary *nameDict = @{
                                   @"key" : @"real_name",
                                   @"value" : self.nameTextField.text,
                                   };
        [array addObject:nameDict];
    }
    //头像
    if (self.iconTextField.text.length) {
        NSDictionary *avatarDict = @{
                                     @"key" : @"avatar",
                                     @"value" : self.iconTextField.text,
                                     };
        [array addObject:avatarDict];
    }
    //电话号码
    if (self.phoneTextField.text.length) {
        NSDictionary *phoneDict = @{
                                    @"key" : @"mobile_phone",
                                    @"value" : self.phoneTextField.text,
                                    @"hidden" : @(NO),
                                    };
        [array addObject:phoneDict];
    }
    //邮件
    if (self.emailTextField.text.length) {
        NSDictionary *emailDict = @{
                                    @"key" : @"email",
                                    @"value" : self.emailTextField.text,
                                    };
        [array addObject:emailDict];
    }
    NSData *data = nil;
    if ([array count]) {
        data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    }
    if (data) {
        info.data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    //上报UserInfo
    [self reportUserInfo:info];
}

- (void)reportUserInfo:(QYUserInfo *)userInfo {
    if ([QYDemoConfig sharedConfig].isFusion) {
        __weak typeof(self) weakSelf = self;
        [[QYSDK sharedSDK] setUserInfoForFusion:userInfo
                            userInfoResultBlock:^(BOOL success, NSError *error) {
            NSString *tip = nil;
            if (success) {
                tip = @"用户信息上报成功";
                //设置头像
                [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = [weakSelf getAvatarForUserInfoData:userInfo.data];
                //保存数据
                [weakSelf saveCustomUserInfo:userInfo];
                //退出当前页面
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:QYChangeUserInfoNotificationKey object:userInfo];
                });
            } else {
                tip = @"用户信息上报失败";
                if (error.code == QYLocalErrorCodeAccountNeeded) {
                    tip = @"用户信息上报失败\n云信帐号未登录";
                } else if (error.code == QYLocalErrorCodeInvalidUserId) {
                    tip = @"用户信息上报失败\nuserId应与云信帐号相同";
                }
            }
            [weakSelf showToast:tip];
        } authTokenResultBlock:nil];
    } else {
        //上报
        [[QYSDK sharedSDK] setUserInfo:userInfo authTokenVerificationResultBlock:nil];
        //设置头像
        [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = [self getAvatarForUserInfoData:userInfo.data];
        //保存数据
        [self saveCustomUserInfo:userInfo];
        //退出当前页面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:QYChangeUserInfoNotificationKey object:userInfo];
        });
    }
}

//移除存储的自定义用户信息
- (void)saveCustomUserInfo:(QYUserInfo *)info {
    [[NSUserDefaults standardUserDefaults] setObject:info.userId forKey:QYCustomUserInfoIDKey];
    [[NSUserDefaults standardUserDefaults] setObject:info.data forKey:QYCustomUserInfoDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getAvatarForUserInfoData:(NSString *)data {
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

- (void)showToast:(NSString *)toast {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC.view ysf_makeToast:toast duration:2.0 position:YSFToastPositionCenter];
}

@end

//
//  QYTrackViewController.m
//  YSFDemo
//
//  Created by liaosipei on 2018/8/22.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QYTrackViewController.h"
#import <QYSDK/QYSDK.h>

@interface QYTrackViewController ()

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *titleTextView;
@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UITextView *keyTextView1;
@property (nonatomic, strong) UITextView *valueTextView1;
@property (nonatomic, strong) UITextView *keyTextView2;
@property (nonatomic, strong) UITextView *valueTextView2;
@property (nonatomic, strong) UITextView *keyTextView3;
@property (nonatomic, strong) UITextView *valueTextView3;

@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation QYTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行为轨迹";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.key = [[NSUUID UUID] UUIDString];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.text = @"title";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    self.titleTextView = [[UITextView alloc] init];
    self.titleTextView.backgroundColor = [UIColor whiteColor];
    self.titleTextView.font = [UIFont systemFontOfSize:17];
    self.titleTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleTextView.layer.borderWidth = 1.0f;
    self.titleTextView.layer.cornerRadius = 6.0f;
    [self.view addSubview:self.titleTextView];
    
    self.keyLabel = [[UILabel alloc] init];
    self.keyLabel.textColor = [UIColor grayColor];
    self.keyLabel.text = @"key";
    self.keyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.keyLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = [UIColor grayColor];
    self.valueLabel.text = @"value";
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.valueLabel];
    
    self.keyTextView1 = [[UITextView alloc] init];
    self.keyTextView1.backgroundColor = [UIColor whiteColor];
    self.keyTextView1.font = [UIFont systemFontOfSize:17];
    self.keyTextView1.layer.borderColor = [UIColor grayColor].CGColor;
    self.keyTextView1.layer.borderWidth = 1.0f;
    self.keyTextView1.layer.cornerRadius = 6.0f;
    [self.view addSubview:self.keyTextView1];
    
    self.valueTextView1 = [[UITextView alloc] init];
    self.valueTextView1.backgroundColor = [UIColor whiteColor];
    self.valueTextView1.font = [UIFont systemFontOfSize:17];
    self.valueTextView1.layer.borderColor = [UIColor grayColor].CGColor;
    self.valueTextView1.layer.borderWidth = 1.0f;
    self.valueTextView1.layer.cornerRadius = 6.0f;
    [self.view addSubview:self.valueTextView1];
    
    self.keyTextView2 = [[UITextView alloc] init];
    self.keyTextView2.backgroundColor = [UIColor whiteColor];
    self.keyTextView2.font = [UIFont systemFontOfSize:17];
    self.keyTextView2.layer.borderColor = [UIColor grayColor].CGColor;
    self.keyTextView2.layer.borderWidth = 1.0f;
    self.keyTextView2.layer.cornerRadius = 6.0f;
    [self.view addSubview:self.keyTextView2];
    
    self.valueTextView2 = [[UITextView alloc] init];
    self.valueTextView2.backgroundColor = [UIColor whiteColor];
    self.valueTextView2.font = [UIFont systemFontOfSize:17];
    self.valueTextView2.layer.borderColor = [UIColor grayColor].CGColor;
    self.valueTextView2.layer.borderWidth = 1.0f;
    self.valueTextView2.layer.cornerRadius = 6.0f;
    [self.view addSubview:self.valueTextView2];
    
    self.keyTextView3 = [[UITextView alloc] init];
    self.keyTextView3.backgroundColor = [UIColor whiteColor];
    self.keyTextView3.font = [UIFont systemFontOfSize:17];
    self.keyTextView3.layer.borderColor = [UIColor grayColor].CGColor;
    self.keyTextView3.layer.borderWidth = 1.0f;
    self.keyTextView3.layer.cornerRadius = 6.0f;
    [self.view addSubview:self.keyTextView3];
    
    self.valueTextView3 = [[UITextView alloc] init];
    self.valueTextView3.backgroundColor = [UIColor whiteColor];
    self.valueTextView3.font = [UIFont systemFontOfSize:17];
    self.valueTextView3.layer.borderColor = [UIColor grayColor].CGColor;
    self.valueTextView3.layer.borderWidth = 1.0f;
    self.valueTextView3.layer.cornerRadius = 6.0f;
    [self.view addSubview:self.valueTextView3];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendButton];
}

- (void)viewWillLayoutSubviews {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = 40;
    CGFloat spaceW = 10;
    CGFloat spaceH = 15;
    
    self.titleLabel.frame = CGRectMake(0, 100, width, height);
    self.titleTextView.frame = CGRectMake(30, CGRectGetMaxY(self.titleLabel.frame) + 10, width - 60, height);

    CGFloat textViewWidth = (width - 30 * 2 - spaceW) / 2;
    self.keyLabel.frame = CGRectMake(30, CGRectGetMaxY(self.titleTextView.frame) + spaceH, textViewWidth, height);
    self.valueLabel.frame = CGRectMake(CGRectGetMaxX(self.keyLabel.frame) + spaceW, CGRectGetMaxY(self.titleTextView.frame) + spaceH, textViewWidth, height);
    
    self.keyTextView1.frame = CGRectMake(30, CGRectGetMaxY(self.keyLabel.frame) + spaceH, textViewWidth, height);
    self.valueTextView1.frame = CGRectMake(CGRectGetMaxX(self.keyTextView1.frame) + spaceW, CGRectGetMinY(self.keyTextView1.frame), textViewWidth, height);
    self.keyTextView2.frame = CGRectMake(30, CGRectGetMaxY(self.keyTextView1.frame) + spaceH, textViewWidth, height);
    self.valueTextView2.frame = CGRectMake(CGRectGetMaxX(self.keyTextView2.frame) + spaceW, CGRectGetMinY(self.keyTextView2.frame), textViewWidth, height);
    self.keyTextView3.frame = CGRectMake(30, CGRectGetMaxY(self.keyTextView2.frame) + spaceH, textViewWidth, height);
    self.valueTextView3.frame = CGRectMake(CGRectGetMaxX(self.keyTextView3.frame) + spaceW, CGRectGetMinY(self.keyTextView3.frame), textViewWidth, height);
    
    self.sendButton.frame = CGRectMake(150, CGRectGetMaxY(self.valueTextView3.frame) + 60, width - 150 * 2, 45);
}

- (void)clickSendButton:(id)sender {
    NSString *title = nil;
    NSString *message = nil;
    if (_titleTextView.text.length > 0) {
        title = @"上报成功";
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (_keyTextView1.text.length > 0 && _valueTextView1.text.length > 0) {
            [dict setValue:_valueTextView1.text forKey:_keyTextView1.text];
        }
        if (_keyTextView2.text.length > 0 && _valueTextView2.text.length > 0) {
            [dict setValue:_valueTextView2.text forKey:_keyTextView2.text];
        }
        if (_keyTextView3.text.length > 0 && _valueTextView3.text.length > 0) {
            [dict setValue:_valueTextView3.text forKey:_keyTextView3.text];
        }
        [[QYSDK sharedSDK] trackHistory:_titleTextView.text description:dict key:self.key];
    } else {
        title = @"上报失败";
        message = @"请填写title";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  YSFAddAppKeyViewController.m
//  YSFDemo
//
//  Created by amao on 9/24/15.
//  Copyright © 2015 Netease. All rights reserved.
//

#import "QYAddAppKeyViewController.h"

@interface QYAddAppKeyViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *appKeyTextField;
@property (weak, nonatomic) IBOutlet UISwitch *swtich;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation QYAddAppKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"输入AppKey绑定";
    _appKeyTextField.delegate = self;
    _confirm.enabled = NO;
    _confirm.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onAdd:(id)sender
{
    [_delegate onAddAppKey:_appKeyTextField.text isTesting:_swtich.on];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:
                (NSRange)range replacementString:(NSString *)string{
    NSString *genString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _tipLabel.hidden = YES;
    if (genString.length == 32) {
        _confirm.enabled = YES;
        _confirm.backgroundColor = [UIColor redColor];
    }
    else {
        _confirm.enabled = NO;
        _confirm.backgroundColor = [UIColor grayColor];
        if (genString.length > 32) {
            _tipLabel.hidden = NO;
        }
    }
    return YES;
}

@end

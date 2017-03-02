//
//  QYShopInfoViewController.m
//  YSFDemo
//
//  Created by JackyYu on 2016/12/12.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "QYShopInfoViewController.h"
#import "UIView+YSFToast.h"

@interface QYShopInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *shopIdTextView;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextView;
@property (weak, nonatomic) IBOutlet UISwitch *isShowShopEntrance;
@property (weak, nonatomic) IBOutlet UISlider *shopEntranceIcon;
@property (weak, nonatomic) IBOutlet UISwitch *isNeedDeleteChatHistory;
@property (weak, nonatomic) IBOutlet UISwitch *isShowSessionListEntrance;
@property (weak, nonatomic) IBOutlet UISwitch *sessionListEntrancePosition;
@property (weak, nonatomic) IBOutlet UISlider *sessionListEntranceIcon;




@end

@implementation QYShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initData];

}

- (void)initData
{
    _shopIdTextView.text = [[NSUserDefaults standardUserDefaults] valueForKey:YSFDemoShopInfoShopId];
    _shopNameTextView.text = [[NSUserDefaults standardUserDefaults] valueForKey:YSFDemoShopInfoShopName];
    _isShowShopEntrance.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoShopInfoOnShowShopEntrance];
    _isNeedDeleteChatHistory.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoShopInfoOnNeedDeleteChatHistory];
    _isShowSessionListEntrance.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoShopInfoOnShowSessionListEntrance];
    _shopEntranceIcon.value = [[NSUserDefaults standardUserDefaults] floatForKey:YSFDemoShopInfoOnShopEntranceIconValue];
    _sessionListEntrancePosition.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoShopInfoOnSessionListEntrancePosition];
    _sessionListEntranceIcon.value = [[NSUserDefaults standardUserDefaults] floatForKey:YSFDemoShopInfoOnSessionListEntranceIconValue];
    
    [_saveButton addTarget:self action:@selector(onTapSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)onTapSaveButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:_shopIdTextView.text forKey:YSFDemoShopInfoShopId];
    [[NSUserDefaults standardUserDefaults] setValue:_shopNameTextView.text forKey:YSFDemoShopInfoShopName];
    [[NSUserDefaults standardUserDefaults] setBool:_isShowShopEntrance.on forKey:YSFDemoShopInfoOnShowShopEntrance];
    [[NSUserDefaults standardUserDefaults] setFloat:_shopEntranceIcon.value forKey:YSFDemoShopInfoOnShopEntranceIconValue];
    [[NSUserDefaults standardUserDefaults] setBool:_isNeedDeleteChatHistory.on forKey:YSFDemoShopInfoOnNeedDeleteChatHistory];
    [[NSUserDefaults standardUserDefaults] setBool:_isShowSessionListEntrance.on forKey:YSFDemoShopInfoOnShowSessionListEntrance];
    [[NSUserDefaults standardUserDefaults] setBool:_sessionListEntrancePosition.on forKey:YSFDemoShopInfoOnSessionListEntrancePosition];
    [[NSUserDefaults standardUserDefaults] setFloat:_sessionListEntranceIcon.value forKey:YSFDemoShopInfoOnSessionListEntranceIconValue];
    
    [self.view ysf_makeToast:@"保存成功！" duration:1.0 position:YSFToastPositionCenter];
}
















@end

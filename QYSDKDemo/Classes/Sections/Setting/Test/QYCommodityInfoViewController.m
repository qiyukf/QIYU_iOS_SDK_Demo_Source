//
//  QYCommodityInfoViewController.m
//  YSFDemo
//
//  Created by JackyYu on 16/5/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "QYCommodityInfoViewController.h"
#import "UIView+YSFToast.h"
#import "UIColor+YSF.h"
#import "QYSettingViewController.h"
#import "QYDemoConfig.h"
#import "QYSettingData.h"
#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYSDK.h>


@interface QYCommodityInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextView *title1;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UITextView *pictureUrlString;
@property (weak, nonatomic) IBOutlet UITextView *urlString;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UISwitch *show;
@property (weak, nonatomic) IBOutlet UISwitch *sendByUser;
@property (weak, nonatomic) IBOutlet UITextView *actionText;
@property (weak, nonatomic) IBOutlet UITextView *actionTextColor;
@property (weak, nonatomic) IBOutlet UISwitch *custom;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UIButton *go;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *showAudio;
@property (weak, nonatomic) IBOutlet UISwitch *showAudioInRobotMode;
@property (weak, nonatomic) IBOutlet UISwitch *showEmoticon;
@property (weak, nonatomic) IBOutlet UISwitch *showKeyboard;
@property (weak, nonatomic) IBOutlet UITextView *msgId;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgId;
@property (weak, nonatomic) IBOutlet UISwitch *showTabbar;
@property (weak, nonatomic) IBOutlet UITextView *textView1;
@property (weak, nonatomic) IBOutlet UITextView *textView2;
@property (weak, nonatomic) IBOutlet UITextView *textView3;
@property (weak, nonatomic) IBOutlet UITextView *textView4;
@property (weak, nonatomic) IBOutlet UITextView *textView5;
@property (weak, nonatomic) IBOutlet UITextView *textView6;
@property (weak, nonatomic) IBOutlet UITextView *textView7;
@property (weak, nonatomic) IBOutlet UITextView *textView8;
@property (weak, nonatomic) IBOutlet UITextView *textView9;
@property (weak, nonatomic) IBOutlet UITextView *textView10;
@property (weak, nonatomic) IBOutlet UITextView *textView11;
@property (weak, nonatomic) IBOutlet UITextView *textView12;
@property (weak, nonatomic) IBOutlet UISwitch *autoSendInRobot;

@end


@implementation QYCommodityInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self addTarget];
    
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 2048)];
}

- (void)initData {
    _show.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowKey];
    _sendByUser.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoSendByUserKey];
    _actionText.text = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoSendTextKey];
    _actionTextColor.text = [[NSUserDefaults standardUserDefaults] stringForKey:YSFDemoSendTextColorKey];
    _showAudio.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowAudio];
    _showAudioInRobotMode.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowAudioInRobotMode];
    _showEmoticon.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowEmoticon];
    _showKeyboard.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowKeyboard];
    _showTabbar.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowTabbar];
    _autoSendInRobot.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoAutoSendInRobotKey];
}

- (void)addTarget {
    [_show addTarget:self action:@selector(onShow:) forControlEvents:UIControlEventValueChanged];
    [_custom addTarget:self action:@selector(onCustom:) forControlEvents:UIControlEventValueChanged];
    [_sendByUser addTarget:self action:@selector(onSendByUser:) forControlEvents:UIControlEventValueChanged];
    [_showAudio addTarget:self action:@selector(onShowAudio:) forControlEvents:UIControlEventValueChanged];
    [_showAudioInRobotMode addTarget:self action:@selector(onShowAudioInRobotMode:) forControlEvents:UIControlEventValueChanged];
    [_showEmoticon addTarget:self action:@selector(onShowEmoticon:) forControlEvents:UIControlEventValueChanged];
    [_showKeyboard addTarget:self action:@selector(onShowKeyboard:) forControlEvents:UIControlEventValueChanged];
    [_save addTarget:self action:@selector(onSave:) forControlEvents:UIControlEventTouchUpInside];
    [_go addTarget:self action:@selector(onGo:) forControlEvents:UIControlEventTouchUpInside];
    [_sendMsgId addTarget:self action:@selector(onSendMsgId:) forControlEvents:UIControlEventTouchUpInside];
    [_showTabbar addTarget:self action:@selector(onShowTabbar:) forControlEvents:UIControlEventValueChanged];
    [_autoSendInRobot addTarget:self action:@selector(onAutoSendInRobot:) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)onShow:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_show.on forKey:YSFDemoOnShowKey];
}

- (void)onCustom:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_custom.on forKey:YSFDemoCustomKey];
}

- (void)onSendByUser:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_sendByUser.on forKey:YSFDemoSendByUserKey];
}

- (void)onShowAudio:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_showAudio.on forKey:YSFDemoOnShowAudio];
}

- (void)onShowAudioInRobotMode:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_showAudioInRobotMode.on forKey:YSFDemoOnShowAudioInRobotMode];
}

- (void)onShowEmoticon:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_showEmoticon.on forKey:YSFDemoOnShowEmoticon];
}

- (void)onShowKeyboard:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_showKeyboard.on forKey:YSFDemoOnShowKeyboard];
}

- (void)onAutoSendInRobot:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_autoSendInRobot.on forKey:YSFDemoAutoSendInRobotKey];
}

- (void)tap:(id)sender {
    [_title1 resignFirstResponder];
    [_desc resignFirstResponder];
    [_pictureUrlString resignFirstResponder];
    [_urlString resignFirstResponder];
    [_note resignFirstResponder];
}

-(void)onSave:(id)sender {
    if (![_title1.text isEqualToString:@""] && ![_desc.text isEqualToString:@""]
        && ![_pictureUrlString.text isEqualToString:@""] && ![_urlString.text isEqualToString:@""]
        && ![_note.text isEqualToString:@""]) {
    } else {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"有参数未填写"
                                                            message:@"知道了"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"OK", nil];
        [alterView show];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:_title1.text forKey:YSFDemoCommodityInfoTitle];
    [[NSUserDefaults standardUserDefaults] setValue:_desc.text forKey:YSFDemoCommodityInfoDesc];
    [[NSUserDefaults standardUserDefaults] setValue:_pictureUrlString.text forKey:YSFDemoCommodityInfoPictureUrlString];
    [[NSUserDefaults standardUserDefaults] setValue:_urlString.text forKey:YSFDemoCommodityInfoUrlString];
    [[NSUserDefaults standardUserDefaults] setValue:_note.text forKey:YSFDemoCommodityInfoNote];
    [[NSUserDefaults standardUserDefaults] setBool:_show.on forKey:YSFDemoOnShowKey];
    [[NSUserDefaults standardUserDefaults] setBool:_custom.on forKey:YSFDemoCustomKey];
    [[NSUserDefaults standardUserDefaults] setBool:_sendByUser.on forKey:YSFDemoSendByUserKey];
    [[NSUserDefaults standardUserDefaults] setValue:_actionText.text forKey:YSFDemoSendTextKey];
    [[NSUserDefaults standardUserDefaults] setValue:_actionTextColor.text forKey:YSFDemoSendTextColorKey];
    
    [[NSUserDefaults standardUserDefaults] setBool:_showAudio.on forKey:YSFDemoOnShowAudio];
    [[NSUserDefaults standardUserDefaults] setBool:_showAudioInRobotMode.on forKey:YSFDemoOnShowAudioInRobotMode];
    [[NSUserDefaults standardUserDefaults] setBool:_showEmoticon.on forKey:YSFDemoOnShowEmoticon];
    [[NSUserDefaults standardUserDefaults] setBool:_showEmoticon.on forKey:YSFDemoOnShowEmoticon];
    [[NSUserDefaults standardUserDefaults] setBool:_showKeyboard.on forKey:YSFDemoOnShowKeyboard];
    [[NSUserDefaults standardUserDefaults] setBool:_autoSendInRobot.on forKey:YSFDemoAutoSendInRobotKey];
    
    [self.view ysf_makeToast:@"保存成功！" duration:1.0 position:YSFToastPositionCenter];
}

- (void)onGo:(id)sender {
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
    source.title =  @"商品信息";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionVC = [[QYSDK sharedSDK] sessionViewController];
    sessionVC.sessionTitle = @"七鱼金融";
    sessionVC.source = source;
    //commodityInfo
    sessionVC.commodityInfo = [self makeCommodityInfo];
    sessionVC.autoSendInRobot = _autoSendInRobot.on;
    //请求客服参数
    sessionVC.groupId = [QYSettingData sharedData].groupId;
    sessionVC.staffId = [QYSettingData sharedData].staffId;
    sessionVC.robotId = [QYSettingData sharedData].robotId;
    sessionVC.vipLevel = [QYSettingData sharedData].vipLevel;
    sessionVC.commonQuestionTemplateId = [QYSettingData sharedData].questionTemplateId;
    sessionVC.robotWelcomeTemplateId = [QYSettingData sharedData].robotWelcomeTemplateId;
    sessionVC.openRobotInShuntMode = [QYSettingData sharedData].openRobotInShuntMode;
    [[QYSettingData sharedData] resetEntranceParameter];
    //收起历史消息
    sessionVC.hideHistoryMessages = [QYSettingData sharedData].hideHistoryMsg;
    sessionVC.historyMessagesTip = [QYSettingData sharedData].historyMsgTip;
    /**
     * push
     */
    sessionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionVC animated:YES];
}

- (QYCommodityInfo *)makeCommodityInfo {
    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = _title1.text;
    commodityInfo.desc = _desc.text;
    commodityInfo.pictureUrlString = _pictureUrlString.text;
    commodityInfo.urlString = _urlString.text;
    commodityInfo.note = _note.text;
    commodityInfo.show = _show.on;
    commodityInfo.isPictureLink = _custom.on;
    /* 用户手动发送 */
    commodityInfo.sendByUser = _sendByUser.on;
    commodityInfo.actionText = _actionText.text;
    commodityInfo.actionTextColor = [UIColor ysf_colorWithHexString:_actionTextColor.text];
    
    NSMutableArray<QYCommodityTag *> *array = [NSMutableArray<QYCommodityTag *> new];
    QYCommodityTag *buttonInfo = [QYCommodityTag new];
    buttonInfo.label = _textView1.text;
    buttonInfo.url = _textView2.text;
    buttonInfo.focusIframe = _textView3.text;
    buttonInfo.data = _textView4.text;
    [array addObject:buttonInfo];
    buttonInfo = [QYCommodityTag new];
    buttonInfo.label = _textView5.text;
    buttonInfo.url = _textView6.text;
    buttonInfo.focusIframe = _textView7.text;
    buttonInfo.data = _textView8.text;
    [array addObject:buttonInfo];
    buttonInfo = [QYCommodityTag new];
    buttonInfo.label = _textView9.text;
    buttonInfo.url = _textView10.text;
    buttonInfo.focusIframe = _textView11.text;
    buttonInfo.data = _textView12.text;
    [array addObject:buttonInfo];
    commodityInfo.tagsArray = array;
    return commodityInfo;
}

- (void)onSendMsgId:(id)sender {
    NSString *msgId = _msgId.text;
    [[QYSDK sharedSDK] getPushMessage:msgId];
}

- (void)onShowTabbar:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_showTabbar.on forKey:YSFDemoOnShowTabbar];
}



@end

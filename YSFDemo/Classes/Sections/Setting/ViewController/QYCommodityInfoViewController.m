//
//  QYCommodityInfoViewController.m
//  YSFDemo
//
//  Created by JackyYu on 16/5/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "QYCommodityInfoViewController.h"
#import "QYSDK.h"
#import "QYSource.h"
#import "QYCommodityInfo.h"
#import "QYCustomUIConfig.h"
#import "UIView+YSFToast.h"



@interface QYCommodityInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextView *title1;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UITextView *pictureUrlString;
@property (weak, nonatomic) IBOutlet UITextView *urlString;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UISwitch *show;
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

@end

@implementation QYCommodityInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self addTarget];
    
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 2048)];
    
}

- (void)initData
{
    _show.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowKey];
    _showAudio.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowAudio];
    _showAudioInRobotMode.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowAudioInRobotMode];
    _showEmoticon.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowEmoticon];
    _showKeyboard.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowKeyboard];
    _showTabbar.on = [[NSUserDefaults standardUserDefaults] boolForKey:YSFDemoOnShowTabbar];
}

- (void)addTarget
{
    [_show addTarget:self action:@selector(onShow:) forControlEvents:UIControlEventValueChanged];
    [_showAudio addTarget:self action:@selector(onShowAudio:) forControlEvents:UIControlEventValueChanged];
    [_showAudioInRobotMode addTarget:self action:@selector(onShowAudioInRobotMode:) forControlEvents:UIControlEventValueChanged];
    [_showEmoticon addTarget:self action:@selector(onShowEmoticon:) forControlEvents:UIControlEventValueChanged];
    [_showKeyboard addTarget:self action:@selector(onShowKeyboard:) forControlEvents:UIControlEventValueChanged];
    [_save addTarget:self action:@selector(onSave:) forControlEvents:UIControlEventTouchUpInside];
    [_go addTarget:self action:@selector(onGo:) forControlEvents:UIControlEventTouchUpInside];
    [_sendMsgId addTarget:self action:@selector(onSendMsgId:) forControlEvents:UIControlEventTouchUpInside];
    [_showTabbar addTarget:self action:@selector(onShowTabbar:) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)onShow:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:_show.on forKey:YSFDemoOnShowKey];
}

- (void)onShowAudio:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:_showAudio.on forKey:YSFDemoOnShowAudio];
}

- (void)onShowAudioInRobotMode:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:_showAudioInRobotMode.on forKey:YSFDemoOnShowAudioInRobotMode];
}

- (void)onShowEmoticon:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:_showEmoticon.on forKey:YSFDemoOnShowEmoticon];
}

- (void)onShowKeyboard:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:_showKeyboard.on forKey:YSFDemoOnShowKeyboard];
}

- (void)tap:(id)sender
{
    [_title1 resignFirstResponder];
    [_desc resignFirstResponder];
    [_pictureUrlString resignFirstResponder];
    [_urlString resignFirstResponder];
    [_note resignFirstResponder];

}

-(void)onSave:(id)sender
{
    NSString *text = nil;
    if (![_title1.text isEqualToString:@""] && ![_desc.text isEqualToString:@""]
        && ![_pictureUrlString.text isEqualToString:@""] && ![_urlString.text isEqualToString:@""]
        && ![_note.text isEqualToString:@""]) {
        
        text = _title1.text;
        
    }else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"有参数未填写" message:@"知道了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"OK", nil];
        [alterView show];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setValue:_title1.text forKey:YSFDemoCommodityInfoTitle];
    [[NSUserDefaults standardUserDefaults] setValue:_desc.text forKey:YSFDemoCommodityInfoDesc];
    [[NSUserDefaults standardUserDefaults] setValue:_pictureUrlString.text forKey:YSFDemoCommodityInfoPictureUrlString];
    [[NSUserDefaults standardUserDefaults] setValue:_urlString.text forKey:YSFDemoCommodityInfoUrlString];
    [[NSUserDefaults standardUserDefaults] setValue:_note.text forKey:YSFDemoCommodityInfoNote];
    [[NSUserDefaults standardUserDefaults] setBool:_show.on forKey:YSFDemoOnShowKey];
    
    [[NSUserDefaults standardUserDefaults] setBool:_showAudio.on forKey:YSFDemoOnShowAudio];
    [[NSUserDefaults standardUserDefaults] setBool:_showAudioInRobotMode.on forKey:YSFDemoOnShowAudioInRobotMode];
    [[NSUserDefaults standardUserDefaults] setBool:_showEmoticon.on forKey:YSFDemoOnShowEmoticon];
    [[NSUserDefaults standardUserDefaults] setBool:_showEmoticon.on forKey:YSFDemoOnShowEmoticon];
    [[NSUserDefaults standardUserDefaults] setBool:_showKeyboard.on forKey:YSFDemoOnShowKeyboard];
    
    [self.view ysf_makeToast:@"保存成功！" duration:1.0 position:YSFToastPositionCenter];
}

- (void)onGo:(id)sender
{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    
    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = _title1.text;
    commodityInfo.desc = _desc.text;
    commodityInfo.pictureUrlString = _pictureUrlString.text;
    commodityInfo.urlString = _urlString.text;
    commodityInfo.note = _note.text;
    commodityInfo.show = _show.on;
    
    
    QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
    vc.sessionTitle = @"七鱼金融";
    vc.source = source;
    vc.commodityInfo = commodityInfo;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
    [QYCustomUIConfig sharedInstance].showAudioEntry = _showAudio.on;
    [QYCustomUIConfig sharedInstance].showAudioEntryInRobotMode = _showAudioInRobotMode.on;
    [QYCustomUIConfig sharedInstance].showEmoticonEntry = _showEmoticon.on;
    [QYCustomUIConfig sharedInstance].autoShowKeyboard = _showKeyboard.on;

}

- (void)onSendMsgId:(id)sender
{
    NSString *msgId = _msgId.text;
    [[QYSDK sharedSDK] getPushMessage:msgId];
}

- (void)onShowTabbar:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:_showTabbar.on forKey:YSFDemoOnShowTabbar];
}



@end

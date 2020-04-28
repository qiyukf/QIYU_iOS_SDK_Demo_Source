#import "QYSettingViewController.h"
#import "QYUserTableViewController.h"
#import "QYBindAppkeyViewController.h"
#import "QYDemoConfig.h"
#import "YSFCommonTableData.h"
#import "YSFCommonTableDelegate.h"
#import "YSFCommonTableViewCell.h"
#import "UIView+YSFToast.h"
#import "QYDemoBadgeView.h"
#import "UIView+YSF.h"
#import "QYLogViewController.h"
#import "QYCommodityInfoViewController.h"
#import "QYTestModeViewController.h"
#import "QYHomePageViewController.h"
#import "QYSessionListViewController.h"
#import "QYUniqueStaffViewController.h"
#import "QYCustomStyleViewController.h"
#import "QYMoreOptionViewController.h"
#import "QYEvaluationViewController.h"
#import "YSFWebViewController.h"
#import "QYCommonCell.h"
#import "QYDataSourceConfig.h"
#import "NSDictionary+QYJson.h"
#import "QYDemoConfig.h"
#import "NSString+QY.h"
#import "QYMacro.h"

#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYPOPSDK.h>
#import <QYSDK/QYCustomSDK.h>

#import "QYCustomTextMessage.h"
#import "QYCustomTextModel.h"
#import "QYCustomTextContentView.h"
#import "QYCustomImageMessage.h"
#import "QYCustomImageModel.h"
#import "QYCustomImageContentView.h"
#import "QYCustomCardMessage.h"
#import "QYCustomCardModel.h"
#import "QYCustomCardContentView.h"
#import "QYCustomTicketMessage.h"
#import "QYCustomTicketModel.h"
#import "QYCustomTicketContentView.h"


static NSString * const kQYSettingCellIdentifier = @"kQYSettingCellIdentifier";

static NSString *const kQYNIMAccountInfoKey = @"kQYNIMAccountInfoKey";
static NSString *const kQYNIMAccountKey = @"kQYNIMAccountKey";
static NSString *const kQYNIMTokenKey = @"kQYNIMTokenKey";
static NSString *const kQYNIMIsEverLoginedKey = @"kQYNIMIsEverLoginedKey";


@interface QYSettingViewController () <UITableViewDataSource, UITableViewDelegate, QYSessionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QYConversationManagerDelegate, QYCustomMessageDelegate, QYCustomContentViewDelegate, QYCommonCellActionDelegate, NIMLoginManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, weak) QYSessionViewController *sessionViewController;
@property (nonatomic, strong) UIImage *failImage;

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) BOOL isEverLogined;

@end

@implementation QYSettingViewController
- (void)dealloc {
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    if (_sessionViewController) {
        _sessionViewController.delegate = nil;
        [_sessionViewController removeCustomMessageDelegate:self];
        [_sessionViewController removeCustomContentViewDelegate:self];
        _sessionViewController = nil;
    }
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([QYDemoConfig sharedConfig].isFusion) {
            [self readAccountInfo];
            if (self.isEverLogined) {
                [self nimLoginWithAccount:self.account password:self.password];
            }
        } else {
            //report
            [self reportUserInfo];
        }
        [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
        
        _failImage = [UIImage imageNamed:@"icon_fail"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.key = [[NSUUID UUID] UUIDString];
    self.navigationItem.title = @"设置";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    
    [[QYSDK sharedSDK] registerPushMessageNotification:^(QYPushMessage *message) {
        NSString *time = [QYSettingViewController showTime:message.time showDetail:YES];
        NSString *content = @"";
        content = [NSString stringWithFormat:@"头像url：%@ \n按钮文本：%@ \n按钮链接：%@ \n时间：%@", message.headImageUrl, message.actionText, message.actionUrl, time] ;
        if (message.type == QYPushMessageTypeText) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@" \n内容：%@", message.text]];
        } else if (message.type == QYPushMessageTypeRichText) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@" \n内容：%@", message.richText]];
        } else if (message.type == QYPushMessageTypeImage) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@" \n内容：%@", message.imageUrl]];
        }

        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                         message:content
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil,nil];
        [dialog show];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    [self reloadDataAndTable];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[QYSDK sharedSDK] trackHistory:@"设置" enterOrOut:YES key:_key];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[QYSDK sharedSDK] trackHistory:@"设置" enterOrOut:NO key:_key];
    self.key = [[NSUUID UUID] UUIDString];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[QYDataSourceConfig sharedConfig].settingDataSource count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].settingDataSource[section];
    return tableSection.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].settingDataSource[section];
    return tableSection.footerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].settingDataSource[section];
    return [tableSection.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:kQYSettingCellIdentifier];
    if (!cell) {
        cell = [[QYCommonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kQYSettingCellIdentifier];
    }
    
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].settingDataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    cell.rowData = tableRow;
    cell.actionDelegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].settingDataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    if (tableRow.uiRowHeight > 0) {
        return tableRow.uiRowHeight;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].settingDataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    [self didSelectRow:tableRow indexPath:indexPath];
}

- (void)didSelectRow:(YSFCommonTableRow *)rowData indexPath:(NSIndexPath *)indexPath {
    if (rowData.type == QYSettingTypeUserInfo) {
        [self onChangeUserInfo];
    } else if (rowData.type == QYSettingTypeAppKey) {
        [self onBindAppkey];
    } else if (rowData.type == QYSettingTypePrivatization) {
        [self onPrivatization];
    } else if (rowData.type == QYSettingTypeAccountLogin) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入云信帐号及密码"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.placeholder = @"Account";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.placeholder = @"Password";
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([alert.textFields count] >= 2) {
                NSString *account = @"";
                NSString *password = @"";
                UITextField *textField_1 = [alert.textFields objectAtIndex:0];
                UITextField *textField_2 = [alert.textFields objectAtIndex:1];
                if (textField_1.text.length) {
                    account = textField_1.text;
                }
                if (textField_2.text.length) {
                    password = textField_2.text;
                }
                [weakSelf nimLoginWithAccount:account password:password];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (rowData.type == QYSettingTypeAccountLogout) {
        __weak typeof(self) weakSelf = self;
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
            if (!error) {
                [weakSelf showToast:@"云信帐号注销成功"];
                [weakSelf cleanAccountInfo];
                [weakSelf reloadDataAndTable];
            } else {
                [weakSelf showFailToastString:@"云信帐号注销失败"];
            }
        }];
    } else if (rowData.type == QYSettingTypeChat) {
        [self onChat];
    } else if (rowData.type == QYSettingTypeUniqueStaff) {
        [self onChatWithUniqueStaff];
    } else if (rowData.type == QYSettingTypeSessionList) {
        [self onSessionList];
    } else if (rowData.type == QYSettingTypeSource) {
        [self onInputSource];
    } else if (rowData.type == QYSettingTypeGroupId) {
        [self onInputGroupId];
    } else if (rowData.type == QYSettingTypeStaffId) {
        [self onInputStaffId];
    } else if (rowData.type == QYSettingTypeRobotId) {
        [self onInputRobotId];
    } else if (rowData.type == QYSettingTypeCommonQuestionTemplateId) {
        [self onCommonQuestionTemplateId];
    } else if (rowData.type == QYSettingTypeRobotWelcomeTemplateId) {
        [self onRobotWelcomeTemplateId];
    } else if (rowData.type == QYSettingTypeVIPLevel) {
        [self onInputVipLevel];
    } else if (rowData.type == QYSettingTypeAuthToken) {
        [self onInputAuthToken];
    } else if (rowData.type == QYSettingTypeClearUnreadCount) {
        [self onClearUnreadCount];
    } else if (rowData.type == QYSettingTypeCleanCache) {
        [self onCleanCache];
    } else if (rowData.type == QYSettingTypeCleanAccountInfo) {
        [self onCleanAccountInfo];
    } else if (rowData.type == QYSettingTypeTestEntry) {
        [self onTestEntry];
    } else if (rowData.type == QYSettingTypeCustomStyle) {
        [self onCustomStyle];
    } else if (rowData.type == QYSettingTypeAddButton) {
        [self onAddButton];
    } else if (rowData.type == QYSettingTypeAddMoreButton) {
        [self onAddMoreButton];
    } else if (rowData.type == QYSettingTypeLog) {
        [self viewNimLog];
    } else if (rowData.type == QYSettingTypeAbout) {
        [self onAbout];
    }
}

#pragma mark - QYCommonCellActionDelegate
- (void)onTapSwitch:(YSFCommonTableRow *)cellData {
    if (cellData.type == QYSettingTypeAddTopHoverView) {
        if (cellData.switchOn) {
            [QYSettingData sharedData].hoverViewHeight = 120;
            __weak typeof(self) weakSelf = self;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入顶部视图高度"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.placeholder = @"默认高度：120";
            }];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([alert.textFields count]) {
                    UITextField *textField = [alert.textFields firstObject];
                    if (textField.text.length) {
                        NSInteger height = [textField.text integerValue];
                        if (height >= 0) {
                            [QYSettingData sharedData].hoverViewHeight = height;
                        }
                    }
                    [weakSelf reloadDataAndTable];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [QYSettingData sharedData].hoverViewHeight = 0;
            [self reloadDataAndTable];
        }
    } else if (cellData.type == QYSettingTypeAddEvaluationView) {
        [QYSettingData sharedData].customEvaluation = cellData.switchOn;
    } else if (cellData.type == QYSettingTypeHideHistoryMessage) {
        if (cellData.switchOn) {
            [QYSettingData sharedData].hideHistoryMsg = YES;
            __weak typeof(self) weakSelf = self;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入历史消息提示"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"默认：以上为历史消息";
            }];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([alert.textFields count]) {
                    UITextField *textField = [alert.textFields firstObject];
                    if (textField.text.length) {
                        [QYSettingData sharedData].historyMsgTip = textField.text;
                    }
                    [weakSelf reloadDataAndTable];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [QYSettingData sharedData].hideHistoryMsg = NO;
            [QYSettingData sharedData].historyMsgTip = @"";
            [self reloadDataAndTable];
        }
    } else if (cellData.type == QYSettingTypePullRoamMessage) {
        [QYSettingData sharedData].pullRoamMessage = cellData.switchOn;
        [[QYSDK sharedSDK] customActionConfig].pullRoamMessage = cellData.switchOn;
    }
}

#pragma mark - 云信帐号相关
- (void)nimLoginWithAccount:(NSString *)account password:(NSString *)password {
    if (account.length && password.length) {
        NSString *loginToken = password;
        /**
         * 私有化配置
         */
        BOOL isPrivate = NO;
        id setting = nil;
        setting = [[NSUserDefaults standardUserDefaults] valueForKey:@"privatization_enabled"];
        if(setting) {
            isPrivate = [setting boolValue];
        }
        if(isPrivate) {
            setting = [[NSUserDefaults standardUserDefaults] valueForKey:@"privatization_password_md5_enabled"];
            BOOL md5Enable = NO;
            if(setting) {
                md5Enable = [setting boolValue];
            }
            if(md5Enable) {
                loginToken = [password qy_md5];
            }
        }
        
        [self.view ysf_makeActivityToast:@"登录中" shadow:NO];
        if ([account isEqualToString:self.account]
            && [password isEqualToString:self.password]
            && self.isEverLogined) {
            [[[NIMSDK sharedSDK] loginManager] autoLogin:account token:loginToken];
        } else {
            __weak typeof(self) weakSelf = self;
            [[[NIMSDK sharedSDK] loginManager] login:account token:loginToken completion:^(NSError * _Nullable error) {
                if (!error) {
                    weakSelf.account = account;
                    weakSelf.password = password;
                } else {
                    [weakSelf handleLoginError:error];
                }
            }];
        }
    } else {
        [self showFailToastString:@"请填写正确的帐号及密码"];
    }
}

- (void)onLogin:(NIMLoginStep)step {
    if ([QYDemoConfig sharedConfig].isFusion) {
        if (step == NIMLoginStepSyncOK) {
            [self.view ysf_hideToastActivity];
            [self showToast:@"云信帐号登录成功"];
            //save
            [self saveAccountInfo];
            //reload
            [self reloadDataAndTable];
            //report
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf reportUserInfo];
            });
        }
    }
}

- (void)onAutoLoginFailed:(NSError *)error {
    if ([QYDemoConfig sharedConfig].isFusion) {
        [self handleLoginError:error];
    }
}

- (void)handleLoginError:(NSError *)error {
    if (error) {
        NSString *toast = nil;
        NSInteger code = [error code];
        if (code == NIMRemoteErrorCodeInvalidPass) {
            toast = @"密码错误";
        } else {
            toast = @"登录失败";
        }
        toast = [toast stringByAppendingFormat:@" code:%ld", (long)code];
        [self showFailToastString:toast];
    }
}

- (void)saveAccountInfo {
    if (_account.length && _password.length) {
        NSDictionary *dict = @{
            kQYNIMAccountKey : _account,
            kQYNIMTokenKey : _password,
            kQYNIMIsEverLoginedKey : @(YES),
        };
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kQYNIMAccountInfoKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)readAccountInfo {
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:kQYNIMAccountInfoKey];
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)data;
        _account = [dict qy_jsonString:kQYNIMAccountKey];
        _password = [dict qy_jsonString:kQYNIMTokenKey];
        _isEverLogined = [dict qy_jsonBool:kQYNIMIsEverLoginedKey];
    }
}

- (void)cleanAccountInfo {
    _account = nil;
    _password = nil;
    _isEverLogined = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:kQYNIMAccountInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reportUserInfo {
    NSString *currentUserId = [[QYSDK sharedSDK] performSelector:@selector(currentForeignUserId)];
    if (currentUserId) {
        [QYUserTableViewController selectUserInfoByID:currentUserId];
    }
}

#pragma mark - 企业帐号相关
//个人信息
- (void)onChangeUserInfo {
    QYUserTableViewController *vc = [[QYUserTableViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//绑定AppKey
- (void)onBindAppkey {
    QYBindAppkeyViewController *vc = [[QYBindAppkeyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//查看Log
- (void)viewNimLog {
    NSString *path = [[QYSDK sharedSDK] qiyuLogPath];
    QYLogViewController *vc = [[QYLogViewController alloc] initWithFilepath:path];
    vc.title = @"log";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//关于
- (void)onAbout {
    NSString *qyVersion = [[QYSDK sharedSDK] sdkVersion];
    NSString *fusionVersion = [[QYSDK sharedSDK] fusionSdkVersion];
    NSString *nimVersion = [[NIMSDK sharedSDK] sdkVersion];
    
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    NSString *qyNumVersion = [infoDict objectForKey:@"BundleNumericVersion"];
    NSString *fusionNumVersion = [infoDict objectForKey:@"BundleFusionNumericVersion"];
    NSString *build = [infoDict objectForKey:@"CFBundleVersion"];
    
    NSString *message = [NSString stringWithFormat:@"七鱼SDK：%@ / %@\n融合SDK：%@ / %@\n云信SDK：%@\nbuild：%@", qyVersion, qyNumVersion, fusionVersion, fusionNumVersion, nimVersion, build];
    
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"版本号"
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil, nil];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [dialog show];
}

//私有化配置
- (void)onPrivatization {
//    QYPrivatizationViewController *vc = [[QYPrivatizationViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 联系客服
- (void)onChat {
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
    __weak typeof(self) weakSelf = self;
    /**
     * 会话来源信息
     */
    QYSource *source = [QYSettingData sharedData].source;
    if (!source) {
        source = [[QYSource alloc] init];
        source.title =  @"设置";
        source.urlString = @"https://8.163.com/";
    }
    /**
     * 创建QYSessionViewController
     */
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.delegate = self;
    sessionViewController.sessionTitle = @"七鱼金融";
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
    //人工快捷入口
    sessionViewController.buttonInfoArray = [QYSettingData sharedData].quickButtonArray;
    //自定义顶部视图
    if ([QYSettingData sharedData].hoverViewHeight > 0) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        [sessionViewController registerTopHoverView:[self makeHoverViewWithInsets:insets]
                                             height:[QYSettingData sharedData].hoverViewHeight
                                       marginInsets:insets];
    }
    //自定义评价界面
    if ([QYSettingData sharedData].customEvaluation) {
        sessionViewController.evaluationBlock = ^(QYEvaluactionData *data) {
            [weakSelf pushEvaluationViewController:data];
        };
    } else {
        sessionViewController.evaluationBlock = nil;
    }
    //收起历史消息
    sessionViewController.hideHistoryMessages = [QYSettingData sharedData].hideHistoryMsg;
    sessionViewController.historyMessagesTip = [QYSettingData sharedData].historyMsgTip;
    /**
     * bot消息url类型action
     */
    [[QYSDK sharedSDK] customActionConfig].botClick = ^(NSString *target, NSString *params) {
        NSString *tip = [NSString stringWithFormat:@"target: %@\nparams: %@", QYStrParam(target), QYStrParam(params)];
        [weakSelf showToast:tip];
    };
    /**
     * push消息点击
     */
    [[QYSDK sharedSDK] customActionConfig].pushMessageClick = ^(NSString *actionUrl) {
        NSString *tip = [NSString stringWithFormat:@"actionUrl: %@", QYStrParam(actionUrl)];
        [weakSelf showToast:tip];
    };
    /**
     * 快捷入口按钮点击
     */
    sessionViewController.buttonClickBlock = ^(QYButtonInfo *action) {
        NSString *tip = [NSString stringWithFormat:@"您点击了第%lu个按钮:%@", (unsigned long)(action.index + 1), action.title];
        [weakSelf showToast:tip];
    };
    /**
     * 自定义事件按钮点击
     */
    [[QYSDK sharedSDK] customActionConfig].customButtonClickBlock = ^(NSDictionary *dict) {
        NSString *toast = @"您点击了自定义事件按钮\n";
        id data = [dict objectForKey:@"data"];
        if (data && [data isKindOfClass:[NSString class]] && ((NSString *)data).length) {
            toast = [toast stringByAppendingString:[NSString stringWithFormat:@"数据：%@", data]];
        } else {
            toast = [toast stringByAppendingString:@"未传数据"];
        }
        [weakSelf showToast:toast];
    };
    /**
     * 自定义卡片消息
     */
    sessionViewController.customMessageDataBlock = ^(NSString *jsonString) {
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                QYCustomTicketMessage *message = [QYCustomTicketMessage objectByDict:object];
                [weakSelf.sessionViewController addCustomMessage:message
                                                    needSaveData:YES
                                                  needReloadView:YES
                                                      completion:^(NSError *error) {
                    if (error) {
                        [weakSelf showToast:@"addCustomMessage error !!!"];
                    }
                }];
            }
        }
    };
    /**
     * 自定义消息
     */
    [sessionViewController registerCustomMessageClass:[QYCustomTextMessage class]
                                           modelClass:[QYCustomTextModel class]
                                     contentViewClass:[QYCustomTextContentView class]];
    [sessionViewController registerCustomMessageClass:[QYCustomImageMessage class]
                                           modelClass:[QYCustomImageModel class]
                                     contentViewClass:[QYCustomImageContentView class]];
    [sessionViewController registerCustomMessageClass:[QYCustomCardMessage class]
                                           modelClass:[QYCustomCardModel class]
                                     contentViewClass:[QYCustomCardContentView class]];
    [sessionViewController registerCustomMessageClass:[QYCustomTicketMessage class]
                                           modelClass:[QYCustomTicketModel class]
                                     contentViewClass:[QYCustomTicketContentView class]];
    [sessionViewController addCustomMessageDelegate:self];
    [sessionViewController addCustomContentViewDelegate:self];
    /**
     * push/present
     */
    sessionViewController.hidesBottomBarWhenPushed = YES;
    if ([QYSettingData sharedData].isPushMode) {
        [self.navigationController pushViewController:sessionViewController animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
        sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                                                  style:UIBarButtonItemStylePlain
                                                                                                 target:self
                                                                                                 action:@selector(onBack:)];
        [self presentViewController:nav animated:YES completion:nil];
    }
    self.sessionViewController = sessionViewController;
}

- (void)sendProduct {
    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = @"商品标题111";
    commodityInfo.desc = @"商品描述，不超过150字符 商品描述，不超过150字符 商品描述，不超过150字符";
    commodityInfo.urlString = @"https://qiyukf.com";
    commodityInfo.pictureUrlString = @"https://ysf.nosdn.127.net/44AC563D895637313F4F32DFD59C0708";
    commodityInfo.note = @"￥999.99";
    commodityInfo.show = YES;
    NSMutableArray<QYCommodityTag *> *array = [NSMutableArray arrayWithCapacity:3];
    QYCommodityTag *buttonInfo1 = [[QYCommodityTag alloc] init];
    buttonInfo1.label = @"测试1";
    buttonInfo1.url = @"www.baidu.com";
    buttonInfo1.focusIframe = @"iframe1";
    buttonInfo1.data = @"userdata1";
    [array addObject:buttonInfo1];
    QYCommodityTag *buttonInfo2 = [[QYCommodityTag alloc] init];
    buttonInfo2.label = @"测试2";
    buttonInfo2.url = @"www.163.com";
    buttonInfo2.focusIframe = @"iframe2";
    buttonInfo2.data = @"userdata2";
    [array addObject:buttonInfo2];
    QYCommodityTag *buttonInfo3 = [[QYCommodityTag alloc] init];
    buttonInfo3.label = @"测试3";
    buttonInfo3.url = @"www.sina.com";
    buttonInfo3.focusIframe = @"iframe3";
    buttonInfo3.data = @"userdata3";
    [array addObject:buttonInfo3];
    commodityInfo.tagsArray = array;
    [self.sessionViewController sendCommodityInfo:commodityInfo];
}

- (void)sendOrder {
    QYSelectedCommodityInfo *order = [[QYSelectedCommodityInfo alloc] init];
    order.target = @"target";
    order.params = @"params";
    order.p_status = @"已完成";
    order.p_img = @"https://ysf.nosdn.127.net/44AC563D895637313F4F32DFD59C0708";
    order.p_name = @"商品名称";
    order.p_price = @"￥999.99";
    order.p_count = @"已售出1w+";
    order.p_stock = @"还剩5个";
    order.p_action = @"重新选择";
    order.p_url = @"https://qiyukf.com";
    order.p_userData = @"p_userData";
    [self.sessionViewController sendSelectedCommodityInfo:order];
}

//专属客服
- (void)onChatWithUniqueStaff {
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    QYUniqueStaffViewController *vc = [[QYUniqueStaffViewController alloc] init];
    vc.unreadCount = count;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//会话列表
- (void)onSessionList {
    QYSessionListViewController *vc = [QYSessionListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushEvaluationViewController:(QYEvaluactionData *)data {
    QYEvaluationViewController *evaVC = [[QYEvaluationViewController alloc] initWithEvaluationData:data sessionVC:self.sessionViewController];
    evaVC.modalPresentationStyle = UIModalPresentationCustom;
    evaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.sessionViewController presentViewController:evaVC animated:YES completion:nil];
}

#pragma mark - 功能配置
//会话来源
- (void)onInputSource {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入会话来源信息"
                                                                   message:@"仅对 设置-联系客服 入口生效"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"来源标题";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeURL;
        textField.placeholder = @"来源链接";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"来源自定义信息";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([alert.textFields count] >= 3) {
            UITextField *textField_1 = [alert.textFields objectAtIndex:0];
            UITextField *textField_2 = [alert.textFields objectAtIndex:1];
            UITextField *textField_3 = [alert.textFields objectAtIndex:2];
            
            [QYSettingData sharedData].source = [[QYSource alloc] init];
            [QYSettingData sharedData].source.title = textField_1.text;
            [QYSettingData sharedData].source.urlString = textField_2.text;
            [QYSettingData sharedData].source.customInfo = textField_3.text;
            
            [weakSelf reloadDataAndTable];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//客服分组ID
- (void)onInputGroupId {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入客服分组ID"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"不开启机器人",@"开启机器人",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [dialog show];
}

//客服ID
- (void)onInputStaffId {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入客服ID"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"不开启机器人",@"开启机器人",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [dialog show];
}

//机器人ID
- (void)onInputRobotId {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入机器人ID"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [dialog show];
}

//常见问题模板ID
- (void)onCommonQuestionTemplateId {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入常见问题模板ID"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [dialog show];
}

//机器人欢迎语模板ID
- (void)onRobotWelcomeTemplateId {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入机器人欢迎语模板ID"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [dialog show];
}

//VIP等级
- (void)onInputVipLevel {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入VIP等级"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [dialog show];
}

//AuthToken
- (void)onInputAuthToken {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入AuthToken"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeASCIICapable];
    [dialog show];
}

//清空未读数
- (void)onClearUnreadCount {
    [[[QYSDK sharedSDK] conversationManager] clearUnreadCount];
    [self showToast:@"已清空"];
}

//清理接收文件
- (void)onCleanCache {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清理接收文件提示"
                                                                   message:@"文件清理后将删除客户端接收过的所有文件，是否确认清理？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[QYSDK sharedSDK] cleanResourceCacheWithBlock:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//清理帐号信息
- (void)onCleanAccountInfo {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清理帐号信息提示"
                                                        message:@"请确认清理历史帐号信息（不包含当前帐号）还是所有帐号信息"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"清理历史帐号信息", @"清理全部", nil];
    [alertView show];
}

//测试功能
- (void)onTestEntry {
    QYTestModeViewController *vc = [[QYTestModeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 界面配置
//自定义样式
- (void)onCustomStyle {
    QYCustomStyleViewController *vc = [[QYCustomStyleViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//设置输入区域工具栏按钮
- (void)onAddButton {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请逐个输入按钮文案"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", @"清空", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [dialog show];
}

//相机按钮替换为+按钮
- (void)onAddMoreButton {
    QYMoreOptionViewController *vc = [[QYMoreOptionViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 其他点击
- (void)onTapShopEntrance {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"你点击了商铺入口"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)onTapSessionListEntrance {
    QYSessionListViewController *vc = [QYSessionListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onBack:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[[QYSDK sharedSDK] customActionConfig] showQuitWaitingAlert:^(QYQuitWaitingType quitType) {
        if (quitType == QYQuitWaitingTypeNone) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else if (quitType == QYQuitWaitingTypeContinue) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else if (quitType == QYQuitWaitingTypeQuit) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
        } else if (quitType == QYQuitWaitingTypeCancel) {
            
        }
    }];
}

#pragma mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([alertView.title isEqualToString:@"请输入AuthToken"]) {
            NSString *authToken = [alertView textFieldAtIndex:0].text;
            [QYSettingData sharedData].authToken = authToken;
            [[QYSDK sharedSDK] setAuthToken:[QYSettingData sharedData].authToken];
            [self reloadDataAndTable];
        }
        
        int64_t longlongId = [[alertView textFieldAtIndex:0].text longLongValue];
        if ([alertView.title isEqualToString:@"请输入客服分组ID"]) {
            [QYSettingData sharedData].groupId = longlongId;
            [QYSettingData sharedData].staffId = 0;
            [QYSettingData sharedData].openRobotInShuntMode = NO;
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"请输入客服ID"]) {
            [QYSettingData sharedData].staffId = longlongId;
            [QYSettingData sharedData].groupId = 0;
            [QYSettingData sharedData].openRobotInShuntMode = NO;
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"请输入机器人ID"]) {
            [QYSettingData sharedData].robotId = longlongId;
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"请输入常见问题模板ID"]) {
            [QYSettingData sharedData].questionTemplateId = longlongId;
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"请输入机器人欢迎语模板ID"]) {
            [QYSettingData sharedData].robotWelcomeTemplateId = longlongId;
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"请输入VIP等级"]) {
            [QYSettingData sharedData].vipLevel = (NSInteger)longlongId;
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"请逐个输入按钮文案"]) {
            NSString *buttonText = [alertView textFieldAtIndex:0].text;
            QYButtonInfo *buttonInfo = [QYButtonInfo new];
            buttonInfo.title = buttonText;
            [[QYSettingData sharedData].quickButtonArray addObject:buttonInfo];
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"清理帐号信息提示"]) {
            __weak typeof(self) weakSelf = self;
            [[QYSDK sharedSDK] cleanAccountInfoForAll:NO completion:^(NSError *error) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf showToast:@"清理完成"];
                });
            }];
        }
    } else if (buttonIndex == 2) {
        int64_t longlongId = [[alertView textFieldAtIndex:0].text longLongValue];
        if ([alertView.title isEqualToString:@"请输入客服分组ID"]) {
            [QYSettingData sharedData].groupId = longlongId;
            [QYSettingData sharedData].staffId = 0;
            [QYSettingData sharedData].openRobotInShuntMode = YES;
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"请输入客服ID"]) {
            [QYSettingData sharedData].staffId = longlongId;
            [QYSettingData sharedData].groupId = 0;
            [QYSettingData sharedData].openRobotInShuntMode = YES;
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"请逐个输入按钮文案"]) {
            [[QYSettingData sharedData].quickButtonArray removeAllObjects];
            [self reloadDataAndTable];
        } else if ([alertView.title isEqualToString:@"清理帐号信息提示"]) {
            NSString *curForeignID = [[QYSDK sharedSDK] performSelector:@selector(currentForeignUserId)];
            __weak typeof(self) weakSelf = self;
            [[QYSDK sharedSDK] cleanAccountInfoForAll:YES completion:^(NSError *error) {
                if (!error) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf showToast:@"清理完成"];
                    });
                    
                    [weakSelf cleanAccountInfo];
                    [weakSelf reloadDataAndTable];
                    if (curForeignID.length) {
                        [QYUserTableViewController selectUserInfoByID:curForeignID];
                    }
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf showToast:@"清理失败"];
                    });
                }
            }];
        }
    }
}

#pragma mark - hover view
- (UIView *)makeHoverViewWithInsets:(UIEdgeInsets)insets {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - insets.left - insets.right;
    
    UIView *hoverView = [[UIView alloc] init];
    hoverView.backgroundColor = YSFColorFromRGB(0x12b8fb);
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.tintColor = [UIColor whiteColor];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    closeButton.frame = CGRectMake(width - 60, 0, 60, 40);
    closeButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [closeButton addTarget:self action:@selector(clickHoverViewCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [hoverView addSubview:closeButton];
    
    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openButton.tintColor = [UIColor whiteColor];
    [openButton setTitle:@"跳转" forState:UIControlStateNormal];
    [openButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    openButton.bounds = CGRectMake(0, 0, 60, 40);
    openButton.center = CGPointMake(width / 2, 20);
    openButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [openButton addTarget:self action:@selector(clickHoverViewOpenButton:) forControlEvents:UIControlEventTouchUpInside];
    [hoverView addSubview:openButton];
    
    CGFloat space = 20;
    CGFloat itemWidth = (width - 4 * space) / 3;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.tintColor = [UIColor whiteColor];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    sendButton.frame = CGRectMake(space, CGRectGetMaxY(openButton.frame) + 20, itemWidth, 40);
    sendButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [sendButton addTarget:self action:@selector(clickHoverViewSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [hoverView addSubview:sendButton];
    
    UIButton *receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    receiveButton.tintColor = [UIColor whiteColor];
    [receiveButton setTitle:@"接收" forState:UIControlStateNormal];
    [receiveButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    receiveButton.frame = CGRectMake(CGRectGetMaxX(sendButton.frame) + space, CGRectGetMaxY(openButton.frame) + 20, itemWidth, 40);
    receiveButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [receiveButton addTarget:self action:@selector(clickHoverViewReceiveButton:) forControlEvents:UIControlEventTouchUpInside];
    [hoverView addSubview:receiveButton];
    
    UIButton *cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cardButton.tintColor = [UIColor whiteColor];
    [cardButton setTitle:@"卡片" forState:UIControlStateNormal];
    [cardButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    cardButton.frame = CGRectMake(CGRectGetMaxX(receiveButton.frame) + space, CGRectGetMaxY(openButton.frame) + 20, itemWidth, 40);
    cardButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [cardButton addTarget:self action:@selector(clickHoverViewCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [hoverView addSubview:cardButton];
    
    return hoverView;
}

- (void)clickHoverViewCloseButton:(id)sender {
    if (self.sessionViewController) {
        [self.sessionViewController destroyTopHoverViewWithAnmation:YES duration:0.5];
    }
}

- (void)clickHoverViewOpenButton:(id)sender {
    [self openUrl:@"https://baidu.com/"];
}

- (void)clickHoverViewSendButton:(id)sender {
    //自定义图片消息
    QYCustomImageMessage *imgMsg = [[QYCustomImageMessage alloc] init];
    imgMsg.showImage = YES;
    __weak typeof(self) weakSelf = self;
    [self.sessionViewController addCustomMessage:imgMsg
                                    needSaveData:YES
                                  needReloadView:YES
                                      completion:^(NSError *error) {
                                          if (error) {
                                              [weakSelf showToast:@"addCustomMessage error !!!"];
                                          }
                                      }];
}

- (void)clickHoverViewReceiveButton:(id)sender {
    //自定义文本消息
    QYCustomTextMessage *textMsg = [[QYCustomTextMessage alloc] init];
    textMsg.text = @"这是一条自定义文本消息！";
    __weak typeof(self) weakSelf = self;
    [self.sessionViewController addCustomMessage:textMsg
                                    needSaveData:YES
                                  needReloadView:YES
                                      completion:^(NSError *error) {
                                          if (error) {
                                              [weakSelf showToast:@"addCustomMessage error !!!"];
                                          }
                                      }];
}

- (void)clickHoverViewCardButton:(id)sender {
    //自定义卡片消息
    QYCustomCardMessage *cardMsg = [[QYCustomCardMessage alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.sessionViewController addCustomMessage:cardMsg
                                    needSaveData:YES
                                  needReloadView:YES
                                      completion:^(NSError *error) {
                                          if (error) {
                                              [weakSelf showToast:@"addCustomMessage error !!!"];
                                          }
                                      }];
}

#pragma mark - QYConversationManagerDelegate
- (void)onUnreadCountChanged:(NSInteger)count {
    [self reloadDataAndTable];
}

#pragma mark - QYCustomMessageDelegate
- (void)onAddMessageBeforeReload:(QYCustomMessage *)message {
    [self showToast:@"追加消息回调(消息已持久化，还未刷新界面)"];
}

- (void)onInsertMessageBeforeReload:(QYCustomMessage *)message {
    [self showToast:@"插入消息回调(消息已持久化，还未刷新界面)"];
}

- (void)onUpdateMessageBeforeReload:(QYCustomMessage *)message {
    [self showToast:@"更新消息回调(消息已持久化，还未刷新界面)"];
}

- (void)onDeleteMessageBeforeReload:(QYCustomMessage *)message {
    [self showToast:@"删除消息回调(消息已持久化，还未刷新界面)"];
}

#pragma mark - QYCustomContentViewDelegate
- (void)onCatchEvent:(QYCustomEvent *)event {
    NSString *eventName = event.eventName;
    QYCustomMessage *message = event.message;
    
    if ([eventName isEqualToString:QYCustomEventTapImageButton]) {
        if ([message isKindOfClass:[QYCustomImageMessage class]]) {
            QYCustomImageMessage *imgMsg = (QYCustomImageMessage *)message;
            imgMsg.showImage = !imgMsg.showImage;
            __weak typeof(self) weakSelf = self;
            [self.sessionViewController updateCustomMessage:imgMsg
                                               needSaveData:YES
                                             needReloadView:YES
                                                 completion:^(NSError *error) {
                                                     if (error) {
                                                         [weakSelf showToast:@"updateCustomMessage error !!!"];
                                                     }
                                                 }];
        }
    } else if ([eventName isEqualToString:QYCustomEventTapDeleteButton]) {
        if ([message isKindOfClass:[QYCustomCardMessage class]]) {
            QYCustomCardMessage *cardMsg = (QYCustomCardMessage *)message;
            [self.sessionViewController deleteCustomMessage:cardMsg needSaveData:YES needReloadView:YES];
        }
    } else if ([eventName isEqualToString:QYCustomEventTapTicketButton]) {
        if ([message isKindOfClass:[QYCustomTicketMessage class]]) {
            [self showToast:@"点击了立即预定按钮"];
        }
    }
}

- (void)onTapAvatar:(QYCustomEvent *)event {
    [self showToast:[NSString stringWithFormat:@"事件：%@", event.eventName]];
}

- (void)onLongPressCell:(QYCustomEvent *)event {
    [self showToast:[NSString stringWithFormat:@"事件：%@", event.eventName]];
}

#pragma mark - other
- (void)reloadDataAndTable {
    [[QYDataSourceConfig sharedConfig] reloadSettingDataSource];
    [self.tableView reloadData];
}

- (void)showToast:(NSString *)toast {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        [topVC.view ysf_makeToast:toast duration:2.0 position:YSFToastPositionCenter];
    });
}

- (void)showFailToastString:(NSString *)string {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view ysf_hideToastActivity];
        [weakSelf.view ysf_makeToast:string image:weakSelf.failImage shadow:NO duration:2.0f];
    });
}

- (void)openUrl:(NSString *)urlString {
    if (self.sessionViewController) {
        YSFWebViewController *webViewController = [[YSFWebViewController alloc] initWithUrl:urlString
                                                                                 needOffset:YES
                                                                                 errorImage:nil];
        [self.sessionViewController.navigationController pushViewController:webViewController animated:YES];
    }
}

+ (NSString *)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail {
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    NSDate *today = [[NSDate alloc] init];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSDateComponents *yesterdayDateComponents = [[NSCalendar currentCalendar] components:components fromDate:yesterday];
    
    NSInteger hour = msgDateComponents.hour;
    result = @"";
    
    if (nowDateComponents.year == msgDateComponents.year
        && nowDateComponents.month == msgDateComponents.month
        && nowDateComponents.day == msgDateComponents.day) {
        //今天,hh:mm
        result = [[NSString alloc] initWithFormat:@"%@ %ld:%02d",result,(long)hour,(int)msgDateComponents.minute];
    } else if (yesterdayDateComponents.year == msgDateComponents.year
               && yesterdayDateComponents.month == msgDateComponents.month
               && yesterdayDateComponents.day == msgDateComponents.day) {
        //昨天，昨天 hh:mm
        result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %ld:%02d",result,(long)hour,(int)msgDateComponents.minute] : @"昨天";
    } else if(nowDateComponents.year == msgDateComponents.year) {
        //今年，MM/dd hh:mm
        result = [NSString stringWithFormat:@"%02d/%02d %ld:%02d", (int)msgDateComponents.month, (int)msgDateComponents.day, (long)msgDateComponents.hour, (int)msgDateComponents.minute];
    } else if(nowDateComponents.year != msgDateComponents.year) {
        //跨年， YY/MM/dd hh:mm
        NSString *day = [NSString stringWithFormat:@"%02d/%02d/%02d", (int)(msgDateComponents.year%100), (int)msgDateComponents.month, (int)msgDateComponents.day];
        result = showDetail ? [day stringByAppendingFormat:@" %@ %ld:%02d",result, (long)hour, (int)msgDateComponents.minute] : day;
    }
    return result;
}


@end

//
//  QYCustomStyleViewController.m
//  YSFDemo
//
//  Created by liaosipei on 2019/3/19.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "QYCustomStyleViewController.h"
#import "UIView+YSF.h"
#import "UIView+YSFToast.h"
#import "YSFAlertController.h"
#import "YSFCommonTableData.h"
#import "QYCommonCell.h"
#import "QYDataSourceConfig.h"
#import "QYSettingViewController.h"
#import "QYMacro.h"

#import <QYSDK/QYSDK.h>

static NSString * const kCustomStyleCellIdentifier = @"kCustomStyleCellIdentifier";


@interface QYCustomStyleViewController () <UITableViewDataSource, UITableViewDelegate, QYCommonCellActionDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation QYCustomStyleViewController
- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义聊天样式";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[QYDataSourceConfig sharedConfig].uiDataSource count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].uiDataSource[section];
    return tableSection.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].uiDataSource[section];
    return tableSection.footerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].uiDataSource[section];
    return [tableSection.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomStyleCellIdentifier];
    if (!cell) {
        cell = [[QYCommonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCustomStyleCellIdentifier];
    }
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].uiDataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    cell.rowData = tableRow;
    cell.actionDelegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].uiDataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    if (tableRow.uiRowHeight > 0) {
        return tableRow.uiRowHeight;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSFCommonTableSection *tableSection = [QYDataSourceConfig sharedConfig].uiDataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    [self didSelectRow:tableRow indexPath:indexPath];
}

#pragma mark - Action
- (void)didSelectRow:(YSFCommonTableRow *)rowData indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (rowData.type == QYCustomStyleTypeRestoreDefault) {
        [QYSettingData sharedData].isDefault = YES;
        [[[QYSDK sharedSDK] customUIConfig] restoreToDefault];
        [[QYDataSourceConfig sharedConfig] restoreUIToDefault];
        [self.tableView reloadData];
        [self showToast:@"已恢复默认设置"];
    } else if (rowData.type == QYCustomStyleTypeSessionBackground) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择聊天背景图片"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"无（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].sessionBackground = nil;
            rowData.result = @"无";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"图片1" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"session_bg_1"]];
            [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;
            rowData.result = @"图片1";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"图片2" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"session_bg_2"]];
            [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;
            rowData.result = @"图片2";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    }else if (rowData.type == QYCustomStyleTypeThemeColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择主题色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"蓝色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].themeColor = YSFQYBlueColor;
            rowData.result = @"蓝色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"橙色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].themeColor = [UIColor orangeColor];
            rowData.result = @"橙色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].themeColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeSessionTipColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择提示条背景颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"黄色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].sessionTipBackgroundColor = YSFQYTipBackColor;
            rowData.result = @"黄色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"蓝色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].sessionTipBackgroundColor = YSFRGBA2(0xff12b8fb);
            rowData.result = @"蓝色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].sessionTipBackgroundColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeSessionTipTextColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择提示条字体颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"黄色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].sessionTipTextColor = YSFQYTipTextColor;
            rowData.result = @"黄色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"白色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].sessionTipTextColor = [UIColor whiteColor];
            rowData.result = @"白色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"灰色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].sessionTipTextColor = [UIColor grayColor];
            rowData.result = @"灰色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeSessionTipTextSize) {
        YSFAlertController *alert = [YSFAlertController alertWithTitle:@"请输入提示条字体大小" message:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"默认：14";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alert addCancelActionWithHandler:nil];
        [alert addAction:[YSFAlertAction actionWithTitle:@"确定" handler:^(YSFAlertAction * _Nonnull action) {
            if (alert.textField.text.length) {
                CGFloat size = [alert.textField.text floatValue];
                if (size > 0 && size <= 30) {
                    size = MIN(size, 30);
                    [[QYSDK sharedSDK] customUIConfig].sessionTipTextFontSize = size;
                    rowData.result = [NSString stringWithFormat:@"%0.2f", size];
                    [weakSelf reloadCellForIndexPath:indexPath];
                    if (size != 14) {
                        [QYSettingData sharedData].isDefault = NO;
                    }
                }
            }
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeCustomerHeadImage) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择访客头像"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"默认" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [self getImageInBundle:@"icon_customer_avatar"];
            rowData.result = @"默认";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"头像1" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageNamed:@"customer_head"];
            rowData.result = @"头像1";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeCustomerMsgBubble) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择访客消息气泡"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"气泡1（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].customerMessageBubbleNormalImage = [[self getImageInBundle:@"bubble_sender_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 8, 8, 14) resizingMode:UIImageResizingModeStretch];
            [[QYSDK sharedSDK] customUIConfig].customerMessageBubblePressedImage = [[self getImageInBundle:@"bubble_sender_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 8, 8, 14) resizingMode:UIImageResizingModeStretch];
            rowData.result = @"气泡1";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"气泡2" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            UIImage *image = [[UIImage imageNamed:@"icon_sender_node"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 30, 30)
                              resizingMode:UIImageResizingModeStretch];
            [[QYSDK sharedSDK] customUIConfig].customerMessageBubbleNormalImage = image;
            [[QYSDK sharedSDK] customUIConfig].customerMessageBubblePressedImage = image;
            rowData.result = @"气泡2";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeCustomerMsgTextColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择访客消息字体颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"白色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [UIColor whiteColor];
            rowData.result = @"白色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"黑色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [UIColor blackColor];
            rowData.result = @"黑色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeCustomerMsgLinkColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择访客消息链接字体颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"白色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].customMessageHyperLinkColor = [UIColor whiteColor];
            rowData.result = @"白色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"蓝色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].customMessageHyperLinkColor = YSFRGBA2(0xff12b8fb);
            rowData.result = @"蓝色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].customMessageHyperLinkColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeCustomerMsgTextSize) {
        YSFAlertController *alert = [YSFAlertController alertWithTitle:@"请输入访客消息字体大小" message:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"默认：16";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alert addCancelActionWithHandler:nil];
        [alert addAction:[YSFAlertAction actionWithTitle:@"确定" handler:^(YSFAlertAction * _Nonnull action) {
            if (alert.textField.text.length) {
                CGFloat size = [alert.textField.text floatValue];
                if (size > 0 && size <= 30) {
                    size = MIN(size, 30);
                    [[QYSDK sharedSDK] customUIConfig].customMessageTextFontSize = size;
                    rowData.result = [NSString stringWithFormat:@"%0.2f", size];
                    [weakSelf reloadCellForIndexPath:indexPath];
                    if (size != 16) {
                        [QYSettingData sharedData].isDefault = NO;
                    }
                }
            }
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeServiceHeadImage) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择客服头像"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"默认" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [self getImageInBundle:@"icon_service_avatar"];
            rowData.result = @"默认";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"头像1" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"service_head"];
            rowData.result = @"头像1";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeServiceMsgBubble) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择客服消息气泡"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"气泡1（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].serviceMessageBubbleNormalImage = [[self getImageInBundle:@"bubble_receiver_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 14, 8, 8) resizingMode:UIImageResizingModeStretch];
            [[QYSDK sharedSDK] customUIConfig].serviceMessageBubblePressedImage = [[self getImageInBundle:@"bubble_receiver_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 14, 8, 8) resizingMode:UIImageResizingModeStretch];
            rowData.result = @"气泡1";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"气泡2" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            UIImage *image = [[UIImage imageNamed:@"icon_receiver_node"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(15, 30, 30, 15)
                              resizingMode:UIImageResizingModeStretch];
            [[QYSDK sharedSDK] customUIConfig].serviceMessageBubbleNormalImage = image;
            [[QYSDK sharedSDK] customUIConfig].serviceMessageBubblePressedImage = image;
            rowData.result = @"气泡2";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeServiceMsgTextColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择客服消息字体颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"黑色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = YSFQYTextGrayColor;
            rowData.result = @"黑色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"白色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [UIColor whiteColor];
            rowData.result = @"白色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeServiceMsgLinkColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择客服消息链接字体颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"蓝色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].serviceMessageHyperLinkColor = YSFQYBlueColor;
            rowData.result = @"蓝色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"白色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].serviceMessageHyperLinkColor = [UIColor whiteColor];
            rowData.result = @"白色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].serviceMessageHyperLinkColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeServiceMsgTextSize) {
        YSFAlertController *alert = [YSFAlertController alertWithTitle:@"请输入客服消息字体大小" message:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"默认：16";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alert addCancelActionWithHandler:nil];
        [alert addAction:[YSFAlertAction actionWithTitle:@"确定" handler:^(YSFAlertAction * _Nonnull action) {
            if (alert.textField.text.length) {
                CGFloat size = [alert.textField.text floatValue];
                if (size > 0 && size <= 30) {
                    size = MIN(size, 30);
                    [[QYSDK sharedSDK] customUIConfig].serviceMessageTextFontSize = size;
                    rowData.result = [NSString stringWithFormat:@"%0.2f", size];
                    [weakSelf reloadCellForIndexPath:indexPath];
                    if (size != 16) {
                        [QYSettingData sharedData].isDefault = NO;
                    }
                }
            }
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeTipMsgTextColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择提示消息字体颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"白色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].tipMessageTextColor = [UIColor whiteColor];
            rowData.result = @"白色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"蓝色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].tipMessageTextColor = YSFQYBlueColor;
            rowData.result = @"蓝色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].tipMessageTextColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeTipMsgTextSize) {
        YSFAlertController *alert = [YSFAlertController alertWithTitle:@"请输入提示消息字体大小" message:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"默认：12";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alert addCancelActionWithHandler:nil];
        [alert addAction:[YSFAlertAction actionWithTitle:@"确定" handler:^(YSFAlertAction * _Nonnull action) {
            if (alert.textField.text.length) {
                CGFloat size = [alert.textField.text floatValue];
                if (size > 0 && size <= 30) {
                    size = MIN(size, 30);
                    [[QYSDK sharedSDK] customUIConfig].tipMessageTextFontSize = size;
                    rowData.result = [NSString stringWithFormat:@"%0.2f", size];
                    [weakSelf reloadCellForIndexPath:indexPath];
                    if (size != 12) {
                        [QYSettingData sharedData].isDefault = NO;
                    }
                }
            }
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeMessageButtonTextColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择按钮文字颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"白色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].messageButtonTextColor = [UIColor whiteColor];
            rowData.result = @"白色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].messageButtonTextColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"灰色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].messageButtonTextColor = [UIColor grayColor];
            rowData.result = @"灰色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeMessageButtonBorderColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择按钮底色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"蓝色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].messageButtonBackColor = YSFQYBlueColor;
            rowData.result = @"蓝色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].messageButtonBackColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"灰色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].messageButtonBackColor = [UIColor grayColor];
            rowData.result = @"灰色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeActionBarTextColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择按钮文字颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"蓝色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].actionButtonTextColor = YSFQYBlueColor;
            rowData.result = @"蓝色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].actionButtonTextColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"灰色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].actionButtonTextColor = [UIColor grayColor];
            rowData.result = @"灰色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeActionBarBorderColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择按钮边框颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"蓝色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].actionButtonBorderColor = YSFQYBlueColor;
            rowData.result = @"蓝色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].actionButtonBorderColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"灰色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].actionButtonBorderColor = [UIColor grayColor];
            rowData.result = @"灰色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeInputTextColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择输入字体颜色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"黑色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].inputTextColor = YSFQYTextGrayColor;
            rowData.result = @"黑色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].inputTextColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeInputTextSize) {
        YSFAlertController *alert = [YSFAlertController alertWithTitle:@"请输入字体大小" message:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"默认：14";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alert addCancelActionWithHandler:nil];
        [alert addAction:[YSFAlertAction actionWithTitle:@"确定" handler:^(YSFAlertAction * _Nonnull action) {
            if (alert.textField.text.length) {
                CGFloat size = [alert.textField.text floatValue];
                if (size > 0 && size <= 30) {
                    size = MIN(size, 30);
                    [[QYSDK sharedSDK] customUIConfig].inputTextFontSize = size;
                    rowData.result = [NSString stringWithFormat:@"%0.2f", size];
                    [weakSelf reloadCellForIndexPath:indexPath];
                    if (size != 14) {
                        [QYSettingData sharedData].isDefault = NO;
                    }
                }
            }
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeInputTextPlaceholder) {
        YSFAlertController *alert = [YSFAlertController alertWithTitle:@"请输入占位文案" message:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"默认：请输入您要咨询的问题";
        }];
        [alert addCancelActionWithHandler:nil];
        [alert addAction:[YSFAlertAction actionWithTitle:@"确定" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].inputTextPlaceholder = alert.textField.text;
            rowData.result = alert.textField.text;
            [weakSelf reloadCellForIndexPath:indexPath];
            if (![alert.textField.text isEqualToString:@"请输入您要咨询的问题"]) {
                [QYSettingData sharedData].isDefault = NO;
            }
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeBottomMargin) {
        YSFAlertController *alert = [YSFAlertController alertWithTitle:@"请输入间距" message:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"默认：0";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alert addCancelActionWithHandler:nil];
        [alert addAction:[YSFAlertAction actionWithTitle:@"确定" handler:^(YSFAlertAction * _Nonnull action) {
            if (alert.textField.text.length) {
                CGFloat margin = [alert.textField.text floatValue];
                if (margin >= 0 && margin <= 500) {
                    margin = MIN(margin, 500);
                    [[QYSDK sharedSDK] customUIConfig].bottomMargin = margin;
                    rowData.result = [NSString stringWithFormat:@"%0.2f", margin];
                    [weakSelf reloadCellForIndexPath:indexPath];
                    if (margin != 0) {
                        [QYSettingData sharedData].isDefault = NO;
                    }
                }
            }
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeImagePickerColor) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择页面主题色"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"蓝色（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].imagePickerColor = YSFQYBlueColor;
            rowData.result = @"蓝色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"绿色" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].imagePickerColor = YSFRGBA2(0xff02c17c);
            rowData.result = @"绿色";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeSessionListEntranceImage) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择会话列表入口图片"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"默认" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].sessionListEntranceImage = [self getImageInBundle:@"icon_service_avatar"];
            rowData.result = @"默认";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"图片1" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].sessionListEntranceImage = [UIImage imageNamed:@"apple_logo"];
            rowData.result = @"图片1";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeMsgVerticalSpacing) {
        YSFAlertController *alert = [YSFAlertController alertWithTitle:@"请输入间距" message:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"默认：0";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alert addCancelActionWithHandler:nil];
        [alert addAction:[YSFAlertAction actionWithTitle:@"确定" handler:^(YSFAlertAction * _Nonnull action) {
            if (alert.textField.text.length) {
                CGFloat margin = [alert.textField.text floatValue];
                if (margin >= 0 && margin <= 500) {
                    margin = MIN(margin, 500);
                    [[QYSDK sharedSDK] customUIConfig].sessionMessageSpacing = margin;
                    rowData.result = [NSString stringWithFormat:@"%0.2f", margin];
                    [weakSelf reloadCellForIndexPath:indexPath];
                    if (margin != 0) {
                        [QYSettingData sharedData].isDefault = NO;
                    }
                }
            }
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeHeadMsgHorizontalSpacing) {
        YSFAlertController *alert = [YSFAlertController alertWithTitle:@"请输入间距" message:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"默认：4";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alert addCancelActionWithHandler:nil];
        [alert addAction:[YSFAlertAction actionWithTitle:@"确定" handler:^(YSFAlertAction * _Nonnull action) {
            if (alert.textField.text.length) {
                CGFloat margin = [alert.textField.text floatValue];
                if (margin >= 0 && margin <= 200) {
                    margin = MIN(margin, 200);
                    [[QYSDK sharedSDK] customUIConfig].headMessageSpacing = margin;
                    rowData.result = [NSString stringWithFormat:@"%0.2f", margin];
                    [weakSelf reloadCellForIndexPath:indexPath];
                    if (margin != 5) {
                        [QYSettingData sharedData].isDefault = NO;
                    }
                }
            }
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeBypassDisplayMode) {
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"选择访客分流展示样式"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"底部（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[QYSDK sharedSDK] customUIConfig].bypassDisplayMode = QYBypassDisplayModeBottom;
            rowData.result = @"底部";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"中间" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].bypassDisplayMode = QYBypassDisplayModeCenter;
            rowData.result = @"中间";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"无" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[QYSDK sharedSDK] customUIConfig].bypassDisplayMode = QYBypassDisplayModeNone;
            rowData.result = @"无";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    } else if (rowData.type == QYCustomStyleTypeMessagesLoadingStyle) {
        //读取loading图片数组
        UIImage *idleImg = [UIImage imageNamed:@"message_idle"];
        UIImage *willImg = [UIImage imageNamed:@"message_willLoad"];
        UIImage *loadingImg_1 = [UIImage imageNamed:@"message_loading_1"];
        UIImage *loadingImg_2 = [UIImage imageNamed:@"message_loading_2"];
        UIImage *loadingImg_3 = [UIImage imageNamed:@"message_loading_3"];
        UIImage *loadingImg_4 = [UIImage imageNamed:@"message_loading_4"];
        
        YSFAlertController *alert = [YSFAlertController actionSheetWithTitle:@"消息下拉刷新loading样式"];
        [alert addAction:[YSFAlertAction actionWithTitle:@"系统样式（默认）" handler:^(YSFAlertAction * _Nonnull action) {
            [[[QYSDK sharedSDK] customUIConfig] setMessagesLoadImages:nil duration:0 forState:QYMessagesLoadStateIdle];
            [[[QYSDK sharedSDK] customUIConfig] setMessagesLoadImages:nil duration:0 forState:QYMessagesLoadStateWillLoad];
            [[[QYSDK sharedSDK] customUIConfig] setMessagesLoadImages:nil duration:0 forState:QYMessagesLoadStateLoading];
            rowData.result = @"系统样式";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addAction:[YSFAlertAction actionWithTitle:@"自定义样式1" handler:^(YSFAlertAction * _Nonnull action) {
            [QYSettingData sharedData].isDefault = NO;
            [[[QYSDK sharedSDK] customUIConfig] setMessagesLoadImages:@[idleImg] duration:0 forState:QYMessagesLoadStateIdle];
            [[[QYSDK sharedSDK] customUIConfig] setMessagesLoadImages:@[willImg] duration:0 forState:QYMessagesLoadStateWillLoad];
            [[[QYSDK sharedSDK] customUIConfig] setMessagesLoadImages:@[loadingImg_1, loadingImg_2, loadingImg_3, loadingImg_4]
                                                             duration:0.2
                                                             forState:QYMessagesLoadStateLoading];
            rowData.result = @"自定义样式1";
            [weakSelf reloadCellForIndexPath:indexPath];
        }]];
        [alert addCancelActionWithHandler:nil];
        [alert showWithSender:nil arrowDirection:UIPopoverArrowDirectionAny controller:self animated:YES completion:nil];
    }
}

- (void)onTapSwitch:(YSFCommonTableRow *)cellData {
    if (cellData.type == QYCustomStyleTypePushMode) {
        [QYSettingData sharedData].isPushMode = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeRightItemStyle) {
        [[QYSDK sharedSDK] customUIConfig].rightItemStyleGrayOrWhite = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeCloseSessionEntrance) {
        [[QYSDK sharedSDK] customUIConfig].showCloseSessionEntry = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeAudioEntrance) {
        [[QYSDK sharedSDK] customUIConfig].showAudioEntry = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeAudioEntranceInRobotMode) {
        [[QYSDK sharedSDK] customUIConfig].showAudioEntryInRobotMode = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeEmoticonEntrance) {
        [[QYSDK sharedSDK] customUIConfig].showEmoticonEntry = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeCameraEntrance) {
        [[QYSDK sharedSDK] customUIConfig].showImageEntry = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeAutoShowKeyboard) {
        [[QYSDK sharedSDK] customUIConfig].autoShowKeyboard = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeShopEntrance) {
        [[QYSDK sharedSDK] customUIConfig].showShopEntrance = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeSessionListEntrance) {
        [[QYSDK sharedSDK] customUIConfig].showSessionListEntrance = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeSessionListEntrancePosition) {
        [[QYSDK sharedSDK] customUIConfig].sessionListEntrancePosition = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeShowHeadImage) {
        [[QYSDK sharedSDK] customUIConfig].showHeadImage = cellData.switchOn;
    } else if (cellData.type == QYCustomStyleTypeShowTopHeadImage) {
        [[QYSDK sharedSDK] customUIConfig].showTopHeadImage = cellData.switchOn;
    }
}

- (void)reloadCellForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath
        && indexPath.section < self.tableView.numberOfSections
        && indexPath.row < [self.tableView numberOfRowsInSection:indexPath.section]) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)showToast:(NSString *)toast {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC.view ysf_makeToast:toast duration:2.0 position:YSFToastPositionCenter];
}

- (UIImage *)getImageInBundle:(NSString *)imageName {
    NSString *name = [@"QYCustomResource.bundle" stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageNamed:name];
    if (!image) {
        name = [@"QYResource.bundle" stringByAppendingPathComponent:imageName];
        image = [UIImage imageNamed:name];
    }
    return image;
}

@end

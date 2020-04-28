//
//  QYMoreOptionViewController.m
//  YSFDemo
//
//  Created by liaosipei on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "QYMoreOptionViewController.h"
#import "QYSettingViewController.h"
#import "UIView+YSF.h"
#import "UIView+YSFToast.h"
#import "YSFCommonTableData.h"
#import "QYCommonCell.h"
#import "QYDemoConfig.h"
#import "QYSettingData.h"
#import "QYMacro.h"

#import <NIMSDK/NIMSDK.h>
#import <QYSDK/QYSDK.h>


@import AVFoundation;
@import MobileCoreServices;

static NSString * const kMoreOptionCellIdentifier = @"kMoreOptionCellIdentifier";


@interface QYMoreOptionViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, QYCommonCellActionDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) QYSessionViewController *sessionVC;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) YSFCommonTableRow *firstRow;
@property (nonatomic, strong) NSArray *optionData;

@property (nonatomic, assign) long long workOrderTemplateID;

@end

@implementation QYMoreOptionViewController
- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义+按钮";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"联系客服"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onChat:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
                                                          forState:UIControlStateNormal];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[QYCommonCell class] forCellReuseIdentifier:kMoreOptionCellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self makeData];
    self.workOrderTemplateID = 0;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)makeData {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:@{
                      YSFHeaderTitle : @"",
                      YSFRowContent : @[
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"显示+按钮",
                                  },
                              ],
                      YSFFooterTitle : @"",
                      }];
    [data addObject:@{
                      YSFHeaderTitle : @"",
                      YSFRowContent : @[
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"拍照",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"选照片",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"拍视频",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"选文件",
                              },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"结束会话",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"创建工单",
                              },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"发送文本",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"发送商品",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"发送订单",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"自定义1",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"自定义2",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"自定义3",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"自定义4",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"自定义5",
                                  },
                              @{
                                  YSFStyle : @(YSFCommonCellStyleSwitch),
                                  YSFTitle : @"自定义6",
                                  },
                              ],
                      YSFFooterTitle : @"",
                      }];
    self.dataSource = [YSFCommonTableSection sectionsWithData:data];
    YSFCommonTableSection *section_0 = [self.dataSource objectAtIndex:0];
    YSFCommonTableSection *section_1 = [self.dataSource objectAtIndex:1];
    self.firstRow = [section_0.rows objectAtIndex:0];
    self.optionData = section_1.rows;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFCommonTableSection *tableSection = self.dataSource[section];
    return [tableSection.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:kMoreOptionCellIdentifier forIndexPath:indexPath];
    cell.actionDelegate = self;
    YSFCommonTableSection *tableSection = self.dataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    cell.rowData = tableRow;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFCommonTableSection *tableSection = self.dataSource[indexPath.section];
    YSFCommonTableRow *tableRow = tableSection.rows[indexPath.row];
    if (tableRow.uiRowHeight > 0) {
        return tableRow.uiRowHeight;
    }
    return 50;
}

#pragma mark - QYCommonCellActionDelegate
- (void)onTapSwitch:(YSFCommonTableRow *)cellData {
    if ([cellData.title isEqualToString:@"创建工单"] && cellData.switchOn) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入工单模板ID"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        __weak typeof(self) weakSelf = self;
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([alert.textFields count]) {
                UITextField *textField = [alert.textFields firstObject];
                if (textField.text.length) {
                    NSInteger templateID = [textField.text integerValue];
                    if (templateID >= 0) {
                        weakSelf.workOrderTemplateID = templateID;
                    }
                }
            }
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 联系客服
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
    
    if (self.firstRow.switchOn) {
        NSMutableArray *items = [NSMutableArray array];
        __weak typeof(self) weakSelf = self;
        for (YSFCommonTableRow *rowData in self.optionData) {
            if ([rowData.title isEqualToString:@"拍照"] && rowData.switchOn) {
                [items addObject:[self makeCameraItem:rowData.title]];
            }
            if ([rowData.title isEqualToString:@"选照片"] && rowData.switchOn) {
                [items addObject:[self makePhotoLibraryItem:rowData.title]];
            }
            if ([rowData.title isEqualToString:@"拍视频"] && rowData.switchOn) {
                [items addObject:[self makeCameraItem:rowData.title]];
            }
            if ([rowData.title isEqualToString:@"选文件"] && rowData.switchOn) {
                [items addObject:[self makeFileItem:rowData.title]];
            }
            if ([rowData.title isEqualToString:@"结束会话"] && rowData.switchOn) {
                QYCustomInputItem *item = [self makeCustomItem];
                item.text = rowData.title;
                item.block = ^{
                    [weakSelf.sessionVC closeSession:NO completion:^(BOOL success, NSError *error) {
                        [weakSelf showToast:success ? @"退出接口完成回调-成功" : @"退出接口完成回调-失败"];
                    }];
                };
                [items addObject:item];
            }
            if ([rowData.title isEqualToString:@"创建工单"] && rowData.switchOn) {
                QYCustomInputItem *item = [self makeCustomItem];
                item.text = rowData.title;
                item.block = ^{
                    [weakSelf.sessionVC presentWorkOrderViewControllerWithTemplateID:weakSelf.workOrderTemplateID];
                };
                [items addObject:item];
            }
            if ([rowData.title isEqualToString:@"发送文本"] && rowData.switchOn) {
                [items addObject:[self makeTextItem]];
            }
            if ([rowData.title isEqualToString:@"发送商品"] && rowData.switchOn) {
                [items addObject:[self makeProductItem]];
            }
            if ([rowData.title isEqualToString:@"发送订单"] && rowData.switchOn) {
                [items addObject:[self makeOrderItem]];
            }
            if ([rowData.title hasPrefix:@"自定义"] && rowData.switchOn) {
                QYCustomInputItem *item = [self makeCustomItem];
                item.text = rowData.title;
                item.block = ^{
                    [weakSelf showToast:[NSString stringWithFormat:@"点击了按钮：%@", rowData.title]];
                };
                [items addObject:item];
            }
        }
        [[QYSDK sharedSDK] customUIConfig].customInputItems = items;
    } else {
        [[QYSDK sharedSDK] customUIConfig].customInputItems = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    /**
     * 创建QYSessionViewController
     */
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"自定义+按钮";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionVC = [[QYSDK sharedSDK] sessionViewController];
    sessionVC.sessionTitle = @"七鱼金融";
    sessionVC.source = source;
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
     * 订单点击事件
     */
    [QYCustomActionConfig sharedInstance].commodityActionBlock = ^(QYSelectedCommodityInfo *commodityInfo) {
        [weakSelf showToast:[NSString stringWithFormat:@"点击了订单：%@", QYStrParam(commodityInfo.p_name)]];
    };
    /**
     * push
     */
    sessionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionVC animated:YES];
    self.sessionVC = sessionVC;
}

- (QYCustomInputItem *)makePhotoLibraryItem:(NSString *)title {
    QYCustomInputItem *photoItem = [[QYCustomInputItem alloc] init];
    photoItem.normalImage = [UIImage imageNamed:@"icon_photo_normal"];
    photoItem.selectedImage = [UIImage imageNamed:@"icon_photo_pressed"];
    photoItem.text = title;
    __weak typeof(self) weakSelf = self;
    photoItem.block = ^{
        UIImagePickerController *imagePicker = [weakSelf makePhotoLibraryOrCamera:YES];
        [weakSelf.sessionVC presentViewController:imagePicker animated:YES completion:nil];
    };
    return photoItem;
}

- (QYCustomInputItem *)makeCameraItem:(NSString *)title {
    QYCustomInputItem *cameraItem = [[QYCustomInputItem alloc] init];
    cameraItem.normalImage = [UIImage imageNamed:@"icon_camera_normal"];
    cameraItem.selectedImage = [UIImage imageNamed:@"icon_camera_pressed"];
    cameraItem.text = title;
    __weak typeof(self) weakSelf = self;
    cameraItem.block = ^{
        if ([title isEqualToString:@"拍照"]) {
            UIImagePickerController *imagePicker = [weakSelf makePhotoLibraryOrCamera:NO];
            [weakSelf.sessionVC presentViewController:imagePicker animated:YES completion:nil];
        } else if ([title isEqualToString:@"拍视频"]) {
            [weakSelf.sessionVC shootVideoWithCompletion:^(NSString *filePath) {
                [weakSelf.sessionVC sendVideo:filePath];
            }];
        }
    };
    return cameraItem;
}

- (QYCustomInputItem *)makeFileItem:(NSString *)title {
    QYCustomInputItem *fileItem = [[QYCustomInputItem alloc] init];
    fileItem.normalImage = [UIImage imageNamed:@"icon_file_normal"];
    fileItem.selectedImage = [UIImage imageNamed:@"icon_file_pressed"];
    fileItem.text = title;
    __weak typeof(self) weakSelf = self;
    fileItem.block = ^{
        [weakSelf.sessionVC selectFileWithDocumentTypes:nil completion:^(NSString *fileName, NSString *filePath) {
            [weakSelf.sessionVC sendFileName:fileName filePath:filePath];
        }];
    };
    return fileItem;
}

- (QYCustomInputItem *)makeTextItem {
    QYCustomInputItem *textItem = [[QYCustomInputItem alloc] init];
    textItem.normalImage = [UIImage imageNamed:@"icon_file_normal"];
    textItem.selectedImage = [UIImage imageNamed:@"icon_file_pressed"];
    textItem.text = @"发送文本";
    __weak typeof(self) weakSelf = self;
    textItem.block = ^{
        [weakSelf.sessionVC sendText:@"这是一条文本消息"];
    };
    return textItem;
}

- (QYCustomInputItem *)makeProductItem {
    QYCustomInputItem *productItem = [[QYCustomInputItem alloc] init];
    productItem.normalImage = [UIImage imageNamed:@"icon_card_normal"];
    productItem.selectedImage = [UIImage imageNamed:@"icon_card_pressed"];
    productItem.text = @"发送商品";
    __weak typeof(self) weakSelf = self;
    productItem.block = ^{
        [weakSelf sendProduct];
    };
    return productItem;
}

- (void)sendProduct {
    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = @"商品标题";
    commodityInfo.desc = @"商品描述，不超过150字符 商品描述，不超过150字符 商品描述，不超过150字符";
    commodityInfo.urlString = @"https://qiyukf.com";
    commodityInfo.pictureUrlString = @"https://ysf.nosdn.127.net/44AC563D895637313F4F32DFD59C0708";
    commodityInfo.note = @"￥999.99";
    commodityInfo.show = YES;
    [self.sessionVC sendCommodityInfo:commodityInfo];
}

- (QYCustomInputItem *)makeOrderItem {
    QYCustomInputItem *orderItem = [[QYCustomInputItem alloc] init];
    orderItem.normalImage = [UIImage imageNamed:@"icon_snap_normal"];
    orderItem.selectedImage = [UIImage imageNamed:@"icon_snap_pressed"];
    orderItem.text = @"发送订单";
    __weak typeof(self) weakSelf = self;
    orderItem.block = ^{
        [weakSelf sendOrder];
    };
    return orderItem;
}

- (void)sendOrder {
    QYSelectedCommodityInfo *order = [[QYSelectedCommodityInfo alloc] init];
    order.target = @"target";
    order.params = @"params";
    order.p_status = @"已完成";
    order.p_img = @"https://ysf.nosdn.127.net/44AC563D895637313F4F32DFD59C0708";
    order.p_name = @"商品名称商品名称商品名称商品名称";
    order.p_price = @"￥999.99";
    order.p_count = @"已售出1w+";
    order.p_stock = @"还剩500000个";
    order.p_action = @"重新选择";
    order.p_url = @"https://qiyukf.com";
    order.p_userData = @"p_userData";
    [self.sessionVC sendSelectedCommodityInfo:order];
}

- (QYCustomInputItem *)makeCustomItem {
    QYCustomInputItem *customItem = [[QYCustomInputItem alloc] init];
    customItem.normalImage = [UIImage imageNamed:@"icon_message_normal"];
    customItem.selectedImage = [UIImage imageNamed:@"icon_message_pressed"];
    return customItem;
}

#pragma mark - camera
- (UIImagePickerController *)makePhotoLibraryOrCamera:(BOOL)photoLibraryOrCamera {
    if (!photoLibraryOrCamera) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"检测不到相机设备"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
            return nil;
        }
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            [[[UIAlertView alloc] initWithTitle:@"没有相机权限"
                                        message:@"请在iPhone的“设置-隐私-相机”选项中，允许访问你的相机。"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
            return nil;
        }
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = photoLibraryOrCamera ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    if (!photoLibraryOrCamera) {
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    return imagePicker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
    } else {
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        
        __weak typeof(self) weakSelf = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                [weakSelf.sessionVC sendPicture:orgImage];
            } else {
                UIImageWriteToSavedPhotosAlbum(orgImage, nil, nil, nil);
                [weakSelf.sessionVC sendPicture:orgImage];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - other
- (void)showToast:(NSString *)toast {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC.view ysf_makeToast:toast duration:2.0 position:YSFToastPositionCenter];
}

@end

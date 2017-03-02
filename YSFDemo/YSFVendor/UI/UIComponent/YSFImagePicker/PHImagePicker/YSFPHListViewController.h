//
//  YSFPHListViewController.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFImagePickerConfig.h"
#include <Photos/Photos.h>
@class YSFPHListViewController;

@protocol YSFPHListViewControllerDelegate <NSObject>

- (void)yxPLAssetListViewController:(YSFPHListViewController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)yxPLAssetListViewControllerDidCancel:(YSFPHListViewController *)picker;
@optional
- (void)yxPLAssetListViewController:(YSFPHListViewController *)picker didFinishPickingVideo:(NSString *)filepath;

@end

@interface YSFPHListViewController : UIViewController

// 相册列表
@property (strong) NSMutableArray *collectionsFetchResultsAssets;
// 相册标题列表
@property (strong) NSMutableArray *collectionsFetchResultsTitles;
// 相册ID
@property (strong) NSArray *collectionsLocalIdentifier;


@property (weak, nonatomic) id<YSFPHListViewControllerDelegate> plListDelegate;

- (instancetype)initWithImagePickerConfig:(YSFImagePickerConfig *)imagePickerConfig;

@end

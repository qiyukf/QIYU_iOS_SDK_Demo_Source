//
//  YSFPHGridViewController.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFIPAsset.h"
#import "YSFImagePickerConfig.h"
#include <Photos/Photos.h>

@class YSFPHGridViewController;

@protocol YSFPHGridViewControllerDelegate <NSObject>

@optional
- (void)yxPLAssetGridViewController:(YSFPHGridViewController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)yxPLAssetGridViewController:(YSFPHGridViewController *)picker didFinishPickingVideo:(NSString *)filepath;
- (void)yxPLAssetGridViewControllerDidCancel:(YSFPHGridViewController *)picker;
@end

@interface YSFPHGridViewController : UIViewController

@property (strong) PHFetchResult *assetsFetchResults;

@property (nonatomic, assign) BOOL                           isScrollToBottom;  // 这个属性在willAppear需要用到（左滑），不要优化掉 YSF
@property (weak, nonatomic) id<YSFPHGridViewControllerDelegate>       plGridDelegate;

- (instancetype)initWithImagePickerConfig:(YSFImagePickerConfig *)imagePickerConfig;

@end

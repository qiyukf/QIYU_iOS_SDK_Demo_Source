//
//  YSFPHImageViewController.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/14.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFIPPageView.h"
#import "YSFLargeImageView.h"
#import "YSFIPAsset.h"
#import "YSFImagePickerConfig.h"

#include <Photos/Photos.h>

@class YSFPHImageViewController;

@protocol YSFPHImageViewControllerDelegate <NSObject>

- (void)yxPLAssetImageViewController:(YSFPHImageViewController *)picker didFinishPickingImages:(NSArray *)images;

- (void)yxPLAssetImageViewController:(YSFPHImageViewController *)picker didFinishPickingVideo:(NSString *)filepath;

@end

@interface YSFPHImageViewController : UIViewController

@property (weak, nonatomic) id<YSFPHImageViewControllerDelegate> plImageDelegate;
@property (nonatomic, strong) YSFImagePickerConfig               *imagePickerConfig;

@property (assign, nonatomic) BOOL isPreview;   //预览选中的图片

- (id)initWithCapacity:(NSInteger)numItems
              showType:(ImagePickerShowType)showType
             snsAssets:(NSArray *)snsAssets
         objectAtIndex:(NSUInteger)index;

#pragma mark - PhotoKit
// 单独调用，预览一张图片，presentViewController
- (instancetype)initWithPHAsset:(PHAsset *)asset;

@end

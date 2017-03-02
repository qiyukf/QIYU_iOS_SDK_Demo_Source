//
//  YSFALImageViewController.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFIPAsset.h"
#import "YSFImagePickerConfig.h"

#import "YSFIPPageView.h"
#import "YSFLargeImageView.h"

@class YSFALImageViewController;

@protocol YSFALImageViewControllerDelegate <NSObject>

- (void)imagePickerPreviewViewController:(YSFALImageViewController *)picker didFinishPickingImages:(NSArray *)images;

@end

@interface YSFALImageViewController : UIViewController
<YSFPageViewDataSource,
YSFPageViewDelegate,
UIGestureRecognizerDelegate,
UIActionSheetDelegate,
YSFLargeImageViewDelegate>

@property (weak, nonatomic) id<YSFALImageViewControllerDelegate>             previewDelegate;
@property (nonatomic, strong) YSFImagePickerConfig               *imagePickerConfig;

@property (assign, nonatomic) BOOL isPreview;   //预览选中的图片

- (id)initWithCapacity:(NSInteger)numItems
              showType:(ImagePickerShowType)showType
             snsAssets:(NSArray *)snsAssets
         objectAtIndex:(NSUInteger)index;

// 单独调用，预览一张图片，presentViewController
- (instancetype)initWithALAsset:(ALAsset *)asset;

@end

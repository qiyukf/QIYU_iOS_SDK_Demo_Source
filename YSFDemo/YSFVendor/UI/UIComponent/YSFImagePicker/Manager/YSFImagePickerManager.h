//
//  YSFImagePickerManager.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/14.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//
//  提示：
//  1、调用系统相册和拍照的ActionSheet
//  2、调用自定义相片选择器
//  3、单独调用系统相册或拍照功能，使用扩展类UIImagePickerController+Block.h
//

#import <Foundation/Foundation.h>
#import "YSFIPAsset.h"
#import "YSFImagePickerConfig.h"

typedef void(^YXImagePickerActionSheetFinishBlock)(NSData *data);

@interface YSFImagePickerManager : NSObject

/// 调用系统相册和拍照功能的ActionSheet
- (void)imagePickerActionSheetInController:(UIViewController *)viewController
                          actionSheetTitle:(NSString *)actionSheetTitle
                               finishBlock:(YXImagePickerActionSheetFinishBlock)finishBlock;

/// 调用自定义相片选择器
- (void)showImagePickerInViewController:(UIViewController *)viewController
                      imagePickerConfig:(YSFImagePickerConfig *)imagePickerConfig;

- (void)showImagePickerInViewController:(UIViewController *)viewController
                      imagePickerConfig:(YSFImagePickerConfig *)imagePickerConfig usePhotoKit:(BOOL)usePhotoKit;

///检测相册访问权限
+ (void)checkAlbumPrivacy:(BOOL)showTip onComplete:(void (^)(BOOL haveAuthorization))complete;
@end

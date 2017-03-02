//
//  UIImagePickerController+Block.h
//  yixin_iphone
//
//  Created by 黄耀武 on 15/1/9.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YXImagePickerHelper.h"

typedef void(^YSFUIImagePickerControllerFinishBlock)(NSDictionary *info);
typedef void(^YSFUIImagePickerControllerCancelBlock)();

@interface UIImagePickerController (Block)

/// 系统拍照功能，不能编辑
+ (void)ysf_imagePickerWithFinishBlock:(YSFUIImagePickerControllerFinishBlock)finishBlock;

+ (void)ysf_imagePickerWithFinishBlock:(YSFUIImagePickerControllerFinishBlock)finishBlock useFrontCamera:(BOOL)useFrontCamera;

/// 系统相册或拍照功能，不能编辑
+ (void)ysf_imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
                      finishBlock:(YSFUIImagePickerControllerFinishBlock)finishBlock;
/// 系统相册或拍照功能
+ (void)ysf_imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
                    allowsEditing:(BOOL)allowsEditing
                      finishBlock:(YSFUIImagePickerControllerFinishBlock)finishBlock;

+ (void)ysf_imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
                    allowsEditing:(BOOL)allowsEditing
                      finishBlock:(YSFUIImagePickerControllerFinishBlock)finishBlock
                      cancelBlock:(YSFUIImagePickerControllerCancelBlock) cancelBlock;
@end

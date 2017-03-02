//
//  YSFALGridViewController.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSFImagePickerConfig;
@class YSFALGridViewController;


@protocol YSFALGridViewControllerDelegate <NSObject>

@optional
- (void)snsImagePickerViewController:(YSFALGridViewController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)snsImagePickerViewController:(YSFALGridViewController *)picker didFinishPickingVideo:(NSString *)filepath;
- (void)snsImagePickerViewControllerDidCancel:(YSFALGridViewController *)picker;
@end

@interface YSFALGridViewController : UIViewController

@property (nonatomic, assign) BOOL                           isScrollToBottom;  // 这个属性在willAppear需要用到（左滑），不要优化掉 YSF
@property (weak, nonatomic) id<YSFALGridViewControllerDelegate>       snsIPDelegate;

- (instancetype)initWithImagePickerConfig:(YSFImagePickerConfig *)imagePickerConfig;

@end

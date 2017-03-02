//
//  YSFALListViewController.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSFALListViewController;
@class YSFImagePickerConfig;

@protocol YSFALListViewControllerDelegate <NSObject>

- (void)snsAlbumPickerViewController:(YSFALListViewController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)snsAlbumPickerViewControllerDidCancel:(YSFALListViewController *)picker;
@optional
- (void)snsAlbumPickerViewController:(YSFALListViewController *)picker didFinishPickingVideo:(NSString *)filepath;

@end

@interface YSFALListViewController : UIViewController

@property (weak, nonatomic) id<YSFALListViewControllerDelegate>       snsAPDelegate;

- (instancetype)initWithImagePickerConfig:(YSFImagePickerConfig *)imagePickerConfig;

@end

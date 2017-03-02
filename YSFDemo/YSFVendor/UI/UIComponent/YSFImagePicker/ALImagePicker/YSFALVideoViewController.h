//
//  YSFALVideoViewController.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class YSFALVideoViewController;

@protocol YSFALVideoViewControllerDelegate <NSObject>

- (void)previewVideoViewController:(YSFALVideoViewController *)picker didFinished:(NSString *)filepath;

@end

@interface YSFALVideoViewController : UIViewController

@property (weak, nonatomic) id<YSFALVideoViewControllerDelegate>     pvDelegate;

- (id)initWithALAsset:(ALAsset *)asset;
- (instancetype)initWithUrl:(NSString *)aUrl;

@end

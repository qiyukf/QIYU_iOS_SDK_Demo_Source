//
//  UIImagePickerController+DoModal.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/14.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

@interface UIImagePickerController (DoModal)

- (void)ysf_doModal:(BOOL)animated;

@end

//
//  YSFPHAssetManager.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/14.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <Photos/Photos.h>

@interface YSFPHAssetManager : NSObject

+ (YSFPHAssetManager *)sharedInstance;

- (PHCachingImageManager *)phCachingImageManager;

- (PHImageRequestOptions *)phImageRequestOptions;

@end

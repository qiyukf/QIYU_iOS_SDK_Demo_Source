//
//  ALAssetHelper.h
//  yixin_iphone
//
//  Created by huangyaowu on 13-9-4.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include <Photos/Photos.h>
#import "YSFIPAsset.h"

@interface YSFALAssetHelper : NSObject

+ (UIImage *)getImage:(YSFIPAsset *)snsAsset original:(BOOL)original;

+ (UIImage *)getImageALAsset:(ALAsset *)asset original:(BOOL)original;

// photokit
+ (UIImage *)getImageFromPHAsset:(PHAsset *)asset original:(BOOL)original;

/**
 *  缩略图
 *
 *  @param asset PHAsset
 *
 *  @return UIImage
 */
+ (UIImage *)getThumbnailFromPHAsset:(PHAsset *)asset;
+ (UIImage *)getThumbnailFromPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize;


/**
 *  保存asset到本地
 *
 *  @param snsAsset SNSAsset
 *  @param filepath 本地路径
 *
 *  @return BOOL
 */
+ (BOOL)writeSNSAsset:(YSFIPAsset *)snsAsset toFilepath:(NSString *)filepath;

@end

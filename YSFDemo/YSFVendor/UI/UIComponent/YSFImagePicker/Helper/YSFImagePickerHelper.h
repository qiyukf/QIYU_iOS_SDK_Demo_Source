//
//  YSFImagePickerHelper.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSFIPAsset.h"
#import "YSFImagePickerConfig.h"

@interface YSFImagePickerHelper : NSObject

+ (YSFIPAsset *)selectedAsset:(YSFIPAsset *)snsAsset;
+ (NSArray *)filterPhotosAssets:(NSArray *)snsAssets;
+ (NSInteger)indexOfAsset:(YSFIPAsset *)snsAsset fromAssets:(NSArray *)assets;
+ (NSString *)cachedAssetsGroupID;
+ (NSArray *)sortedAssets;
+ (void)clearAssetManager:(BOOL)isSend;
+ (CGSize)assetGridThumbnailSize;
/// 图片转为NSData
+ (NSData *)imageDataWithInfo:(NSDictionary *)info edited:(BOOL)edited;

+ (UIImage*)getImageFromIPAsset:(YSFIPAsset*)snsAsset isHDImage:(BOOL)isHDImage;

+ (NSArray*)getImagesFromSelectedAssets:(NSArray*)seletedAssets isHDImage:(BOOL)isHDImage;
@end

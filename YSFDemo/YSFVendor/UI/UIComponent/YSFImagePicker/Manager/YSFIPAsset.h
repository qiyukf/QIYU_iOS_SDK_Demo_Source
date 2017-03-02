//
//  YSFIPAsset.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include <Photos/Photos.h>

@interface YSFIPAsset : NSObject

@property (nonatomic, strong) ALAsset       *asset;
@property (nonatomic, assign) BOOL           selected;
@property (nonatomic, strong) NSString      *dataSize;
@property (nonatomic, assign) NSInteger     index;

@property (nonatomic, strong) PHAsset       *phAsset;

@property (assign, nonatomic) BOOL isInTheCloud;

@property (assign, nonatomic) PHImageRequestID assetRequestID;

- (instancetype)initWithAsset:(ALAsset *)asset;

- (instancetype)initWithPHAsset:(PHAsset *)asset;

- (void)cancelAnyLoading;

@end

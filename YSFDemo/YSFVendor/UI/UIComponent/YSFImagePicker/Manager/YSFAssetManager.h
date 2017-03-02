//
//  YSFAssetManager.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSFIPAsset.h"

@interface YSFAssetManager : NSObject

@property (nonatomic, strong) ALAssetsGroup     *assetsGroup;   //其中一个Group
@property (nonatomic, strong) NSMutableArray    *assetsGroups;  // 所有Group
@property (nonatomic, strong) NSMutableArray    *selectedAssets;
@property (nonatomic, strong) NSString          *assetsGroupID;
@property (nonatomic, assign) BOOL               isHDImage;

// cachedSnsAssets, Key:groupID, Val:groupAssets
// groupAssets也是个Dic, Key:index, Val:snsAsset
@property (nonatomic, strong) NSMutableDictionary *cachedSnsAssets;

+ (instancetype)sharedManager;

@end

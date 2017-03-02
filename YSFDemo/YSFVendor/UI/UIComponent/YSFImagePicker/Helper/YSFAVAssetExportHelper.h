//
//  AVAssetExportHelper.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface YSFAVAssetExportHelper : NSObject

+ (void)sessionWithInputURL:(NSURL*)inputURL
                  outputURL:(NSURL*)outputURL
               blockHandler:(void (^)(AVAssetExportSession*))handler;

+ (void)sessionWithAVURLAsset:(AVAsset *)asset
                    outputURL:(NSURL *)outputURL
                 blockHandler:(void (^)(AVAssetExportSession*))handler;

@end



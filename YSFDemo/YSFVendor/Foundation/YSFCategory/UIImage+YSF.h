//
//  UIImage+YSFKit.h
//  YSFKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YSF)

+ (UIImage *)ysf_fetchImage:(NSString *)imageNameOrPath;


+ (CGSize)ysf_sizeWithImageOriginSize:(CGSize)originSize
                              minSize:(CGSize)imageMinSize
                              maxSize:(CGSize)imageMaxSiz;


@end

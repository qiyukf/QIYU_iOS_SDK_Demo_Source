//
//  QYAvatarImageView.h
//  YSFDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "YSFWebImageCompat.h"
#import "YSFWebImageManager.h"


@interface QYAvatarImageView : UIControl
@property (nonatomic,strong)    UIImage *image;
@property (nonatomic,assign)    BOOL    clipPath;

@end


@interface QYAvatarImageView (SDWebImageCache)
- (NSURL *)qy_imageURL;

- (void)qy_setImageWithURL:(NSURL *)url;
- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(YSFWebImageOptions)options;
- (void)qy_setImageWithURL:(NSURL *)url completed:(YSFWebImageCompletionBlock)completedBlock;
- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(YSFWebImageCompletionBlock)completedBlock;
- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(YSFWebImageOptions)options completed:(YSFWebImageCompletionBlock)completedBlock;
- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(YSFWebImageOptions)options progress:(YSFWebImageDownloaderProgressBlock)progressBlock completed:(YSFWebImageCompletionBlock)completedBlock;
- (void)qy_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(YSFWebImageOptions)options progress:(YSFWebImageDownloaderProgressBlock)progressBlock completed:(YSFWebImageCompletionBlock)completedBlock;
- (void)qy_cancelCurrentImageLoad;
- (void)qy_cancelCurrentAnimationImagesLoad;
@end

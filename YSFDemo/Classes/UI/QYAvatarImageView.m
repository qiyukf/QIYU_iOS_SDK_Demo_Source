//
//  QYAvatarImageView.m
//  YSFDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "QYAvatarImageView.h"
#import "objc/runtime.h"
#import "UIView+YSF.h"



static char imageURLKey;


@interface QYAvatarImageView()
@end

@implementation QYAvatarImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.geometryFlipped = YES;
        self.clipPath = YES;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.geometryFlipped = YES;
        self.clipPath = YES;
    }
    return self;
}


- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        _image = image;
        [self setNeedsDisplay];
    }
}


- (CGPathRef)path
{
    return [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                       cornerRadius:CGRectGetWidth(self.bounds) / 2] CGPath];
}


#pragma mark Draw
- (void)drawRect:(CGRect)rect
{
    if (!self.ysf_frameWidth || !self.ysf_frameHeight) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    if (_clipPath)
    {
        CGContextAddPath(context, [self path]);
        CGContextClip(context);
    }
    UIImage *image = _image;
    if (image && image.size.height && image.size.width)
    {
        //ScaleAspectFill模式
        CGPoint center   = CGPointMake(self.ysf_frameWidth * .5f, self.ysf_frameHeight * .5f);
        //哪个小按哪个缩
        CGFloat scaleW   = image.size.width  / self.ysf_frameWidth;
        CGFloat scaleH   = image.size.height / self.ysf_frameHeight;
        CGFloat scale    = scaleW < scaleH ? scaleW : scaleH;
        CGSize  size     = CGSizeMake(image.size.width / scale, image.size.height / scale);
        CGRect  drawRect = [self rectWithCenterAndSize:center size:size];
        CGContextDrawImage(context, drawRect, image.CGImage);
        
    }
    CGContextRestoreGState(context);
}

- (CGRect)rectWithCenterAndSize:(CGPoint)center size:(CGSize) size
{
    return CGRectMake(center.x - (size.width/2), center.y - (size.height/2), size.width, size.height);
}


@end


@implementation QYAvatarImageView (SDWebImageCache)

- (void)qy_setImageWithURL:(NSURL *)url {
    [self qy_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self qy_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(YSFWebImageOptions)options {
    [self qy_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)qy_setImageWithURL:(NSURL *)url completed:(YSFWebImageCompletionBlock)completedBlock {
    [self qy_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(YSFWebImageCompletionBlock)completedBlock {
    [self qy_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(YSFWebImageOptions)options completed:(YSFWebImageCompletionBlock)completedBlock {
    [self qy_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(YSFWebImageOptions)options progress:(YSFWebImageDownloaderProgressBlock)progressBlock completed:(YSFWebImageCompletionBlock)completedBlock {
    [self qy_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & YSFWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {
        __weak __typeof(self)wself = self;
        id <YSFWebImageOperation> operation = [YSFWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, YSFImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image && (options & YSFWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & YSFWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self ysf_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:YSFWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, YSFImageCacheTypeNone, url);
            }
        });
    }
}

- (void)qy_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(YSFWebImageOptions)options progress:(YSFWebImageDownloaderProgressBlock)progressBlock completed:(YSFWebImageCompletionBlock)completedBlock {
    NSString *key = [[YSFWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[YSFImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self qy_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (NSURL *)qy_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}


- (void)qy_cancelCurrentImageLoad {
    [self ysf_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)qy_cancelCurrentAnimationImagesLoad {
    [self ysf_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}


@end

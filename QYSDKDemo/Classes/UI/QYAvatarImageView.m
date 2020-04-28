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
#import "UIView+WebCacheOperation.h"


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

- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self qy_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)qy_setImageWithURL:(NSURL *)url completed:(SDInternalCompletionBlock)completedBlock {
    [self qy_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDInternalCompletionBlock)completedBlock {
    [self qy_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDInternalCompletionBlock)completedBlock {
    [self qy_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}


- (void)qy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDInternalCompletionBlock)completedBlock {
    [self qy_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {
        __weak __typeof(self)wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager loadImageWithURL:url options:options progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!wself) return;
            if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
            {
                completedBlock(image, data, error, cacheType, finished, imageURL);
                return;
            }
            else if (image) {
                wself.image = image;
                [wself setNeedsLayout];
            } else {
                if ((options & SDWebImageDelayPlaceholder)) {
                    wself.image = placeholder;
                    [wself setNeedsLayout];
                }
            }
            if (completedBlock && finished) {
                completedBlock(image, data, error, cacheType, finished, imageURL);
            }
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, nil, error, SDImageCacheTypeNone, NO, nil);
            }
        });
    }
}

- (void)qy_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDInternalCompletionBlock)completedBlock {
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self qy_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (NSURL *)qy_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}


- (void)qy_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)qy_cancelCurrentAnimationImagesLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}


@end

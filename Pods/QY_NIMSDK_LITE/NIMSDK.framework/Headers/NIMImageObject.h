//
//  NIMImageObject.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMMessageObjectProtocol.h"
#import "NIMPlatform.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *  图片格式
 */
typedef NS_ENUM(NSInteger, NIMImageFormat)
{
    /**
     *  Jpeg格式
     */
    NIMImageFormatJPEG,
    /**
     *  Png格式
     */
    NIMImageFormatPNG,
};

/**
 *  图片选项
 */
@interface NIMImageOption : NSObject
/**
*  压缩参数默认为 0.5,可传入0.0-1.0的值,如果传入非法参数，则按照 0.5 进行压缩
*/
@property (nonatomic,assign)    float compressQuality;

/**
 *  图片压缩格式,默认为JPEG
 */
@property (nonatomic,assign)    NIMImageFormat format;

@end

/**
 *  图片实例对象
 */
@interface NIMImageObject : NSObject<NIMMessageObject>

/**
 *  图片实例对象初始化方法
 *
 *  @param image 要发送的图片
 *
 *  @return 图片实例对象
 */
- (instancetype)initWithImage:(UIImage*)image;

/**
 *  图片实例对象初始化方法
 *
 *  @param filepath 要发送的图片路径
 *
 *  @discussion 使用此方法上传是不做压缩转换的原图上传。iOS 11 苹果采用了新的图片格式 HEIC ，如果采用原图会导致其他设备的兼容问题，请开发者在上层做好格式的兼容转换。
 *
 *  @return 图片实例对象
 */
- (instancetype)initWithFilepath:(NSString *)filepath;


/**
 *  图片实例对象初始化方法
 *
 *  @param data 图片数据
 *  @param extension 推荐使用的图片数据后缀名
 *
 *  @return 图片实例对象
 */
- (instancetype)initWithData:(NSData *)data
                   extension:(NSString *)extension;


/**
 *  图片实例对象初始化方法
 *
 *  @param image 要发送的图片
 *  @param scene 场景类别
 *
 *  @return 图片实例对象
 */
- (instancetype)initWithImage:(UIImage*)image scene:(NSString *)scene;


/**
 *  图片实例对象初始化方法
 *
 *  @param filepath 要发送的图片路径
 *  @param scene 场景类别
 *
 *  @discussion 使用此方法上传是不做压缩转换的原图上传。iOS 11 苹果采用了新的图片格式 HEIC ，如果采用原图会导致其他设备的兼容问题，请开发者在上层做好格式的兼容转换。
 *
 *  @return 图片实例对象
 */
- (instancetype)initWithFilepath:(NSString *)filepath scene:(NSString *)scene;


/**
 *  图片实例对象初始化方法, 可用于发送Webp图片
 *
 *  @param filepath 要发送的图片路径
 *  @param scene 场景类别
 *  @param size 图片宽高,当发送文件为Webp时须需要传入该图片尺寸大小
 *
 *  @discussion 使用此方法上传是不做压缩转换的原图上传。iOS 11 苹果采用了新的图片格式 HEIC ，如果采用原图会导致其他设备的兼容问题，请开发者在上层做好格式的兼容转换。
 *
 *  @return 图片实例对象
 */
- (instancetype)initWithFilepath:(NSString *)filepath
                           scene:(NSString *)scene
                            size:(CGSize)size;


/**
 *  图片实例对象初始化方法
 *
 *  @param data 图片数据
 *  @param extension 推荐使用的图片数据后缀名
 *  @param scene 场景类别
 *
 *  @return 图片实例对象
 */
- (instancetype)initWithData:(NSData *)data
                   extension:(NSString *)extension
                       scene:(NSString *)scene;


/**
 *  图片实例对象初始化方法, 可用于发送Webp图片
 *
 *  @param data 图片数据
 *  @param extension 推荐使用的图片数据后缀名
 *  @param scene 场景类别
 *  @param size 图片宽高,当发送文件为Webp时须需要传入该图片尺寸大小
 *
 *  @return 图片实例对象
 */
- (instancetype)initWithData:(NSData *)data
                   extension:(NSString *)extension
                       scene:(NSString *)scene
                        size:(CGSize)size;

/**
*  设置上传的url，用于发送已经上传好的资源
*
*  @param urlString 图片的地址
*
*/
- (void)setUploadURL:(NSString *)urlString;

/**
 *  文件展示名
 */
@property (nullable, nonatomic, copy) NSString *displayName;


/**
 *  图片本地路径
 *  @discussion 目前 SDK 没有提供下载大图的方法,但推荐使用这个地址作为图片下载地址,APP 可以使用自己的下载类或者 SDWebImage 做图片的下载和管理
 */
@property (nullable, nonatomic, copy, readonly) NSString *path;

/**
 *  缩略图本地路径
 */
@property (nullable, nonatomic, copy, readonly) NSString *thumbPath;


/**
 *  图片远程路径
 */
@property (nullable, nonatomic, copy, readonly) NSString *url;

/**
 *  缩略图远程路径
 *  @discussion 仅适用于使用云信上传服务进行上传的资源，否则无效。
 */
@property (nullable, nonatomic, copy, readonly) NSString *thumbUrl;

/**
 *  图片尺寸
 */
@property (nonatomic, assign, readonly) CGSize size;

/**
 *  图片选项
 *  @discussion 仅在发送时且通过 initWithImage: 方式初始化才有效
 */
@property (nullable, nonatomic ,strong) NIMImageOption *option;

/**
 *  文件大小
 */
@property (nonatomic, assign, readonly) long long fileLength;

/**
 *  图片MD5
 */
@property (nullable,nonatomic, copy, readonly) NSString *md5;
@end

NS_ASSUME_NONNULL_END

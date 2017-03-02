//
//  YSFImagePickerConfig.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 主要用来区分上传时的构造对象不一样
typedef enum : NSUInteger
{
    kSessionImagePickerShowType,    // 聊天页面相片选择器(除阅后即焚外，其它会显示原图按扭的)
    kSNSImagePickerShowType         // 朋友圈相片选择器(这个是不会显示原图按扭的)
} ImagePickerShowType;

typedef enum : NSUInteger
{
    kImagePickerMediaTypeAll,       // 包括相片和视频
    kImagePickerMediaTypePhoto      // 包括相片
} ImagePickerMediaType;

@interface YSFImagePickerConfig : NSObject

@property (nonatomic, assign) ImagePickerShowType   showType;
@property (nonatomic, assign) ImagePickerMediaType  imagePickerMediaType;
@property (nonatomic, assign) NSInteger             capacity;
@property (nonatomic, strong) NSString              *tip;       // 超过capacity时的提示文案
@property (nonatomic,   weak) id                    delegate;
@property (nonatomic, assign) NSUInteger            groupIndex;
@property (nonatomic, assign) BOOL                  sendHDImage;// 是否有发送原图功能，session有原图功能(除了阅后即焚)
@property (nonatomic, assign) BOOL                  editImage;  // 是否有编辑图片的功能

@end
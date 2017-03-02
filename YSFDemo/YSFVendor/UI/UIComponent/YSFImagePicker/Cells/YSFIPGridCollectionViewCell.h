//
//  YSFIPGridCollectionViewCell.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <Photos/Photos.h>
#import "YSFIPAsset.h"
#import "YSFImagePickerConfig.h"

@protocol YSFIPGridCollectionViewCellDelegate <NSObject>

- (void)overlayButtonPressed:(UIButton *)button withSNSAsset:(YSFIPAsset *)snsAsset;

@end

@interface YSFIPGridCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *overlayButton;
@property (strong, nonatomic) IBOutlet UIView *videoMetaView;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) YSFIPAsset              *snsAsset;
@property (weak, nonatomic) id<YSFIPGridCollectionViewCellDelegate> cellDelegate;

@property (strong) PHCachingImageManager *imageManager;

- (void)drawViewWithSNSAsset:(YSFIPAsset *)snsAsset
                   mediaType:(ImagePickerMediaType)mediaType;

@end

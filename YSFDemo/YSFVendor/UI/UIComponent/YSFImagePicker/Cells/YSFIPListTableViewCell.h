//
//  YSFImagePickerListTableViewCell.h
//  YSFImagePicker
//
//  Created by 黄耀武 on 16/3/11.
//  Copyright © 2016年 huangyaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSFIPListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *localizedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

+ (CGFloat)cellHeight;

@end

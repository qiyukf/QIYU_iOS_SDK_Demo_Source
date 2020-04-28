//
//  QYSessionListCell.h
//  YSFDemo
//
//  Created by JackyYu on 16/12/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYSessionInfo;

@interface QYSessionListCell : UITableViewCell


@property (nonatomic, strong) QYSessionInfo *sessionInfo;
@property (nonatomic,strong) UIImageView *trashWordsFailedIcon;

@end

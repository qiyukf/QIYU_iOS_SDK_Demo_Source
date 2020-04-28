//
//  QYCommonCell.h
//  YSFDemo
//
//  Created by liaosipei on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YSFCommonTableRow;

@protocol QYCommonCellActionDelegate <NSObject>

@optional
- (void)onTapSwitch:(YSFCommonTableRow *)cellData;

@end


@interface QYCommonCell : UITableViewCell

@property (nonatomic, weak) id <QYCommonCellActionDelegate> actionDelegate;
@property (nonatomic, strong) YSFCommonTableRow *rowData;

@end

NS_ASSUME_NONNULL_END

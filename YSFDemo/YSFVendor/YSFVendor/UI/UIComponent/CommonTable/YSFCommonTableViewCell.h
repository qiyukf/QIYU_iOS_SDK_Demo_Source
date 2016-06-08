//
//  YSFCommonTableViewCell.h
//  NIM
//
//  Created by chris on 15/6/29.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSFCommonTableRow;

@protocol YSFCommonTableViewCell <NSObject>

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@optional
- (void)refreshData:(YSFCommonTableRow *)rowData tableView:(UITableView *)tableView;

@end

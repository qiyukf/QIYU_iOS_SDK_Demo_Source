//
//  QYCommonCell.m
//  YSFDemo
//
//  Created by liaosipei on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "QYCommonCell.h"
#import "YSFCommonTableData.h"
#import "QYDemoBadgeView.h"
#import "UIView+YSF.h"

@interface QYCommonCell()

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UISwitch *onSwitch;

@property (nonatomic, strong) YSFDemoBadgeView *badgeView;

@end


@implementation QYCommonCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.textColor = [UIColor systemGrayColor];
        //右侧结果
        self.resultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.resultLabel.font = [UIFont systemFontOfSize:15];
        self.resultLabel.textColor = [UIColor grayColor];
        self.resultLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.resultLabel];
        //开关
        self.onSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self.onSwitch addTarget:self action:@selector(onTapSwitch:) forControlEvents:UIControlEventValueChanged];
        //badge
        self.badgeView = [[YSFDemoBadgeView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self addSubview:self.badgeView];
    }
    return self;
}

- (void)setRowData:(YSFCommonTableRow *)rowData {
    _rowData = rowData;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    //title
    if (@available(iOS 13.0, *)) {
        self.textLabel.textColor = [UIColor labelColor];
    } else {
        self.textLabel.textColor = [UIColor blackColor];
    }
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.text = rowData.title;
    //detailTitle
    self.detailTextLabel.text = rowData.detailTitle;
    //accessory
    self.accessoryView = nil;
    self.accessoryType = UITableViewCellAccessoryNone;
    //style
    if (rowData.style == YSFCommonCellStyleNormal) {
        if (rowData.result.length) {
            self.resultLabel.hidden = NO;
            self.resultLabel.text = rowData.result;
        } else {
            self.resultLabel.hidden = YES;
        }
        self.onSwitch.hidden = YES;
    } else if (rowData.style == YSFCommonCellStyleButton) {
        self.textLabel.textColor = [UIColor systemBlueColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.resultLabel.hidden = YES;
        self.onSwitch.hidden = YES;
    } else if (rowData.style == YSFCommonCellStyleSwitch) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.resultLabel.hidden = YES;
        self.onSwitch.hidden = NO;
        self.onSwitch.on = rowData.switchOn;
        self.accessoryView = self.onSwitch;
    } else if (rowData.style == YSFCommonCellStyleIndicator) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.resultLabel.hidden = YES;
        self.onSwitch.hidden = YES;
    }
    if (rowData.badge.length) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = rowData.badge;
    } else {
        self.badgeView.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat space = 15;
    CGFloat gap = 10;
    if (self.rowData.style == YSFCommonCellStyleNormal) {
        CGFloat resultWidth = width - space * 2 - gap - self.rowData.titleWidth;
        self.resultLabel.frame = CGRectMake(width - space - resultWidth, 0, resultWidth, height);
    }
    if (!self.badgeView.hidden) {
        self.badgeView.ysf_frameCenterY = (height / 2);
        self.badgeView.ysf_frameLeft = width - 40 - self.badgeView.ysf_frameWidth;
    }
}

- (void)onTapSwitch:(id)sender {
    self.rowData.switchOn = self.onSwitch.isOn;
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTapSwitch:)]) {
        [self.actionDelegate onTapSwitch:self.rowData];
    }
}

@end
